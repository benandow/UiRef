import parse_layout as layoutParser
import os
import re

def toUnicode(text):
	if not isinstance(text, unicode):
		text = unicode(text, 'utf-8').lower()
	return text

def readSensitiveTerms2():
	sdict = {}
	for line in open('SEMANTIC_BUCKETS.txt', 'r'):
		syns = re.sub(r'\s+\|\s+', u'|', toUnicode(line).strip()).split(u'|')
		syns = [re.sub(r'\s+', u'_', s.strip()) for s in syns]
		for s in syns:
			sdict[s] = syns[0]
	return sdict



def getLayoutFiles():
	FILENAME = 'LAYOUT_FILES.txt'
	if os.path.isfile(FILENAME):
		return [line.strip() for line in open(FILENAME, 'r')]
	return [] 


if __name__ == '__main__':
	apk_input_fields = {}
	sens_terms = readSensitiveTerms2()
	layout_files = getLayoutFiles()
	for apk in layout_files:
		package_name = re.sub(r'_[a-f0-9]{8}\.xml$', '', os.path.basename(apk))
		category = re.sub(r'/Users/benandow/Desktop/50K_DATASET/', '', apk).split('/')[0]
		package_name = "%s/%s" % (category, package_name)

		print "Processing",package_name

		if package_name not in apk_input_fields:
			apk_input_fields[package_name] = set()

		viewHierarchy = layoutParser.parseXmlFile(apk)
		plres = []
		plrestags = []
		for v in viewHierarchy.getOrdered():
			if v.is_input_field() and v.privacyTag is not None:
				splitTag = v.privacyTag.split("|")
				if len(splitTag) > 3:
					with open("EXCESSIVE_TAGS.txt","w") as excess_tagfile:
						excess_tagfile.write("%d: %s\n" % (len(splitTag),apk,))
				for tag in splitTag:
					if tag in sens_terms:
						apk_input_fields[package_name].add(sens_terms[tag])
						plres.append(sens_terms[tag])
						plrestags.append(tag)
					else:
						with open("SENS_TAG_ERROR.txt", "a") as errLog:
							errLog.write('%s\n' %(tag,))
		with open("FULL_LAYOUT_PTAGS.csv","a") as OUTPUT_FILE:
			OUTPUT_FILE.write('%s,%s\n' % (package_name,','.join(plres)))
		
		with open("FULL_LAYOUT_NO_SEMTAGS.csv","a") as OUTPUT_FILE:
			OUTPUT_FILE.write('%s,%s\n' % (package_name,','.join(plrestags)))

	with open("LAYOUTS_W_PRIVACY_TAGS.csv","w") as OUTPUT_FILE:
		for package_name in apk_input_fields:
			OUTPUT_FILE.write('%s,' % (package_name,))
			for tag in apk_input_fields[package_name]:
				OUTPUT_FILE.write('%s,' % (tag,))
			OUTPUT_FILE.write('\n')

