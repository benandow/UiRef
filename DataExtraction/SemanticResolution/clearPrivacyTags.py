from lxml import etree
import os
import re

def getLayoutFiles():
    FILENAME = 'LAYOUT_FILES.txt'
    if os.path.isfile(FILENAME):
        return [line.strip() for line in open(FILENAME, 'r')]
    return [] 


def iterNodeClear(node):
    if node.tag == u'View':
        try:
            if "privacyTag" in node.attrib:
                del node.attrib["privacyTag"]


        except:
            print "Failed to clear Privacy tag"
            pass
        
        try:
            if "suporPrivacyTag" in node.attrib:
                del node.attrib["suporPrivacyTag"]

        except:
            print "Failed to clear SUPOR tag"            
            pass
 
    for child in node.iterchildren():
        iterNodeClear(child)


def clearXmlTags(filename):
    try:
        tree = etree.parse(filename)
        iterNodeClear(tree.getroot())
        with open(filename, 'w') as xmlFile:
            xmlFile.write(etree.tostring(tree))
            xmlFile.close()
    except:
        pass

if __name__ == '__main__':
    layout_files = getLayoutFiles()
    for apk in layout_files:
        print "Clearing privacy tags for",apk
        clearXmlTags(apk)
