import os

def mkdirINE(path):
	dirname = os.path.dirname(path)
	if not os.path.exists(dirname):
		os.makedirs(dirname)


def getAppName(apkPath):
	basename = os.path.basename(apkPath)
	return os.path.splitext(basename)[0] if apkPath.endswith(".apk") else basename


