#!/usr/bin/env python

import sys

inputFieldCount = {}
layoutCount = {}
totalLayout = set()
applicationCount = {}
totalApp = set()
totalAppAmbig = set()
totalLayoutAmbig = set()
totalIfields = 0
totalIFCnt = 0

terms_list = ['account_number', 'address', 'age', 'cc', 'cm', 'day', 'destination', 'first', 'ft', 'height', 'last', 'lb', 'location', 'month', 'name', 'number', 'security_code', 'weight', 'year']

for line in open(sys.argv[1], 'rb'):
	splitLine = line.strip().split(',')
	layout = splitLine[1]
	appName = splitLine[1].split('/')[7]
	totalApp.add(appName)
	totalLayout.add(layout)
	if splitLine[0].startswith('RESOLVED'):
		term = splitLine[3]
		if term not in terms_list:
			continue
		totalIFCnt += 1
		totalIfields += 1
		totalAppAmbig.add(appName)
		totalLayoutAmbig.add(layout)
		if term not in layoutCount:
			layoutCount[term] = set()
		layoutCount[term].add(layout)
		if term not in applicationCount:
			applicationCount[term] = set()
		applicationCount[term].add(appName)
		if term not in inputFieldCount:
			inputFieldCount[term] = 0
		inputFieldCount[term] += 1
	elif splitLine[0].startswith('NOT'):
		totalIfields += 1


tapps = float(len(totalApp))
tlayouts = float(len(totalLayout))

for term in inputFieldCount:
	print '\t%s & %d (%f) & %d (%f)  & %d(%f)\n ' % (term, inputFieldCount[term], (float(inputFieldCount[term])/float(totalIfields)*100.0), len(layoutCount[term]), (float(len(layoutCount[term]))/tlayouts*100.0), len(applicationCount[term]), (float(len(applicationCount[term]))/tapps*100.0) ),

tambapps = float(len(totalAppAmbig))
tamblayouts = float(len(totalLayoutAmbig))
print "%d/%d (%f) & %d/%d (%f) & %d/%d (%f)" % (totalIFCnt, float(totalIfields), (float(totalIFCnt)/float(totalIfields)*100.0),tambapps, tapps, (tambapps/tapps*100.0), tamblayouts, tlayouts, (tamblayouts/tlayouts*100.0))

#TotalApp(%d/%d - %f) TotalLayout(%d/%d - %f) " % (tambapps, tapps, (tambapps/tapps*100.0), tamblayouts, tlayouts, (tamblayouts/tlayouts*100.0))
#print "InputFields = %d/%f (%f)" % (totalIFCnt, totalIfields, (float(totalIFCnt)/totalIfields))

#  Key(destination) InputFields(165) LayoutCount(158 - 0.002216) AppCount(141 - 0.009014)
#  Key(lb) InputFields(3056) LayoutCount(1548 - 0.021714) AppCount(1533 - 0.098005)
#  Key(name) InputFields(9753) LayoutCount(9497 - 0.133215) AppCount(7403 - 0.473277)
#  Key(cm) InputFields(1599) LayoutCount(1569 - 0.022008) AppCount(1553 - 0.099284)
#  Key(last) InputFields(201) LayoutCount(176 - 0.002469) AppCount(144 - 0.009206)
#  Key(age) InputFields(334) LayoutCount(297 - 0.004166) AppCount(198 - 0.012658)
#  Key(address) InputFields(3228) LayoutCount(2905 - 0.040748) AppCount(2310 - 0.147679)
#  Key(number) InputFields(1641) LayoutCount(1330 - 0.018656) AppCount(995 - 0.063611)
#  Key(weight) InputFields(285) LayoutCount(273 - 0.003829) AppCount(181 - 0.011571)
#  Key(month) InputFields(386) LayoutCount(313 - 0.004390) AppCount(235 - 0.015024)
#  Key(height) InputFields(246) LayoutCount(233 - 0.003268) AppCount(148 - 0.009462)
#  Key(cc) InputFields(61) LayoutCount(55 - 0.000771) AppCount(48 - 0.003069)
#  Key(account_number) InputFields(292) LayoutCount(274 - 0.003843) AppCount(181 - 0.011571)
#  Key(location) InputFields(4577) LayoutCount(4545 - 0.063753) AppCount(2653 - 0.169607)
#  Key(year) InputFields(1472) LayoutCount(1394 - 0.019554) AppCount(1174 - 0.075054)
#  Key(ft) InputFields(1537) LayoutCount(1530 - 0.021461) AppCount(1521 - 0.097238)
#  Key(security_code) InputFields(145) LayoutCount(136 - 0.001908) AppCount(109 - 0.006968)
#  Key(day) InputFields(7297) LayoutCount(5502 - 0.077177) AppCount(2095 - 0.133934)
#  Key(first) InputFields(325) LayoutCount(307 - 0.004306) AppCount(254 - 0.016238)
#  TotalApp(10003/15642 - 0.639496) TotalLayout(25720/71291 - 0.360775)
