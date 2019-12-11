#!/usr/bin/env python
import numpy as np
import sys
from kmodes import kmodes
from sklearn.metrics import silhouette_score
from sklearn.metrics import silhouette_samples
import pickle
import math
import os

USE_WEIGHTS = True

def weight(X, b, idj):
    return 1/math.sqrt(float((X[:,idj] == b[idj]).sum(0))/float(X.shape[0])) if USE_WEIGHTS else 1.0

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
    return [ idx for idx,x in enumerate(np.bincount(clusters)) if float(x) >= float(alpha*0.01*len(clusters)) ]

def genMembshipArray(clusters):
    return np.array([[1 if v == num else 0 for v in clusters ] for num in range(0, np.amax(clusters) + 1)])

def getEntries(clusters, X_ENC):
    return np.array([ np.take(X_ENC, np.where(clusters == c)[0], 0) for c in range(0, np.amax(clusters) +1) ])

def calc_densities(X_ENC):
    return [ np.array([ np.bincount(X_ENC[:,idc])[c] for idc,c in enumerate(X_ENC[idr]) ]).sum(0) for idr,r in enumerate(X_ENC) ]


##############
#def calcCJR2(a, b, idj):
#    return (a[:,idj] == b[idj]).sum(0)

# This is still wrong, CHECK THE VALUE WITH THE CENTROID AND APPLY WEIGHT!!
#def dissim_per_cluster(a, b, X_ENC):
#    return 0.0 if len(a) <= 0 else np.array([ (1.0-(calcCJR2(a, b, idj) / a.shape[0])) * weight(X_ENC, b, idj) for idj in range(0, a.shape[1]) ]).sum(0)

# TODO return cids?
def getBCDissims(bigClusters, clusters, X_ENC, idc, centroids, membship):
    return [ dissim_meas(centroids, X_ENC[idc], X_ENC, membship)[cid] for cid, centry in enumerate(centroids) if cid in bigClusters ]
#    cluster_entries = getEntries(clusters, X_ENC)
#    return [ dissim_per_cluster(np.array(centry), X_ENC[idc], X_ENC) for cid, centry in enumerate(cluster_entries) if cid in bigClusters]

# Something wrong with this
def cdist(bigClusters, clusters, syms, X_ENC, centroids):
    membship = genMembshipArray(clusters)
    return [ np.amin(getBCDissims(bigClusters, clusters, X_ENC, idc, centroids, membship)) for idc,c in enumerate(clusters) ]

##############

def simple_compare(a, b):
    return float(np.sum(a != b))

def run_kmodes(syms, X, n, alpha):
    if os.path.isfile( "%d_CLUSTERS.pkl" % (n,) ):
        X_ENC,clusters,centroids = pickle.load(open("%d_CLUSTERS.pkl" % (n,), "r"))
        sil_avg = silhouette_score(X_ENC, clusters, metric=simple_compare)
        return (np.amax(clusters)+1, sil_avg)

    kproto = kmodes.KModes(n_clusters=n, init='Cao', kmodes_cat_dissim=dissim_meas, verbose=2)
    clusters = kproto.fit_predict(X)
    centroids = kproto.cluster_centroids_

    X_ENC = kmodes.encode_features(X, enc_map=kproto.enc_map_)[0]
#    densities = calc_densities(X_ENC)

#    bigClusters = getBigClusters(clusters, alpha)
#    while len(bigClusters) <= 0:
#        print "Error no big clusters, decreasing alpha to", (alpha-1)
#        alpha -= 1
#        if alpha <= 0:
#            sys.exit(1)
#        bigClusters = getBigClusters(clusters, alpha)
    
#    cdists = cdist(bigClusters, clusters, syms, X_ENC, centroids)

#    ranked_outliers = sorted([(c, -densities[idc]/float(len(X_ENC)), syms[idc], clusters[idc]) for idc,c in enumerate(cdists)], reverse=True)

#    for ido,o in enumerate(ranked_outliers):
#        index = [ idr for idr,rv in enumerate(syms) if rv == o[2] ][0]
#        vals = [ v for v in X[index] if not v.startswith("N_") ]
#        print o, vals

    with open("%d_CLUSTERS.pkl" % (n,), "wb") as foutput:
        pickle.dump((X_ENC, clusters, centroids), foutput)


    #Distances may be calculated using Euclidean distances. The Silhouette
    #coefficient and its average range between -1, indicating a very poor model, and
    #1, indicating an excellent model. As found by Kaufman and Rousseeuw (1990), an
    #average silhouette greater than 0.5 indicates reasonable partitioning of data;
    #less than 0.2 means that the data do not exhibit cluster structure.
    #print "Precomputing Matrix"
    #X_PCMP =precomputMatrix(X_ENC, clusters)
    #sil_avg = silhouette_score(X_PCMP, clusters, metric='precomputed')

    sil_avg = silhouette_score(X_ENC, clusters, metric=simple_compare)
    

    return (np.amax(clusters)+1, sil_avg)

if __name__ == '__main__':
    if len(sys.argv) < 5:
        print "Usage: cluster.py <CSV_FILENAME> <START_CLUSTER> <END_CLUSTER> <ALPHA>"
        sys.exit(1)

    # READ CSV Files
    syms = np.genfromtxt(sys.argv[1], dtype=str, delimiter=',')[:, 0]
    X = np.genfromtxt(sys.argv[1], dtype=object, delimiter=',')[:, 1:]

    sils = []
    for n in range(int(sys.argv[2]), int(sys.argv[3])):
        print "Starting ",n
#        run_kmodes(syms, X, n, int(sys.argv[4]))
        nclusters,sil_avg = run_kmodes(syms, X, n, int(sys.argv[4]))
        sils.append((nclusters, sil_avg))
        if sil_avg == 1.0 or nclusters != n:
            break

    print sils
