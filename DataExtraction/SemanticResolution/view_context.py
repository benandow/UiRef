import os
import sys
import re
import parse_layout as layoutParser
import preprocessor
import string
import subprocess
import pickle
from adagramDisambigModule import *
import numpy as np
from lxml import etree
import codecs
#NOTE Need to run with: DYLD_LIBRARY_PATH="$JULIA_PATH/lib/julia/:lib/ set

resolvedByHint = 0
resolvedByText = 0
resolvedByLabel = 0
suporIncorrectLabRes = 0
suporIncorrectLabResTotal = 0
suporIncorrectLabNoRes = 0

AMBIG_TERM_FILE = "../DataFiles/AMBIG_WORDS.csv"

# Ambigious terms that need to be resolved
ambig_terms = {} 


#address | adress | adres

COLLOCATIONS_FILE = u'../DataFiles/COLLOC.txt'
SEMANTIC_BUCKETS_FILE = u'../DataFiles/SEMANTIC_BUCKETS.xml'
LOGFILE = 'SEM_PROGRESS2.log'
LAYOUT_PATHS_FILE = u'LAYOUT_FILES2.txt'

###############################
# String processing methods
def toUnicode(text):
	if not isinstance(text, unicode):
		text = unicode(text, 'utf-8').lower()
	return text

def safeStrip(text):
	return text.strip() if text is not None else None

###############################
# Reading input file methods
def readTerms():
	subs = {}
	for line in open(COLLOCATIONS_FILE, 'r'):
		syns = re.sub(r'\s+\|\s+', u'|', toUnicode(line).strip()).split(u'|')
		subval = re.sub(r'\s+', u'_', syns[0].strip())
		for s in syns:
			subs[s] = subval
	subs = dict((re.escape(k), v) for k, v in subs.iteritems())
	pattern = re.compile(r'\b(%s)\b' % ('|'.join(subs.keys()),))
	return (pattern, subs)


def readSensitiveTerms(filename=SEMANTIC_BUCKETS_FILE):
	def loadAnnotInternal(node, synAnnot):
		def getTerm(node):
			return node.get(u'term')
		def shouldIgnore(node):
			return True if node.get('ignore') is not None else False
		if node.tag == u'node':
			term = re.sub(r'\s+', u'_', getTerm(node).strip())
			if term not in synAnnot and not shouldIgnore(node):
				synAnnot[term] = term
			for child in node:
				if child.tag == u'synonym':
					if not shouldIgnore(child):
						childTerm = re.sub(r'\s+', u'_', getTerm(child).strip())
						if childTerm not in synAnnot:
							synAnnot[childTerm] = term
				elif child.tag == u'node':
					loadAnnotInternal(child, synAnnot)
		elif node.tag == u'annotations':
			for child in node:
				loadAnnotInternal(child, synAnnot)
	outputDict = {}
	tree = etree.parse(filename)
	root = tree.getroot()
	loadAnnotInternal(root, outputDict)
	return outputDict

#def readSensitiveTerms():
#	sdict = {}
#	for line in open(SEMANTIC_BUCKETS_FILE, 'r'):
#		syns = re.sub(r'\s+\|\s+', u'|', toUnicode(line).strip()).split(u'|')
#		syns = [re.sub(r'\s+', u'_', s.strip()) for s in syns]
#		for s in syns:
#			sdict[s] = syns[0]
#	return sdict


def getLayoutFiles():
	return [line.strip() for line in open(LAYOUT_PATHS_FILE, 'r')] if os.path.isfile(LAYOUT_PATHS_FILE) else []


def readDisambiguatedTerms():
	terms = np.genfromtxt(AMBIG_TERM_FILE, dtype=str, delimiter=',')
	for word,wid,wtag in terms:
		if wtag == "UNKNOWN":
			continue
		if word not in ambig_terms:
			ambig_terms[word] = {}
		ambig_terms[word][int(wid)] = wtag
	return ambig_terms

###############################
# Get text
def getText(text, pattern, subs, stopwords):
	if text is not None and len(text) > 0:
		text = text.replace(u'\n', u' ').replace('(', ' (').strip().lower()
		tlines = preprocessor.parse_field2(text)
		lines = []
		for t in tlines:
			t = preprocessor.join_tokens([ tok for tok in preprocessor.tokenize(t)])
			t = pattern.sub(lambda m: subs[re.escape(m.group(0))], t)
			t = preprocessor.join_tokens([ preprocessor.strip_leading_and_trailing_nums(tok) for tok in preprocessor.tokenize2(t) if tok not in stopwords and tok not in string.punctuation and len(tok) > 1 and not preprocessor.containsThreeConsecTokens(tok)])
			lines.append(t)
		t = preprocessor.join_tokens(lines)
		return t if len(t) > 1 else None
	return None

###############################
# Resolving the semantics of input fields

# Append text to "text before" array
def prependText(resolved, tval):
	for r in resolved:
		r[1] = re.sub(r'\s\s+', u' ', '%s %s' % (tval, r[1])).strip()
	return resolved	

# Append text to "text after array"
def appendText(resolved, tval):
	for r in resolved:
		r[2] = re.sub(r'\s\s+', u' ', '%s %s' % (r[2], tval)).strip()
	return resolved	


def resolveSensitiveTerms(word, sensitiveTerms):
	if word is None:
		return None

	# Sensitive term dictionary
	resolvedTerms = {}
	# Text before the sensitive term
	textBefore = []
	# For each word
	for idx,tok in enumerate(word.split(u' ')):
		# Append token to "text after" array
		for poskey in resolvedTerms.keys():
			resolvedTerms[poskey][2].append(tok.strip())
                
		# If a sensitive term or ambiguous term add the term to the resolvedTerm, add textBefore, and empty array for text after
		if tok.strip() in sensitiveTerms:
			resolvedTerms[idx] = [sensitiveTerms[tok.strip()], preprocessor.join_tokens(textBefore), []]#term,before,after
		elif tok.strip() in ambig_terms.keys():
			resolvedTerms[idx] = [tok.strip(), preprocessor.join_tokens(textBefore), []]#term,before,after
		#Append the token to "text before" array
		textBefore.append(tok.strip())

	# Return resolved terms [][]
	return [ [resolvedTerms[key][0], resolvedTerms[key][1], preprocessor.join_tokens(resolvedTerms[key][2]) ] for key in resolvedTerms ]


def resolveSemantics(hint, text, label, sensitiveTerms, v):
	global resolvedByHint
	global resolvedByText
	global resolvedByLabel
	global suporIncorrectLabRes
	global suporIncorrectLabResTotal
	global suporIncorrectLabNoRes

	if v.suporLabelCounter != v.annotatedLabelCounter:
		suporIncorrectLabResTotal += 1

	if hint is not None:
		resolved = resolveSensitiveTerms(hint, sensitiveTerms)
		if len(resolved) > 0:
			if label is not None:
				resolved = prependText(resolved, label)
			if text is not None:
				resolved = appendText(resolved, text)
			if v.suporLabelCounter != v.annotatedLabelCounter:
				suporIncorrectLabRes += 1
			resolvedByHint += 1
			return resolved

	if text is not None:
		resolved = resolveSensitiveTerms(text, sensitiveTerms)
		if len(resolved) > 0:
			if label is not None:
				resolved = prependText(resolved, label)
			if hint is not None:
				resolved = prependText(resolved, hint)
			if v.suporLabelCounter != v.annotatedLabelCounter:
				suporIncorrectLabRes += 1
			resolvedByText += 1
			return resolved

	if label is not None:
		resolved = resolveSensitiveTerms(label, sensitiveTerms)
		if len(resolved) > 0:
			if hint is not None:
				resolved = prependText(resolved, hint)
			if text is not None:
				resolved = prependText(resolved, text)
			resolvedByLabel += 1
			return resolved
	if v.suporLabelCounter != v.annotatedLabelCounter:
		suporIncorrectLabNoRes += 1
	return None
###############################

def resolveLayout(apk,viewHierarchy, sensitiveTerms, stopwords, pattern, subs, useSupor=False):
	resolvedIds = {}
	textBefore = []
	disambigList = []
	for v in viewHierarchy.getOrdered():
		if v.is_input_field():
			hint = safeStrip(getText(v.hint, pattern, subs, stopwords))
			text = safeStrip(getText(v.text, pattern, subs, stopwords))
			label = safeStrip(getText(v.label if not useSupor else v.suporLabel, pattern, subs, stopwords))
                        #Remove repeats
			if hint == text:
				text = None
			if hint == label:
				label = None
			if text == label:
				label = None

                        #Append context to previous
			for idx, widget in enumerate(disambigList):
				if label is not None:
					disambigList[idx][1] = appendText(disambigList[idx][1], label)
				if hint is not None:
					disambigList[idx][1] = appendText(disambigList[idx][1], hint)
				if text is not None:
					disambigList[idx][1] = appendText(disambigList[idx][1], text)

                        
			# Resolve semantics
			resolved = resolveSemantics(hint, text, label, sensitiveTerms, v)

			#If we resolved the text, add to the list
			if resolved is not None:
				resolved = prependText(resolved, preprocessor.join_tokens(textBefore))
				disambigList.append([v, resolved])

			if label is not None:
				textBefore.append(label)				
			if hint is not None:
				textBefore.append(hint)
			if text is not None:
				textBefore.append(text)
		else:
			# Not an input field
			text = safeStrip(getText(v.text, pattern, subs, stopwords))
			if text is not None:
				textBefore.append(text)
				for idx,widget in enumerate(disambigList):
					disambigList[idx][1] = appendText(disambigList[idx][1], text)

	#Iterate through list of resolved terms
	resVals = {}
	for widget in disambigList:
		print "COUNTER", widget[0].counter
		# Get target word and context
		for rv in widget[1]:
			targetWord = rv[0]
			context = preprocessor.join_tokens(rv[1].split(" ")[-5:] + rv[2].split(" ")[:5]).strip()
			print "\t\t",rv[0], '|', context, os.path.basename(apk)
#			print "\t\t\t\t", rv[1].split(" ")[-5:], os.path.basename(apk)
#			print "\t\t\t\t", rv[2].split(" ")[:5], os.path.basename(apk)

			if widget[0].counter not in resVals:
				resVals[widget[0].counter] = []
			resVals[widget[0].counter].append([targetWord, context])
	return resVals

def disambiguate(apk, resolvedLayouts):
	resolved = {}
	for counterId in resVals:
		print "COUNTER",counterId,apk
		for sensTags in resVals[counterId]:
			targetWord = sensTags[0]
			context = sensTags[1]

			if counterId not in resolved:
				resolved[counterId] = []

			#TODO CHECK ME
			if targetWord in ambig_terms:
				value = disambig(targetWord, context)
				print "\t\t%s_%d\t\t%s" % (targetWord, value, apk)
				if value in ambig_terms[targetWord]:
# HERE
					print "Disambiguated as",ambig_terms[targetWord][value]
					resolved[counterId].append(ambig_terms[targetWord][value])
			else:
				print "Adding tag ",targetWord
				resolved[counterId].append("%s" % (targetWord,)) #FIXME add disambiguation
	layoutParser.updateXmlTags2(apk, resolved, suporLabelFlag=False)
	if len(resolved) > 0:
		print resolved           
   

def resolveSUPOR(apk, resolvedLayouts):
	suporAmbigRes = {}
	for l in open("SUPOR_AMBIG_RES.csv","r"):
		a,s = l.strip().split(',')
		suporAmbigRes[a] = s

	resolved = {}
	for counterId in resVals:
		print "COUNTER",counterId
		for sensTags in resVals[counterId]:
			targetWord = sensTags[0]
			context = sensTags[1]
			if counterId not in resolved:
				resolved[counterId] = []

			#TODO ADD SUPOR interpretation (e.g., most frequent)
			if targetWord in ambig_terms:
				if targetWord in suporAmbigRes:
					print "Adding tag ",suporAmbigRes[targetWord]
					resolved[counterId].append("%s" % (suporAmbigRes[targetWord],))
			else:
				print "Adding tag ",targetWord
				resolved[counterId].append("%s" % (targetWord,)) #FIXME add disambiguation
	layoutParser.updateXmlTags2(apk, resolved, suporLabelFlag=True)
	if len(resolved) > 0:
		print 'SUPOR', resolved

if __name__ == '__main__':
	ambig_terms = readDisambiguatedTerms()
	#Sensitive terms
	sensitiveTerms = readSensitiveTerms()
	#Stopwords
	stopwords = preprocessor.load_stop_words()
	stopwords.update("number_value_example")
	# Substitution terms
	pattern,subs = readTerms()

	suporFlag = (sys.argv[1] == "supor") if len(sys.argv) >= 2 else False

	print "Running UiRef" if not suporFlag else "Running SUPOR"
	layout_files = getLayoutFiles()
	for apk in layout_files:
		with codecs.open(LOGFILE, 'a', 'utf-8') as logoutfile:
			logoutfile.write(apk)
			logoutfile.write('\n')

		try:
			viewHierarchy = layoutParser.parseXmlFile(apk)
		except:
			continue
		resVals = resolveLayout(apk,viewHierarchy, sensitiveTerms, stopwords, pattern, subs, suporFlag)
		if len(resVals) > 0:
			print resVals
		if suporFlag:
			resolveSUPOR(apk, resVals)
		else:
			disambiguate(apk, resVals)

	#Resolved by hint(92820), resolved by label(85940), resolved by text(11890)
	print "Resolved by hint(%d), resolved by label(%d), resolved by text(%d)" % (resolvedByHint, resolvedByLabel, resolvedByText)
	print suporIncorrectLabRes,"/",suporIncorrectLabResTotal, "-- no res ", suporIncorrectLabNoRes
