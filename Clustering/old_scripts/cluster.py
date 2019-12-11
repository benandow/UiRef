#!/usr/bin/env python
import gensim
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_samples, silhouette_score
import numpy as np
import sys
import sklearn.cluster
import os
import sys
import re

BASE_PATH = 'meta/'
CATEGORY = 'PRODUCTIVITY'
OUTPUT_DIR = 'CSV_FILES'
LABELS_FILE = None
PREPROCESSED_DATA_FILE = None

def readText(filename):
	return [ line.lstrip().rstrip() for line in open(filename, 'r') ]
	
def readLabels(filename):
	return [ os.path.basename(line.lstrip().rstrip()) for line in open(filename, 'r') ]


def trainDoc2Vec(filename):
	documents = gensim.models.doc2vec.TaggedLineDocument(filename)
	return gensim.models.doc2vec.Doc2Vec(documents, size=100, window=5, min_count=1, workers=4)

def getSimilarityMatrix():
	print "Computing Similarity Matrix"
	text = readText(PREPROCESSED_DATA_FILE)
	model = trainDoc2Vec(PREPROCESSED_DATA_FILE)
	simvec = np.array([[model.n_similarity(d1.split(' '),d2.split(' ')) for d1 in text] for d2 in text])
	print "Done computing similarity matrix"
	return np.array(simvec)


if __name__ == '__main__':
	if len(sys.argv) < 2:
		print "Usage: %s <CATEGORY>" % (sys.argv[0],)
		sys.exit(0)

	CATEGORY = sys.argv[1]
	LABELS_FILE = os.path.join(BASE_PATH, '%s_metadata_files.txt' % (CATEGORY,))
	PREPROCESSED_DATA_FILE = os.path.join(BASE_PATH, '%s_preprocessed.txt' % (CATEGORY,))

	labels = np.asarray(readLabels(LABELS_FILE))

	filename = 'models/%s_similarity_vector.nparr' % (CATEGORY,)
	saveFileFlag = os.path.isfile("%s.npy" % (filename,))
	simvec = getSimilarityMatrix() if not saveFileFlag else np.load("%s.npy" % (filename,))
	if not saveFileFlag:
		np.save(filename, simvec)

#	simvec = np.around((simvec - np.amax(simvec)), decimals=1)
	simvec = (simvec - np.amax(simvec))

	print np.median(simvec)

	affprop = sklearn.cluster.AffinityPropagation(affinity="precomputed", damping=0.90, convergence_iter=400, max_iter=10000, verbose=True).fit(simvec)
	cluster_centers_indices = affprop.cluster_centers_indices_

	n_clusters_ = len(cluster_centers_indices)

	print('Estimated number of clusters: %d' % n_clusters_)

	# Read input strings
	csv_lines = {}
	for l in open("labels.csv", "r"):
		csv_lines[l.strip().split(',')[0]] = l.strip()

	for cluster_id in np.unique(affprop.labels_):
		exemplar = labels[affprop.cluster_centers_indices_[cluster_id]]
		cluster = np.unique(labels[np.nonzero(affprop.labels_==cluster_id)])
		cluster_str = ", ".join(cluster)
		print cluster_str
		with open('%s/%s_%d.csv' % (OUTPUT_DIR,CATEGORY, cluster_id), 'w') as csvoutfile:
			for c in cluster:
				key = '%s/%s' %(CATEGORY, re.sub(r'\.json$', '',c))
				if key in csv_lines:
					csvoutfile.write('%s\n' % (csv_lines[key],))
				else:
					csvoutfile.write('%s,\n' % (key,))

#		print " -* %s :* %s" % (exemplar, cluster_str)

	

