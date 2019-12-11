#!/usr/bin/env python


import parse_layout as layoutParser

cntDict = {}

for line in open('EVAL_AMBIG_TERM_RES_PER_LAYOUT.csv','rb'):
	splitLine = line.strip().split(',')
	if splitLine[0].startswith('RESOLVED_'):
		viewHierarchy = layoutParser.parseXmlFile(splitLine[1])
		for v in viewHierarchy.getOrdered():
			if v.is_input_field() and v.is_edit_text() and v.counter == splitLine[2]:
				if splitLine[3] not in cntDict:
					cntDict[splitLine[3]] = [0,0, 0]
				cntDict[splitLine[3]][2] += 1
				if v.annotatedPrivacyTag is not None:
					cntDict[splitLine[3]][0] += 1
					print '%s,%s' % (v.annotatedPrivacyTag, line.strip(),)
				else:
					cntDict[splitLine[3]][1] += 1					

for key in cntDict:
	print key, cntDict[key]
