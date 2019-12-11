import csv
import sys
import numpy as np
from sklearn import svm

possible_labels = {}

training_data = []
training_labels = []

if len(sys.argv) != 2:
    print "Usage: python outlier_detect_svm.py data.csv"
    exit(1)

# Build the vector by grabbing all possible labels
with open("%s" % sys.argv[1], "rb") as csvfile:
    reader = csv.reader(csvfile, delimiter=",")
    for row in reader:
        for label in row[1:]:
            stripped = label.strip()
            if stripped != ' ' and stripped != '':
                possible_labels[stripped] = True

labels = list(possible_labels.keys())

# Set the max number of features - by default just number of labels
MAX_FEATURES = len(labels)

if MAX_FEATURES == 0:
	sys.exit(0)

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

# Fit the model
# Set nu for 0.1, default gamma.
clf = svm.OneClassSVM(nu=0.1, kernel="rbf")
clf.fit(training_data)

predictions = clf.predict(training_data)

idx = 0
outliers = 0
# Iterate through predictions, print out labels that are negative.
for prediction in predictions:
    if(prediction < 0):
        print training_labels[idx]
        outliers = outliers + 1
    idx = idx + 1
