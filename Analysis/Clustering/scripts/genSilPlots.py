#!/usr/bin/env python
import numpy as np
import sys
from kmodes import kmodes
from sklearn.metrics import silhouette_score
from sklearn.metrics import silhouette_samples
import pickle
import math
import os

import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import matplotlib.cm as cm
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

        # Create a subplot with 1 row and 2 columns
        fig, ax1 = plt.subplots(1, 1)
        fig.set_size_inches(18, 7)

        # The 1st subplot is the silhouette plot
        # The silhouette coefficient can range from -1, 1 but in this example all
        # lie within [-0.1, 1]
        ax1.set_xlim([-0.1, 1])
        # The (n_clusters+1)*10 is for inserting blank space between silhouette
        # plots of individual clusters, to demarcate them clearly.
        ax1.set_ylim([0, len(X_ENC) + (n + 1) * 10])

        sil_avg = silhouette_score(X_ENC, clusters, metric=simple_compare)
        print("For n_clusters =", n, "The average silhouette_score is :", sil_avg)
        sample_silhouette_values = silhouette_samples(X_ENC, clusters, metric=simple_compare)
        
        y_lower = 10
        for i in range(n):
            # Aggregate the silhouette scores for samples belonging to
            # cluster i, and sort them
            ith_cluster_silhouette_values = sample_silhouette_values[clusters == i]

            ith_cluster_silhouette_values.sort()

            size_cluster_i = ith_cluster_silhouette_values.shape[0]
            y_upper = y_lower + size_cluster_i

            color = cm.spectral(float(i) / n)
            ax1.fill_betweenx(np.arange(y_lower, y_upper),
                          0, ith_cluster_silhouette_values,
                          facecolor=color, edgecolor=color, alpha=0.7)

            # Label the silhouette plots with their cluster numbers at the middle
            ax1.text(-0.05, y_lower + 0.5 * size_cluster_i, str(i))

            # Compute the new y_lower for next plot
            y_lower = y_upper + 10  # 10 for the 0 samples

        print sample_silhouette_values


        ax1.set_title("The silhouette plot for %d clusters." % (n,))
        ax1.set_xlabel("The silhouette coefficient values (AVF = %f)" % (sil_avg,))
        ax1.set_ylabel("Cluster label")
        # The vertical line for average silhouette score of all the values
        ax1.axvline(x=sil_avg, color="red", linestyle="--")

        ax1.set_yticks([])  # Clear the yaxis labels / ticks
        ax1.set_xticks([-0.1, 0, 0.2, 0.4, 0.6, 0.8, 1])
        
        mng = plt.get_current_fig_manager()
        mng.window.state('zoomed')

        plt.show()
#        fig.savefig('%d_SILS.png' % (np.amax(clusters)+1,))
#        plt.close(fig)
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
#        run_kmodes(syms, X, n, int(sys.argv[4]))
        nclusters,sil_avg = run_kmodes(syms, X, n, int(sys.argv[4]))
        sils.append((nclusters, sil_avg))
        if sil_avg == 1.0 or nclusters != n:
            break


