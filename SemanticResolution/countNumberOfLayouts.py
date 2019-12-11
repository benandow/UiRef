import parse_layout as lp
import os
import sys
import re

aprivtag_cnt = 0
alab_cnt = 0
total_ifield = 0

def getLayoutFiles():
    FILENAME = 'LAYOUT_FILES.txt'
    if os.path.isfile(FILENAME):
        return [line.strip() for line in open(FILENAME, 'r')]
    return [] 


def trav(viewHierarchy):
    global aprivtag_cnt
    global alab_cnt
    global total_ifield

    for v in viewHierarchy.getOrdered():
        if v.is_edit_text():
            total_ifield += 1
            if v.annotatedPrivacyTag is not None:
                aprivtag_cnt += 1
            if v.annotatedLabelCounter is not None:
                alab_cnt += 1

#            if v.suporLabelCounter != v.annotatedLabelCounter:
#
#
#            if v.suporLabelCounter != v.annotatedLabelCounter:
#                
#
#                suporLabelCounter
#
#                annotatedPrivacyTag
#                annotatedLabelCounter

if __name__ == '__main__':
    layout_files = getLayoutFiles()
    for apk in layout_files:
        viewHierarchy = lp.parseXmlFile(apk)
        trav(viewHierarchy)

    print aprivtag_cnt, alab_cnt, total_ifield
