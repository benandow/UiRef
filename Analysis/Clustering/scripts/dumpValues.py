#!/usr/bin/env python
import numpy as np
import sys
from kmodes import kmodes
from sklearn.metrics import silhouette_score
from sklearn.metrics import silhouette_samples
import pickle
import math
import os
import re

USE_WEIGHTS = True

def weight(X, b, idj):
    return 1.0/math.sqrt(float((X[:,idj] == b[idj]).sum(0))/float(X.shape[0])) if USE_WEIGHTS else 1.0

# Num objects w/ category value x_{i,r} for rth attr in jth cluster
def calcCJR(b, X, memj, idr):
    xcids = np.where(np.in1d(memj.ravel(), [1]).reshape(memj.shape))
    return float((np.take(X, xcids, axis=0)[0][:,idr] == b[idr]).sum(0))

def calc_dissim(b, X, memj, idr, idj):
    CJ = float(np.sum(memj))           # Size of jth cluster
    return (1.0 - (calcCJR(b, X, memj, idr) / CJ)) * weight(X, b, idr) if CJ != 0.0 else 0.0

#a = cluster centroids, b = current point
def dissim_meas(a, b, X, membship):
    return [ np.array([calc_dissim(b, X, membship[idj], idr, idj) if b[idr] == t else 1.0 * weight(X,b,idr) for idr,t in enumerate(val_a) ]).sum(0) for idj,val_a in enumerate(a) ]

def getBigClusters(clusters, alpha):
    # Get largest cluster within alpha
#    print sorted([(float(x), idx) for idx,x in enumerate(np.bincount(clusters)) ], reverse=True), len(clusters)
    return [ idx for idx,x in enumerate(np.bincount(clusters)) if float(x) >= float(alpha*0.01*len(clusters)) ]

def genMembshipArray(clusters):
    return np.array([[1 if v == num else 0 for v in clusters ] for num in range(0, np.amax(clusters) + 1)])

def getEntries(clusters, X_ENC):
    return np.array([ np.take(X_ENC, np.where(clusters == c)[0], 0) for c in range(0, np.amax(clusters) +1) ])

def calc_densities(X_ENC):
    return [ np.array([ np.bincount(X_ENC[:,idc])[c] for idc,c in enumerate(X_ENC[idr]) ]).sum(0) for idr,r in enumerate(X_ENC) ]


##############

# TODO return cids?
def getBCDissims(bigClusters, clusters, X_ENC, idc, centroids, membship):
    return [ dissim_meas(centroids, X_ENC[idc], X_ENC, membship)[cid] for cid,centry in enumerate(centroids) if cid in bigClusters ]
#    cluster_entries = getEntries(clusters, X_ENC)
#    return [ dissim_per_cluster(np.array(centry), X_ENC[idc], X_ENC) for cid, centry in enumerate(cluster_entries) if cid in bigClusters]

# Something wrong with this
def cdist(bigClusters, clusters, syms, X_ENC, centroids, removedClusters):
    membship = genMembshipArray(clusters)
    return [ np.amin(getBCDissims(bigClusters, clusters, X_ENC, idc, centroids, membship)) for idc,c in enumerate(clusters) ]

##############

def simple_compare(a, b):
    return float(np.sum(a != b))

def removeBigClusters(bigClusters,removedClusters):
    return [ bc for bc in bigClusters if bc not in removedClusters]

def dumpValues(syms, X, n, alpha, removedClusters):
    if os.path.isfile( "%d_CLUSTERS.pkl" % (n,) ):
        X_ENC,clusters,centroids = pickle.load(open("%d_CLUSTERS.pkl" % (n,), "r"))

        densities = calc_densities(X_ENC)

        bigClusters = removeBigClusters(getBigClusters(clusters, alpha), removedClusters)
        while len(bigClusters) <= 0:
            print "Error no big clusters, decreasing alpha to", (alpha-1)
            alpha -= 0.5
            if alpha <= 0.0:
                sys.exit(1)
            bigClusters = removeBigClusters(getBigClusters(clusters, alpha), removedClusters)
   

        # Let's dump the values in the big cluster so that we don't have to wait
        bigClusterValues = {}
        numBigClusterApps = 0
        otherClusterValues = {}
        numOtherClusterApps = 0
        for idc,c in enumerate(clusters):
            if c in bigClusters:
                numBigClusterApps += 1
                vals = [ v for v in X[idc] if not v.startswith("N_") ]                
                for val in vals:
                    if val not in bigClusterValues:
                        bigClusterValues[val] = 0
                    bigClusterValues[val] += 1
            elif c not in removedClusters:
                numOtherClusterApps += 1
                vals = [ v for v in X[idc] if not v.startswith("N_") ]                
                for val in vals:
                    if val not in otherClusterValues:
                        otherClusterValues[val] = 0
                    otherClusterValues[val] += 1

        
        print "Biggest Clusters", bigClusters, numBigClusterApps
        bigClusterValues = sorted([ (bigClusterValues[bcv], bcv) for bcv in bigClusterValues ], reverse=True)
        print ', '.join([ '%s (%d)' % (re.sub(r'_','\\_',ename), efreq) for efreq,ename in bigClusterValues ])

        print "-----------------------"
        print "Other Clusters", numOtherClusterApps
        otherClusterValues = sorted([ (otherClusterValues[ocv], ocv) for ocv in otherClusterValues ], reverse=True)
        print ', '.join([ '%s (%d)' % (re.sub(r'_','\\_',ename), efreq) for efreq,ename in otherClusterValues ])


        if len(bigClusterValues) <= 0:
            removedClusters.extend(bigClusters)
            print "Big clusters empty"
            return (False, removedClusters)

        # Let's dump the other values
        


        #TODO if we remove a entry, do not calculate the cdists
        cdists = cdist(bigClusters, clusters, syms, X_ENC, centroids, removedClusters)

        ranked_outliers = sorted([(c, -densities[idc]/float(len(X_ENC)), clusters[idc], syms[idc], idc) for idc,c in enumerate(cdists)], reverse=True)
        
        for ido,o in enumerate(ranked_outliers):
            vals = [ v for v in X[o[4]] if not v.startswith("N_") ]
            if o[2] not in removedClusters:
                print o, vals

        
        return (True, cdists, ranked_outliers)

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print "Usage: cluster.py <CSV_FILENAME> <START_CLUSTER> <ALPHA>"
        sys.exit(1)

    n = int(sys.argv[2])
    alpha = float(sys.argv[3])
    
    # READ CSV Files
    syms = np.genfromtxt(sys.argv[1], dtype=str, delimiter=',')[:, 0]
    X = np.genfromtxt(sys.argv[1], dtype=object, delimiter=',')[:, 1:]
    removedClusters = []
    res = dumpValues(syms, X, n, alpha, removedClusters)
    while not res[0]:
        res = dumpValues(syms, X, n, alpha, removedClusters)
        

