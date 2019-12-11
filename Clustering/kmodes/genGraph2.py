#!/usr/bin/env python
import pickle
import sys
import numpy as np
import matplotlib.pyplot as plt
import random

if __name__ == "__main__":
    syms = np.genfromtxt(sys.argv[1], dtype=str, delimiter=',')[:, 0]
    X = np.genfromtxt(sys.argv[1], dtype=object, delimiter=',')[:, 1:]

    ranked_outliers = pickle.load(open("RANKED_OUTLIERS.pkl","rb"))

    plotLines = {}

    rc = lambda: random.randint(0,255)

    for idx,x in enumerate(ranked_outliers):
        index = [ idr for idr,rv in enumerate(syms) if rv == x[2] ][0]
        vals = [ v for v in X[index] if not v.startswith("N_") ]
        
        # OUTLIER SCORE
        # (x[0], VAL[i])
        for d in vals:
            if d not in plotLines:
                plotLines[d] = {}
            xint = x[0]
            if xint not in plotLines[d]:
                plotLines[d][xint] = 0
            plotLines[d][xint] += 1

 
#    for l in plotLines:
#        maxkey = max(plotLines[l].keys())
#        for i in range(0,maxkey):
#            if i not in plotLines[l]:
#                plotLines[l][i] = 0

    fig,ax = plt.subplots()


    colors = [ '#%02X%02X%02X' % (rc(),rc(),rc()) for i in range(0, len(plotLines)) ]

    cols = ["citizenship", "date_of_birth", "twitter_password", "family_member_name, password"]

    for idl,l in enumerate(plotLines):
        if l not in cols:
            continue
        keys = sorted(plotLines[l].keys())
        vals = [plotLines[l][k] for k in keys]
        ax.scatter(np.array(keys), np.array(vals), c=colors[idl])
            
    plt.legend([l for l in plotLines if l in cols], loc='bottom')
    plt.show()
