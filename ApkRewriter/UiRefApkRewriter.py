#!/usr/bin/env python
import sys
import subprocess
import shutil
import os
import errno
import codecs
from lxml import etree
from sys import platform
import imghdr
import fnmatch
import re
import multiprocessing

if platform == "linux" or platform == "linux2":
	TIMEOUTCMD = "timeout"
elif platform == "darwin":
	TIMEOUTCMD = "gtimeout"

class UiRefApkRewriter:
	def __init__(self, keystore, storepass, keystoreAlias, keypass, payloadDir, apktool="apktool", apktoolTimeout="600", apksigner="apksigner", apksignerTimeout="120", zipalign="zipalign", zipalignTimeout="120", keepDisassembledApks=False):
		self.keystore = keystore
		self.storepass = storepass
		self.keystoreAlias = keystoreAlias
		self.keypass = keypass
		self.payloadDir = payloadDir
		self.apktool = apktool
		self.apktoolTimeout = apktoolTimeout
		self.apksigner = apksigner
		self.zipalign = zipalign
		self.keepDisassembledApks = keepDisassembledApks
		self.apksignerTimeout = apksignerTimeout
		self.zipalignTimeout = zipalignTimeout

	def createApkToolCmd(self, apkPath, outputDir):
		return [self.apktool, "d", "-o", outputDir, apkPath]

	def getGenManifestName(self, appName):
		return "%s_generated_manifest.xml" % (appName,)

	def getExtractedLayoutFilename(self, appName):
		return "%s_com_benandow_ncsu_gui_layouts.txt" % (appName,)

	@staticmethod
	def ensureDirExists(path):
		dirname = os.path.dirname(path)
		if not os.path.exists(dirname):
			os.makedirs(dirname)

	def checkReturnValue(self, retVal, errorMessage):
		if retVal == 1:
			raise RuntimeError(errorMessage)

	def disassemble(self, apkPath, disassembledApkPath, forceDisassemble=True):
		if forceDisassemble and os.path.isdir(disassembledApkPath): # Re-disassemble
			shutil.rmtree(disassembledApkPath)
		# Let's ensure the directory structure exists
		UiRefApkRewriter.ensureDirExists(disassembledApkPath)
		#TODO redirect the output to a log file if we fail
		retVal = subprocess.call(self.createApkToolCmd(apkPath, disassembledApkPath))
		self.checkReturnValue(retVal, "ApkTool failed to disassemble %s." % (apkPath,))

	def copyPayload(self, disassembledApkPath, payloadRootDir):
		filesCreated = []
		for root, dirnames, filenames in os.walk(payloadRootDir):
			for f in filenames:
				filePath = os.path.join(root, f)
				outputPath = os.path.join(*[disassembledApkPath, "smali", os.path.relpath(filePath, payloadRootDir)])
				# Create directories if we need to...
				path = os.path.split(outputPath)[0]
				# Make the directory...
				if not os.path.exists(path):
					os.makedirs(path)
				shutil.copy(filePath, outputPath)
				filesCreated.append(outputPath)
		return filesCreated

	def deletePayload(self, payloadFiles):
		for payload in payloadFiles:
			# Delete file
			os.remove(payload)
			path = os.path.split(payload)[0]
			# Delete empty directories...
			while len(path) > 0 and not os.listdir(path):
				os.rmdir(path)
				path = os.path.split(path)[0]

	def getAppName(self, apkPath):
		basename = os.path.basename(apkPath)
		return os.path.splitext(basename)[0] if apkPath.endswith(".apk") else basename

	def rewriteManifest(self, disassembledApkPath):
		appName = self.getAppName(disassembledApkPath)
		attribNamespace = "http://schemas.android.com/apk/res/android"
		activityName = "com.benandow.android.gui.layoutRendererApp.GuiRipperActivity"
		attributes = {	"{"+attribNamespace+"}name" : activityName,
				"{"+attribNamespace+"}exported" : "true"}
		intentActionName = "%s.GuiRipper" % (re.sub("\-[0-9]+$", "", appName),)
		intentActionAttributes = {"{"+attribNamespace+"}name" : intentActionName}
		intentCategoryAttributes = {"{"+attribNamespace+"}name" : "android.intent.category.DEFAULT"}
		permAttributes = {"{"+attribNamespace+"}name" : "android.permission.WRITE_EXTERNAL_STORAGE"}
		tree = etree.parse(os.path.join(disassembledApkPath, "AndroidManifest.xml"))
		root = tree.getroot()
		writeExternalStoragePerm = False
		for child in root:
			if child.tag == "application":
				newActivity = etree.SubElement(child, "activity", attributes)
				intentFilter = etree.SubElement(newActivity, "intent-filter")
				intentAction = etree.SubElement(intentFilter, "action", intentActionAttributes)
				intentCategory = etree.SubElement(intentFilter, "category", intentCategoryAttributes)
			elif child.tag == "uses-permission" and child.get("name") == "android.permission.WRITE_EXTERNAL_STORAGE":
				writeExternalStoragePerm = True
		
		if not writeExternalStoragePerm:
			etree.SubElement(root, "uses-permission", permAttributes)
		tree.write(self.getGenManifestName(disassembledApkPath))

	# For some reason, a lot of apps have JPEGS with the PNG extension. ApkTool does not like this, so let's fix it.
	def fixPngEncodings(self, disassembledApk):
		for root, dirnames, filenames in os.walk(disassembledApk):
			for fname in fnmatch.filter(filenames, '*.png'):
				imgName = os.path.join(root, fname)
				if imghdr.what(imgName) != "png":
					# FIXME find a way to do this in pure Python
					subprocess.call(["mogrify", "-format", "png", "-flatten", imgName])

	def rewriteApk(self, disassembledApk, rewrittenAppPath):
		self.rewriteManifest(disassembledApk)
		self.fetchLayoutIds(disassembledApk)
		self.fixPngEncodings(disassembledApk)

		#Instantiate the unaligned and aligned output APKs
		unalignedApk = "%s_unaligned.apk" % (disassembledApk, )  # app_name+"_unaligned.apk"
		alignedApk= "%s_signed.apk" % (disassembledApk, ) # app_name+"_signed.apk"
		generatedManifest = self.getGenManifestName(disassembledApk)
		extractedLayouts = self.getExtractedLayoutFilename(disassembledApk)

		# If temp files already exist, delete them...
		if os.path.isfile(unalignedApk):
			os.remove(unalignedApk);
		if os.path.isfile(alignedApk):
			os.remove(alignedApk);

		#Copy the smali payload to the APK
		filesCreated = self.copyPayload(disassembledApk, self.payloadDir)

		# If we're keeping the disassembled APKs, then need to revert changes we make at the end...
		origManifest = "%s_original_manifest.xml" % (disassembledApk, ) if self.keepDisassembledApks else None
		androidManifest = os.path.join(disassembledApk, "AndroidManifest.xml")

		if origManifest is not None:
			if os.path.isfile(origManifest):
				os.remove(origManifest);
			shutil.copy(androidManifest, origManifest)
		
		#Copy the rewritten manifest
		shutil.copy(generatedManifest, androidManifest)
		# Create assets dir if doesn't exist
		assetsDir = os.path.join(disassembledApk, "assets")
		deleteAssetsDir = False
		if not os.path.exists(assetsDir):
			deleteAssetsDir = True
			os.mkdir(assetsDir)
		
		# Copy the extracted layouts to the assets folder
		extractedLayoutsApkPath = os.path.join(assetsDir, "com_benandow_ncsu_gui_layouts.txt")
		shutil.move(extractedLayouts, extractedLayoutsApkPath)

		#Remove prior signatures
		shutil.rmtree(os.path.join(disassembledApk, os.path.join("original", "META-INF"))) #Remove META-INF directory
	
		#Reassemble the APK
		retVal = subprocess.call([TIMEOUTCMD, self.apktoolTimeout, self.apktool, "b", "-f", "-o", unalignedApk, disassembledApk])
		self.checkReturnValue(retVal, "ApkTool failed to reassemble %s." % (disassembledApk,))

		#Align the APK -- newer versions of android require being aligned first...
		subprocess.call([TIMEOUTCMD, self.zipalignTimeout, self.zipalign, "-v", "4", unalignedApk, alignedApk])
		self.checkReturnValue(retVal, "ZipAlign failed to align %s." % (unalignedApk,))

		#Resign the APK
		retVal = subprocess.call([TIMEOUTCMD, self.apksignerTimeout, self.apksigner, "sign", "--verbose",
					"--ks", self.keystore, "--ks-pass", "pass:%s" % (self.storepass,), "--key-pass", "pass:%s" % (self.keypass,), "--ks-key-alias", self.keystoreAlias, alignedApk])

		# Old command using jarsigner
#		retVal = subprocess.call([self.apksigner, "-verbose", "-sigalg", "SHA1withRSA", "-digestalg", "SHA1",
#					"-keystore", self.keystore, "-storepass", self.storepass, "-keypass", self.keypass,
#					unalignedApk, self.keystoreAlias])
		self.checkReturnValue(retVal, "ApkSigner failed to re-sign %s." % (alignedApk,))

		#Verify the signature
		retVal = subprocess.call([TIMEOUTCMD, self.apksignerTimeout, self.apksigner, "verify", "--verbose", "--print-certs", alignedApk])
		self.checkReturnValue(retVal, "ApkSigner failed to verify %s." % (alignedApk,))

		# Move the aligned APK
		UiRefApkRewriter.ensureDirExists(rewrittenAppPath)
		shutil.move(alignedApk, rewrittenAppPath)
		
		#Remove all temp files
		if os.path.isfile(unalignedApk):
			os.remove(unalignedApk)
		if os.path.isfile(generatedManifest):
			os.remove(generatedManifest)
		if self.keepDisassembledApks: 
			# Restore the manifest
			shutil.move(origManifest, androidManifest)
			# Delete the payload
			self.deletePayload(filesCreated)
			# Delete the layouts written to assets
			os.remove(extractedLayoutsApkPath)
			if deleteAssetsDir:
				os.rmdir(assetsDir)
		else: # Remove disassembled app
			shutil.rmtree(disassembledApk)


	def fetchLayoutIds(self, path):
		ignoreList=[]
		resDir=os.path.join(path, "res")
		valDir=os.path.join(resDir, "values")
		
		#FIXME: Has to be a cleaner way to do this...
		for laydir in [ os.path.join(resDir, d) for d in os.listdir(resDir) if 'layout' in d ]:
			for layout in os.listdir(laydir): # Should not be any subdirs...
				tree = etree.parse(os.path.join(laydir, layout))
				for e in tree.iter("include"):
					if e.tag == "include":
						layoutName = e.get("layout")
						if layoutName.startswith("@"):
							lpath = layoutName[1:].split(os.sep)
							ignoreList.append(lpath[len(lpath)-1])
						else:
							ignoreList.append(layoutName);
				if layout.startswith("abc_"): # ignore ActionBarCompat layouts
					#TODO find a better way to ignore support layouts
					ignoreList.append(layout[:-len(".xml")])
	
		#TODO - Find out which views are actually unique and/or used
		with open("%s_com_benandow_ncsu_gui_layouts.txt" % (path,), "w") as outputFile:
			tree = etree.parse(os.path.join(valDir,"public.xml"))
			for child in tree.getroot():
				if child.get("type") == "layout" and child.get("name") not in ignoreList:
					outputFile.write(child.get("id")+"\n")

	def processApk(self, apkPath, disassembledApkPath, rewrittenApkPath):
		appName = self.getAppName(apkPath)
		disassembledApkPath = os.path.join(disassembledApkPath, appName)
		rewrittenApkPath = os.path.join(rewrittenApkPath, "%s.apk" % (appName,))
		if os.path.exists(rewrittenApkPath):#Ensure we don't rewrite again!
			return
		self.disassemble(apkPath, disassembledApkPath)
		self.rewriteApk(disassembledApkPath, rewrittenApkPath)

	@staticmethod
	def initFromConfig(configFile="config.xml", keepDisassembledApks=True):
		payload, keystore, storepass, keypass, keystoreAlias, apktool, apktoolTimeout, apksigner, zipalign = (None, None, None, None, None, "apktool", "600", "apksigner", "zipalign")

		tree = etree.parse(configFile)
		root = tree.getroot()
		for child in root:
			if child.tag == "payload":
				payload = child.get("location")
				if payload is None:
					raise IOError("Error parsing configuration file. Did not find payload.")
			elif child.tag == "keystore":
				keystore = child.get("location")
				if keystore is None:
					raise IOError("Error parsing configuration file. Did not find keystore.")
				storepass = child.get("storepass")
				if storepass is None:
					raise IOError("Error parsing configuration file. Did not find storepass.")
				keypass = child.get("keypass")
				if keypass is None:
					raise IOError("Error parsing configuration file. Did not find keypass.")
				keystoreAlias = child.get("keystoreAlias")
				if keystoreAlias is None:
					raise IOError("Error parsing configuration file. Did not find keystore alias.")
			elif child.tag == "apktool":
				apktool = child.get("location")
				if apktool is None:
					raise IOError("Error parsing configuration file. Did not find apktool location.")
				apktoolTimeout = child.get("timeout")
				if apktoolTimeout is None:
					apktoolTimeout = "600"
			elif child.tag == "apksigner":
				apksigner = child.get("location")
				if apksigner is None:
					raise IOError("Error parsing configuration file. Did not find apksigner location.")
			elif child.tag == "zipalign":
				zipalign = child.get("location")
				if zipalign is None:
					raise IOError("Error parsing configuration file. Did not find zipalign location.")
			else:
				print "Warning unrecognized option", child.tag
	
		if payload is None or keystore is None or storepass is None or keypass is None or keystoreAlias is None:
			raise IOError("Error parsing configuration file")

		return UiRefApkRewriter(keystore=keystore, storepass=storepass, keystoreAlias=keystoreAlias, keypass=keypass, payloadDir=payload, apktool=apktool, apktoolTimeout=apktoolTimeout, apksigner=apksigner, zipalign=zipalign, keepDisassembledApks=keepDisassembledApks)


def parallelizedClient(apkPath, disassembledApkPath, rewrittenApkPath, queue):
	ar = UiRefApkRewriter.initFromConfig()
	try:
		ar.processApk(apkPath, disassembledApkPath, rewrittenApkPath)
		queue.put(apkPath)
	except:
		queue.put("Error processing: %s" % (apkPath,))

def logWorker(queue):
	with open("apkrewriter.log", 'ab') as logfile:
		while True:
			msg = queue.get()
			if msg == "exit":
				logfile.write("Exiting")
				break
			logfile.write(msg)
			logfile.write("\n")
			logfile.flush()


def parallelizedRewrite(apkFilenameOrBaseDirectory, disassembledDirectory, rewrittenApkDirectory):
	if apkFilenameOrBaseDirectory is None or not os.path.exists(apkFilenameOrBaseDirectory):
		raise IOError("Error the file must be a directory or a text file of paths to APKs" % (apkFilenameOrBaseDirectory,))

	def findAllApks(apkBaseDirectory):
		apks = []
		for root, dirnames, filenames in os.walk(apkBaseDirectory):
			for f in fnmatch.filter(filenames, '*.apk'):
				apks.append(os.path.abspath(os.path.join(root, f)))
		return apks

	def readApks(apkFilename):
		return [ apk.strip() for apk in codecs.open(apkFilename, 'r', 'utf-8') ]

	# Read APKs
	isDirectory = os.path.isdir(apkFilenameOrBaseDirectory)
	apks = findAllApks(apkFilenameOrBaseDirectory) if isDirectory else readApks(apkFilenameOrBaseDirectory)
	if len(apks) <= 0:
		return

	manager = multiprocessing.Manager()
	queue = manager.Queue()

	cmdArgs = []
	for apk in apks:
		disassembledOutput = disassembledDirectory
		rewrittenOutput = rewrittenApkDirectory
		# Let's try our best to maintain the directory structure
		if isDirectory:
			relPath = os.path.split(os.path.relpath(apk, apkFilenameOrBaseDirectory))[0]
			disassembledOutput = os.path.join(disassembledDirectory, relPath)
			UiRefApkRewriter.ensureDirExists(disassembledOutput)
			rewrittenOutput = os.path.join(rewrittenApkDirectory, relPath)
			UiRefApkRewriter.ensureDirExists(rewrittenOutput)
		cmdArgs.append((apk, disassembledOutput, rewrittenOutput, queue))

	p = multiprocessing.Pool(multiprocessing.cpu_count())
	
	# Start up the logging process
	lwork = p.apply_async(logWorker, (queue, ))

	jobs = [ p.apply_async(parallelizedClient, args) for args in cmdArgs ]
	# Wait for the results...
	for j in jobs:
		j.wait()

	queue.put("exit")
	lwork.wait()
	p.close()




def main(argv):
	if len(argv) < 4:
		print "USAGE (%d): python %s <apkNameOrDirectory> <disassembledApkOutputDir> <reassembledApkOutputDir>" % (len(argv), argv[0] )
		sys.exit()

	apkName = sys.argv[1]
	disassembledApkOutputDir = sys.argv[2]
	reassembledApkOutputDir = sys.argv[3]

	# Process a single file
	if os.path.isfile(apkName) and apkName.endswith(".apk"):
		ar = UiRefApkRewriter.initFromConfig()
		ar.processApk(apkName, disassembledApkOutputDir, reassembledApkOutputDir)
	else:
		# Process the directory in parallel
		parallelizedRewrite(apkName, disassembledApkOutputDir, reassembledApkOutputDir)

if __name__ == "__main__": main(sys.argv)

