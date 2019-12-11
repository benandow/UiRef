#!/usr/bin/env python
import csv
import sys
import numpy as np


def getKey(attr_num, attr_val):
	return '%d_%d' % (attr_num, attr_val)

#Attribute Value Frequency
# Label all data points as non-outliers
# calculate frequency of each attribute value
# foreach point x
#   AVFscore = Sum(frequency each attrib. value in x)/num.attribs
# end foreach
# return top k outliers with minimum AVFscore
def calcAttrValFreq(attr_freqs, row, num_features):
	avf_sum = 0.0
	for idx,x in enumerate(row):
		avf_sum += attr_freqs[getKey(idx,x)]
	avf_score = avf_sum/float(num_features)
	return avf_score


def getLabels(CSV_FILENAME):
	possible_labels = {}
	# Build the vector by grabbing all possible labels
	with open("%s" % CSV_FILENAME, "rb") as csvfile:
		for row in csv.reader(csvfile, delimiter=","):
			for label in row[1:]:
				stripped = label.strip()
				if stripped != ' ' and stripped != '':
					possible_labels[stripped] = True
	return list(possible_labels.keys())

def getFeatures(CSV_FILENAME):
	training_data = []
	training_labels = []
	
	with open("%s" % sys.argv[1], "rb") as csvfile:
	    reader = csv.reader(csvfile, delimiter=",")
	    for row in reader:
	        training_labels.append(row[0])
	        vector = [0] * MAX_FEATURES
	        for label in row[1:]:
	            stripped = label.strip()
	            if stripped != ' ' and stripped != '':
	                vector[labels.index(label.strip())] = 1
	        training_data.append(vector)
	return (training_data, training_labels)

def calcFrequencies(feature_vectors):
	freqs = {}
	for td in feature_vectors:
		for idx,x in enumerate(td):
			key = getKey(idx,x)
			if key not in freqs:
				freqs[key] = 0.0
			freqs[key] += 1.0
	return freqs


if __name__ == '__main__':	
	if len(sys.argv) != 3:
	    print "Usage: python %s data.csv <NUMBER_OF_OUTLIERS>" % (sys.argv[0],)
	    sys.exit(1)
	
	CSV_FILENAME = sys.argv[1]
	MAX_OUTLIERS = int(sys.argv[2])
	
	labels = getLabels(CSV_FILENAME)

	# Set the max number of features - by default just number of labels
	MAX_FEATURES = len(labels)
	# If no features (i.e., no input fields), obviously no outliers	
	if MAX_FEATURES == 0:
		sys.exit(0)

	feature_vectors,row_labels = getFeatures(CSV_FILENAME)
	attr_freqs = calcFrequencies(feature_vectors)

	avfarr=[]
	for idr,r in enumerate(feature_vectors):
		avf_score = calcAttrValFreq(attr_freqs, r, float(len(labels)))
		avfarr.append((avf_score, row_labels[idr], [labels[idx] for idx,x in enumerate(r) if x == 1]))
	

	count = 0
	for f in sorted(avfarr, reverse=False):
		if count < MAX_OUTLIERS:
			print f[0], f[1], f[2]
		count+=1
	
