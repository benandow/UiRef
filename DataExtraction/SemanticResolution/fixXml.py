from lxml import etree
from io import BytesIO
import os
import re
import sys

ROOT_DIR = '/Users/benandow/Desktop/UiRefOpenSource/RESULTS/'

error_regex = re.compile("xmlParseCharRef:\\s+invalid\\s+xmlChar\\s+value\\s+(?P<value>[0-9]+?),\\s+line\\s+(?P<lnum>[0-9]+?),\\s+column\\s+(?P<col>[0-9]+?)", re.VERBOSE)


def parseXmlFile(filename):
	tree = etree.parse(BytesIO(filename))
	return tree

def cleanXml(xmlText, illegal_vals):
	while True:
		try:
			tree = parseXmlFile(xmlText)
			break
		except etree.XMLSyntaxError as e:
			rmatch = error_regex.match(e.__str__().lstrip().rstrip())
			if not rmatch:
				print e.__str__()
				sys.exit(0)
			val = rmatch.group('value')
			xmlText = re.sub(r'&#%s;' % (val,), ' ',xmlText)
			illegal_vals.add(val)
	return xmlText


if __name__ == '__main__':
	illegal_vals = set()
	count = 0
	for root,dirs,filenames in os.walk(ROOT_DIR):
		for f in filenames:
                        if not f.endswith('.xml'):
                            continue
			with open(os.path.join(root, f), 'r') as xmlFile:
				xmlText = xmlFile.read()
				origText = xmlText
				xmlText = cleanXml(xmlText, illegal_vals)

				if xmlText != origText:
					count += 1
					with open(os.path.join(root, f), 'w') as xmlFile:
						xmlFile.write(xmlText)
						xmlFile.close()

	for v in illegal_vals:
		print v

	print "Total broken files = %d" % (count,)
			


