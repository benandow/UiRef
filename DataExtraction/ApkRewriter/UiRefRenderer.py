#!/usr/bin/env python

"""
Script to gracefully restart process after failure.
Makes the XML extraction process tolerant to views that require data.
1) Listen to stdin
2) Catch when a failure occurs in the APK we're testing
3) Resend an implicit intent when a failure occurs
4) Determine when we're done running the app

Author: Akhil Acharya & Ben Andow
Date: September 3, 2015
Updated: February 21, 2018
"""

import os
import sys
import subprocess
import re
import time
import codecs
import signal

#from adb import adb_commands
#from adb import sign_m2crypto
from sys import platform
if platform == "linux" or platform == "linux2":
	TIMEOUTCMD = "timeout"
elif platform == "darwin":
	TIMEOUTCMD = "gtimeout"

LOGCAT_TIMEOUT = 60 # 60 second timeout

# Timeout if we receive no input from logcat...
def logcatTimeout(signum, frame):
	raise Exception('Timeout reached without receiving logcat output.')


class UiRefRenderer:

	def __init__(self, adb="adb", rsaKeyPath="~/.android/adbkey", emulatorIpAddr="192.168.56.101:5555"):
		self.adb = adb
		self.emulatorIpAddr = emulatorIpAddr
		#self.rsaKeys = sign_m2crypto.M2CryptoSigner(os.path.expanduser(rsaKeyPath))
		#self.connectToDevice()
		############################# CONSTANTS #############################
		
		self.LOGCAT_WARNING = "W"
		self.LOGCAT_INFO = "I"
		self.LOGCAT_GUIRIPPER_TAG = "GuiRipper"
		self.LOGCAT_AMS_TAG = "ActivityManager"
		
		self.RENDER_MSG = "Rendering"
		self.SCREENDUMP_EXCEPT_MSG = "ScreendumpException"
		self.RENDER_EXCEPT_MSG = "RenderingException"
		self.RENDER_FAIL_MSG = "RenderingFailure"
		self.RENDER_DONE_MSG = "RenderingComplete"
		
		######################################################################
	
		################## Regex patterns for parsing logcat ##################
		
		#TODO rewrite logcat patterns...
		#Regex pattern for extracting message
		#	e.g., <PRIORITY>/<TAG>( <PID>): Rendering(<LAYOUT_ID>):<COUNTER>/<TOTAL>
		self.logcat_pattern = re.compile("""
					(?P<priority>.*?)\\/
					(?P<tag>.*?)
					\\(\s*(?P<pid>.*?)\\)\\:\s*
					(?P<message>.*)
					""", re.VERBOSE)
		
		#Regex pattern for extracting rendering status and exceptions
		#	<PRIORITY>/GuiRipper( <PID>): <MESSAGE>(<LAYOUT_ID>):<COUNTER>/<TOTAL>
		#	e.g., W/GuiRipper( 6807): Rendering(2130903065):2/377
		#	W/GuiRipper( 6807): ScreendumpException(2130903112):38/377
		#	W/GuiRipper( 6807): RenderingException(2130903153):78/377
		#	W/GuiRipper( 6983): RenderingFailure(2130903217):141/377
		#	W/GuiRipper( 6983): RenderingComplete(0):377/377
		self.render_log_pattern = re.compile("""
						(?P<output_message>.*?)
						\\((?P<layout_id>.*?)\\)\\:
						(?P<layout_counter>.*?)\\/
						(?P<layout_total>.*)
					""", re.VERBOSE)
		
		
		#Regex pattern for detecting failures
		#	W/ActivityManager( <PID>): Force finishing activity 1 <APK_NAME>/<ACTIVITY>"
		#	e.g., W/ActivityManager(  748):   Force finishing activity 1 com.test.test/com.benandow.android.gui.layoutRendererApp.GuiRipperActivity
		self.ams_log_failure_pattern = re.compile("""
						Force\\s+finishing\\s+activity\\s*\\d*\\s+
						(?P<package_name>.*?)
						\\/(?P<activity_name>.*)
					""", re.VERBOSE)
		
		
		#I/ActivityManager(  727): Process com.viewspection.internaluseonly (pid 30600) has died
		self.ams_log_failure_pattern2 = re.compile("""
						Process\\s+
						(?P<package_name>.*?)
						\\s+\\(pid\\s+(?P<pid>.*?)\\)\\s+has\\s+died
					""", re.VERBOSE)
	

		#Regex pattern for detecting failures
		#	W/ActivityManager( <PID>): Force finishing activity 1 <APK_NAME>/<ACTIVITY>"
		#	e.g., W/ActivityManager(  748):   Force finishing activity 1 com.test.test/com.benandow.android.gui.layoutRendererApp.GuiRipperActivity
		self.ams_log_failure_pattern = re.compile("""
						Force\\s+finishing\\s+activity\\s*\\d*\\s+
						(?P<package_name>.*?)
						\\/(?P<activity_name>.*)
					""", re.VERBOSE)

		#Regex pattern for detecting failures
		#	W/ActivityManager(  <PID>): Activity stop timeout for ActivityRecord{<HEXNUM> <NUM/LETTERS> <APK_NAME/<ACTIVITY> <NUM/LETTERS>}
		#	e.g., W/ActivityManager(  587): Activity stop timeout for ActivityRecord{28d356a u0 com.test.test/com.benandow.android.gui.layoutRendererApp.GuiRipperActivity t293}
		self.ams_log_failure_pattern3 = re.compile("""
						Activity\\s+stop\\s+timeout\\s+for\\s+
						ActivityRecord{[a-zA-Z0-9]+\\s+[a-zA-Z0-9]+\\s+
						(?P<package_name>.*?)\\/(?P<activity_name>.*)\\s+[a-zA-Z0-9]+}
					""", re.VERBOSE)
	


		######################################################################

	#def connectToDevice(self):
	#	self.device = adb_commands.AdbCommands.ConnectDevice(serial=self.emulatorIpAddr, rsa_keys=[self.rsaKeys])		

	def invokeAdbCommandWithTimeout(self, cmd, timeoutSeconds=u'180'):
		cmd.insert(0, timeoutSeconds)
		cmd.insert(0, TIMEOUTCMD)
		for i in xrange(0,3): # Repeat 3 times max...
			res = subprocess.call(cmd)
			if res != 124: # Does not equal value returned from timeout command
				break


	def installApk(self, apk, timeoutMs=3000):
		# The python lib doesn't support the -g option to allow all runtime permissions...
		self.invokeAdbCommandWithTimeout([self.adb, "-s", self.emulatorIpAddr, "install", "-g", "-r", apk])
#		print self.device.Install(apk_path=apk, timeout_ms=timeoutMs)

	def checkInstallSucess(self, packageName, timeoutMs=3000):
		for i in xrange(0, 3):
			popenObj = subprocess.Popen([self.adb, "-s", self.emulatorIpAddr, "shell", "pm", "list", "packages"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
			out,err = popenObj.communicate()
			if popenObj.returncode != 124:
				for pkg in out.split('\n'):
					if pkg is None or len(pkg.strip()) == 0:
						continue
					pkg = re.sub(r'^package:', u'', pkg.strip())
					if pkg == packageName:
						return True
		return False

	def uninstallApk(self, packageName, timeoutMs=3000):
		#self.device.Uninstall(package_name=packageName, timeout_ms=timeoutMs)
		self.invokeAdbCommandWithTimeout([self.adb, "-s", self.emulatorIpAddr, "uninstall", packageName])

	def clearLogcat(self):
		self.invokeAdbCommandWithTimeout([self.adb, "-s", self.emulatorIpAddr, "logcat", "-c"])		

	def forceStop(self, packageName):
		# The python lib doesn't support multiple commands yet and this may be called in the Logcat loop, so spawn a process instead
		# self.device.Shell("am force-stop %s" % (packageName,))
		self.invokeAdbCommandWithTimeout([self.adb, "-s", self.emulatorIpAddr, "shell", "am", "force-stop", packageName])

	def startRendering(self, packageName, forceStop=False):
		if forceStop:
			self.forceStop(packageName)
		# The python lib doesn't support multiple commands yet and this may be called in the Logcat loop, so spawn a process instead
		#self.device.Shell("am start -a %s.GuiRipper" % (packageName,))
		
		self.invokeAdbCommandWithTimeout([self.adb, "-s", self.emulatorIpAddr, "shell", "am", "start", "-a", "%s.GuiRipper" % (packageName,)])

	def pullFile(self, devicePath, outputPath):
		# For some reason, device.Pull tries to convert a bytearray to a string, which clearly breaks for images...
		#outputFile = codecs.open(outputPath, 'wb', 'utf-8')
		#self.device.Pull(device_filename=devicePath, dest_file=outputFile)
		print "adb pull", devicePath, outputPath
		self.invokeAdbCommandWithTimeout([self.adb, "-s", self.emulatorIpAddr, "pull", devicePath, outputPath])

	def wipeFiles(self, fileStr):
		# This is extremely buggy for some reason, just revert to adb for now...
		#self.device.Shell("rm %s" % (fileStr,))
		self.invokeAdbCommandWithTimeout([self.adb, "-s", self.emulatorIpAddr, "shell", "rm", fileStr])
	

	def readFiles(self, directory='/sdcard/'):
		# This is also extremely buggy for some reason, just revert to adb for now...
		# return [ fileinfo[0].decode() for fileinfo in self.device.List("/sdcard") ]
		for i in xrange(0, 3):
			popenObj = subprocess.Popen([self.adb, "-s", self.emulatorIpAddr, "shell", "ls", directory], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
			out,err = popenObj.communicate()
			if popenObj.returncode != 124:
				return [ line.strip() for line in out.split('\n') if line is not None and len(line.strip()) > 0 and (line.strip().endswith('.xml') or line.strip().endswith('.png')) ]
		return []

	#TODO duplication method... refactor
	@staticmethod
	def ensureDirExists(path):
		dirname = os.path.dirname(path)
		if not os.path.exists(dirname):
			os.makedirs(dirname)

	def extractData(self, resultDirectory, packageName):
		# Make layouts output directory
		layoutsOutputDirectory = os.path.join(*[resultDirectory, packageName, "layouts/"])
		UiRefRenderer.ensureDirExists(layoutsOutputDirectory)
		# Make screenshots output directory
		screenshotsOutputDirectory = os.path.join(*[resultDirectory, packageName, "screenshots/"])
		UiRefRenderer.ensureDirExists(screenshotsOutputDirectory)

		# For some reason after reading Logcat, the adb connection dies so let's reconnect		
		#self.connectToDevice()

		for filename in self.readFiles(directory='/sdcard/'):
			if filename.endswith(".xml"):
				self.pullFile(os.path.join("/sdcard/", filename), os.path.join(layoutsOutputDirectory, filename))
			elif filename.endswith(".png"):
				self.pullFile(os.path.join("/sdcard/", filename), os.path.join(screenshotsOutputDirectory, filename))
			
		self.wipeFiles("/sdcard/*.xml")
		self.wipeFiles("/sdcard/*.png")
		self.wipeFiles("/sdcard/*.txt")


	def startLogcat(self):
		# self.device.Logcat("-v brief") is also buggy
		return subprocess.Popen([self.adb, "-s", self.emulatorIpAddr, 'logcat', '-v', 'brief'], shell=False, stderr=subprocess.PIPE, stdout=subprocess.PIPE)

	def startMonitoring(self, package, logFile, maxTimeoutRetries=10, maxFailureRetries=10):

		self.clearLogcat()
		self.startRendering(package)
		logcatProcess = None
		numFailures = 0
		timeoutRetryCount = 0

		while True: # Outer loop for restarting due to timeouts...
			if timeoutRetryCount > maxTimeoutRetries:
				logFile.write(u'Hit max number of retries for {}\n'.format(package))
				print 'Hit max number of retries for', package
				return

			try:
				self.clearLogcat()
				process = self.startLogcat()
				signal.alarm(LOGCAT_TIMEOUT) # Start the timer
				for line in iter(process.stdout.readline, ''):
					if numFailures > 10:
						logFile.write(u'Exceeded number of failues for {}\n'.format(package))
						print 'Exceeded number of failures for', package
						return

					if not line:
						continue

					# Parse logcat line
					logcat_line_match = self.logcat_pattern.match(line)
					if not logcat_line_match:
						continue
	
					priority = logcat_line_match.group("priority")
					tag = logcat_line_match.group("tag")
					logcat_message = logcat_line_match.group("message")
	
					#If logging message from GUIRipper component
					if priority == self.LOGCAT_WARNING and tag == self.LOGCAT_GUIRIPPER_TAG:
						signal.alarm(0) # Found a relevant line, disable alarm...
						timeoutRetryCount = 0
						render_log_match = self.render_log_pattern.match(logcat_message)
	
						if not render_log_match:
							signal.alarm(LOGCAT_TIMEOUT) # Start the timer
							continue
	
						output_msg = render_log_match.group("output_message")
						layout_id = render_log_match.group("layout_id")
						layout_counter = render_log_match.group("layout_counter")
						layout_total = render_log_match.group("layout_total")
						numFailures = 0

						if output_msg == self.RENDER_MSG:
							logFile.write(u'Rendering {} {}/{}\n'.format(layout_id, layout_counter, layout_total))
							print "Rendering "+layout_id+" "+layout_counter+"/"+layout_total
						elif output_msg == self.RENDER_DONE_MSG:
							##START NEXT APK
							logFile.write(u'Finished {} {}/{}\n'.format(layout_id, layout_counter, layout_total))
							print "Finished "+layout_id+" "+layout_counter+"/"+layout_total
							return
						elif output_msg == self.SCREENDUMP_EXCEPT_MSG:
							#Log screeshot failure
							logFile.write(u'Screenshot failure {} {}/{}\n'.format(layout_id, layout_counter, layout_total))
							print "Screenshot failure "+layout_id+" "+layout_counter+"/"+layout_total
						elif output_msg == self.RENDER_EXCEPT_MSG:
							#Log failure
							logFile.write(u'Rendering Exception {} {}/{}\n'.format(layout_id, layout_counter, layout_total))
							print "Rendering Exception "+layout_id+" "+layout_counter+"/"+layout_total
						elif output_msg == self.RENDER_FAIL_MSG:
							#Log the failure
							logFile.write(u'Failure {} {}/{}\n'.format(layout_id, layout_counter, layout_total))
							print "Failure "+layout_id+" "+layout_counter+"/"+layout_total
					#Else if logging message from AMS (i.e., failure occurs)
					elif priority == self.LOGCAT_WARNING and tag == self.LOGCAT_AMS_TAG:
						ams_log_fail_match = self.ams_log_failure_pattern.match(logcat_message)
		
						if not ams_log_fail_match:
							ams_log_fail_match = self.ams_log_failure_pattern3.match(logcat_message)
							if not ams_log_fail_match:
								continue
	
						signal.alarm(0) # Found a relevant line, disable alarm...
						timeoutRetryCount = 0

						package_name = ams_log_fail_match.group("package_name")
						activity_name = ams_log_fail_match.group("activity_name")
						logFile.write(u'Failure occurred ({}) for package {}. Restarting rendering\n'.format(numFailures, package))
						print "Failure occurred: restart rendering", numFailures, package
						numFailures += 1
						self.startRendering(package, forceStop=True)
					elif priority == self.LOGCAT_INFO and tag == self.LOGCAT_AMS_TAG:
						ams_log_fail_match2 = self.ams_log_failure_pattern2.match(logcat_message)
						
						if not ams_log_fail_match2:
							continue
	
						signal.alarm(0) # Found a relevant line, disable alarm...
						timeoutRetryCount = 0

						package_name = ams_log_fail_match2.group("package_name")
						logFile.write(u'Failure occurred ({}) for package {}. Restarting rendering\n'.format(numFailures, package))
						print "Failure occurred: restart rendering", numFailures
						numFailures += 1
						self.startRendering(package, forceStop=True)

					# Reset the timer...
					signal.alarm(LOGCAT_TIMEOUT) # Reset the timer...
			except:
				logFile.write(u'Timeout occurred for package {}. Restarting rendering\n'.format(package))
				timeoutRetryCount += 1
				if process is not None: # Kill the logcat listener instance
					process.kill()
				self.startRendering(package, forceStop=True)
				


	#TODO duplication method... refactor
	@staticmethod
	def getAppName(apkPath):
		basename = os.path.basename(apkPath)
		return os.path.splitext(basename)[0] if apkPath.endswith(".apk") else basename

	@staticmethod
	def stripVersionNumber(appName):
		return re.sub("\-[0-9]+$", "", appName)


	### Main entrypoint for ripping GUIs from APK
	def ripGUIs(self, apkPath, outputPath):
		packageName = UiRefRenderer.getAppName(apkPath)
		packageNameWoVersion = UiRefRenderer.stripVersionNumber(packageName)

		# If we already processed the layout, skip
		if os.path.exists(os.path.join(outputPath, packageName)):
			return



		# Uninstall first if already installed...
		preinstalled = False
		if self.checkInstallSucess(packageNameWoVersion):
			self.uninstallApk(packageNameWoVersion)
			preinstalled = True

		UiRefRenderer.ensureDirExists(outputPath)
		self.installApk(apkPath)
		logFile = codecs.open(os.path.join(outputPath, u'{}.log'.format(packageName)), 'w', 'utf-8')

		if not self.checkInstallSucess(packageNameWoVersion):
			logFile.write(u'Install failed for {}\n'.format(packageName))
			print 'Install failed...', packageName
			return

		self.startMonitoring(packageNameWoVersion, logFile=logFile)
		self.forceStop(packageNameWoVersion)
		self.extractData(outputPath, packageName)
		if not preinstalled:
			self.uninstallApk(packageNameWoVersion)


	############################## Testing ###############################
	
	#line ="W/GuiRipper( 6807): Rendering(2130903065):2/377"
	#line ="W/GuiRipper( 6807): ScreendumpException(2130903112):38/377"
	#line ="W/GuiRipper( 6807): RenderingException(2130903153):78/377"
	#line ="W/GuiRipper( 6983): RenderingFailure(2130903217):141/377"
	#line ="W/GuiRipper( 6983): RenderingComplete(0):377/377"
	#line = "W/ActivityManager(  748):   Force finishing activity 1 com.test.test/com.benandow.android.gui.layoutRendererApp.GuiRipperActivity"
	#line = "W/ActivityManager(  587): Activity stop timeout for ActivityRecord{28d356a u0 com.test.test/com.benandow.android.gui.layoutRendererApp.GuiRipperActivity t293}"
	
	def regex_test(self, line):
		logcat_line_match = self.logcat_pattern.match(line)
		priority = logcat_line_match.group("priority")
		tag = logcat_line_match.group("tag")
		message = logcat_line_match.group("message")
		print "PRIORITY = %s\nTAG = %s\nMESSAGE = %s\n\n" % (priority, tag, message)
		if priority == self.LOGCAT_WARNING and tag == self.LOGCAT_GUIRIPPER_TAG:
			render_log_match = self.render_log_pattern.match(message)
			output_msg = render_log_match.group("output_message")
			layout_id = render_log_match.group("layout_id")
			layout_counter = render_log_match.group("layout_counter")
			layout_total = render_log_match.group("layout_total")
			print "MSG = %s\nLAYOUT ID = %s\nCOUNTER=%s\nTOTAL=%s\n\n" % (output_msg, layout_id, layout_counter, layout_total)
		elif priority == self.LOGCAT_WARNING and tag == self.LOGCAT_AMS_TAG:
			ams_log_fail_match = self.ams_log_failure_pattern.match(message)
			if not ams_log_fail_match:
				ams_log_fail_match = self.ams_log_failure_pattern3.match(message)
			package_name = ams_log_fail_match.group("package_name")
			activity_name = ams_log_fail_match.group("activity_name")
			print "PACKAGE = %s\nACTIVITY = %s\n\n" % (package_name, activity_name)
		elif priority == self.LOGCAT_INFO and tag == self.LOGCAT_AMS_TAG:
			ams_log_fail_match2 = self.ams_log_failure_pattern2.match(message)
			package_name = ams_log_fail_match2.group("package_name")
			print "PACKAGE_FAIL = %s\n" % (package_name,)


	


	######################################################################

def main(adbLocation, emulatorIpAddr, apkName, resultsDirectory):
	signal.signal(signal.SIGALRM, logcatTimeout) # Register our alarm...
	UiRefRenderer(adb=adbLocation, emulatorIpAddr=emulatorIpAddr).ripGUIs(apkName, resultsDirectory)

def mainWalk(adbLocation, emulatorIpAddr, apksLocation, resultsDirectory):
	for root,dirnames,files in os.walk(apksLocation):
		for filename in files:
			if filename.endswith('.apk'):
				main(adbLocation, emulatorIpAddr, os.path.join(root, filename), resultsDirectory)


if __name__ == '__main__':
	if len(sys.argv) < 5:
		print "Usage: %s <adbLocation> <emulatorIpAddr> <apkName> <resultsDirectory>"
		sys.exit(1)
	mainWalk(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])

