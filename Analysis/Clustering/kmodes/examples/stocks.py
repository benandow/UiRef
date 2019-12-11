#!/usr/bin/env python

import numpy as np
from kmodes import kmodes

# stocks with their market caps, sectors and countries
syms = np.genfromtxt('stocks.csv', dtype=str, delimiter=',')[:, 0]
X = np.genfromtxt('stocks.csv', dtype=object, delimiter=',')[:, 1:]

def dissim_meas(a, b, X, membship):
    #a = clustering centers
    #b = current point
#    return np.sum(a != b, axis=1)
    res = []
    for idj,val_a in enumerate(a):
        sumval = 0.0
        for idr,t in enumerate(val_a):
#            print val_a,val_a[idr], b[idr], b, idr
            if b[idr] != t:
                sumval += 1.0
            else:
                CLUSTER_J = membship[idj]
                # Get indices of value for membership
                xcids = np.where(np.in1d(membship[idj].ravel(), [1]).reshape(membship[idj].shape))
                # Extract rows and calculate membership
                CJR = float((np.take(X,xcids, axis=0)[0][:,idr] == b[idr]).sum(0))     # Number of objects with category value x_{i,r} for the rth attribute in the jth cluster
                CJ = float(np.sum(membship[idj]))                           # Size of jth cluster
    
                if CJ != 0:                
                    sumval += (1.0-(CJR/CJ))

#                print "\t",(1.0-(CJR/CJ)), "\t\t", CJ,"\t\t", CJR
#                sumval += (1.0-(CJR/CJ))
        res.append(sumval)
    return res



kproto = kmodes.KModes(n_clusters=4, init='Cao', kmodes_cat_dissim=dissim_meas)#, verbose=2) # cat_dissim=dissim_meas
clusters = kproto.fit_predict(X)


# Print cluster centroids and categorical data mapping of the trained model.
#print(kproto.cluster_centroids_)
#print(kproto.enc_map_)
# Print training statistics
#print(kproto.cost_)
print(kproto.n_iter_)

counts = {}
for s, c in zip(syms, clusters):
    print("Symbol: {}, cluster:{}".format(s, c))

