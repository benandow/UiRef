from lxml import etree
import csv
import re

# Reading input file methods
def readTerms(filename='../DataFiles/COLLOC.txt'):
	subs = {}
	for line in open(filename, 'r'):
		syns = re.sub(r'\s+\|\s+', u'|', line.strip()).split(u'|')
		subval = re.sub(r'\s+', u'_', syns[0].strip())
		for s in syns:
			subs[s] = subval
	subs = dict((re.escape(k), v) for k, v in subs.items())
	pattern = re.compile(r'\b(%s)\b' % ('|'.join(subs.keys()),))
	return (pattern, subs)


def readDisambiguatedTerms(filename='../DataFiles/AMBIG_WORDS.csv'):
	ambig_terms = {}
	with open(filename, newline='') as csvfile:
		reader = csv.reader(csvfile, delimiter=',', quotechar='"')
		for word,wid,wtag in reader:
			if wtag == "UNKNOWN":
				continue
			if word not in ambig_terms:
				ambig_terms[word] = {}
			ambig_terms[word][int(wid)] = wtag
	return ambig_terms



def readSensitiveTerms(filename='../DataFiles/SEMANTIC_BUCKETS.xml'):
	def loadAnnotInternal(node, synAnnot):
		def getTerm(node):
			return node.get('term')
		def shouldIgnore(node):
			return True if node.get('ignore') is not None else False
		if node.tag == 'node':
			term = re.sub(r'\s+', '_', getTerm(node).strip())
			if term not in synAnnot and not shouldIgnore(node):
				synAnnot[term] = term
			for child in node:
				if child.tag == 'synonym':
					if not shouldIgnore(child):
						childTerm = re.sub(r'\s+', u'_', getTerm(child).strip())
						if childTerm not in synAnnot:
							synAnnot[childTerm] = term
				elif child.tag == 'node':
					loadAnnotInternal(child, synAnnot)
		elif node.tag == 'annotations':
			for child in node:
				loadAnnotInternal(child, synAnnot)
	outputDict = {}
	tree = etree.parse(filename)
	root = tree.getroot()
	loadAnnotInternal(root, outputDict)
	return outputDict
