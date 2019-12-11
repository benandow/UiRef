#!/usr/bin/env python
import numpy as np
import pickle
import math
import os
import sys
import re



if __name__ == "__main__":

    counts = {}
    for line in open('%s/%s.csv' % (sys.argv[1],sys.argv[1]), 'r'):
        vals = re.sub(r',$', '',line.strip()).split(',')

        hashentry = ','.join(sorted(vals[1:]))

        if hashentry not in counts:
            counts[hashentry] = 0
        counts[hashentry] += 1
    sorted_vals =  sorted([(counts[c],c) for c in counts], reverse=True)
    largeVals = {}
    numAppsL = 0
    otherVals = {}
    numAppsO = 0
    for cnt,sv in sorted_vals:
        if sv == '':
            print "Skipping big cluster"
            continue
        if len(largeVals) <= 0:
            numAppsL += cnt
            for lv in sv.split(','):
                largeVals[lv] = cnt
        else:
            numAppsO += cnt
            for ov in sv.split(','):
                if ov not in otherVals:
                    otherVals[ov] = 0
                otherVals[ov] += cnt

    print numAppsL
    largeVals = sorted( [ (largeVals[bcv], bcv) for bcv in largeVals ], reverse=True)
    print ', '.join([ '%s (%d)' % (re.sub(r'_','\\_',ename), efreq) for efreq,ename in largeVals ])

    print numAppsO

    otherVals = sorted( [ (otherVals[bcv], bcv) for bcv in otherVals ], reverse=True)
    print ', '.join([ '%s (%d)' % (re.sub(r'_','\\_',ename), efreq) for efreq,ename in otherVals ])

