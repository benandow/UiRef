import os
import sys
import re
import parse_layout as layoutParser
import preprocessor
import string
import subprocess
import pickle
import numpy as np
#NOTE Need to run with: DYLD_LIBRARY_PATH="$JULIA_PATH/lib/julia/:lib/ set

resolvedByHint = 0
resolvedByText = 0
resolvedByLabel = 0
totalInputField = 0

AMBIG_TERM_FILE = "AMBIG_WORDS.csv"

# Ambigious terms that need to be resolved
ambig_terms = {} 

COLLOCATIONS_FILE = u'COLLOC.txt'
SEMANTIC_BUCKETS_FILE = u'SEMANTIC_BUCKETS.txt'
LAYOUT_PATHS_FILE = u'LAYOUT_FILES.txt'

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

def readSensitiveTerms():
	sdict = {}
	for line in open(SEMANTIC_BUCKETS_FILE, 'r'):
		syns = re.sub(r'\s+\|\s+', u'|', toUnicode(line).strip()).split(u'|')
		syns = [re.sub(r'\s+', u'_', s.strip()) for s in syns]
		for s in syns:
			sdict[s] = syns[0]
	return sdict


def getLayoutFiles():
	if os.path.isfile(LAYOUT_PATHS_FILE):
		return [line.strip() for line in open(LAYOUT_PATHS_FILE, 'r')]

	return []


def readDisambiguatedTerms():
	terms = np.genfromtxt(AMBIG_TERM_FILE, dtype=str, delimiter=',')
	for word,wid,wtag in terms:
		if "UNKNOWN" in wtag:
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


def checkAmbigTerms(word, sensitiveTerms):
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
                if tok.strip() in ambig_terms.keys():
                        resolvedTerms[idx] = [tok.strip(), preprocessor.join_tokens(textBefore), []]#term,before,after
                #Append the token to "text before" array
                textBefore.append(tok.strip())

       # Return resolved terms [][]
        return [ resolvedTerms[key][0] for key in resolvedTerms ]
	

def resolveSemantics(apk, hint, text, label, sensitiveTerms, v):
	global resolvedByHint
	global resolvedByText
	global resolvedByLabel


	with open('AMBIG_TERM_REQ_PER_LAYOUT.csv','ab') as OUPUT_FILE:
		if hint is not None:
			hres = checkAmbigTerms(hint, sensitiveTerms)
			if hres is not None and len(hres) > 0:
				OUPUT_FILE.write('AMBIG,%s,%s,%s\n' % (apk, v.counter, ','.join(hres)))
			else:
				OUPUT_FILE.write('NONAMBIG,%s,%s,%s\n' % (apk, v.counter, ','.join(hres)))
		if text is not None:
			tres = checkAmbigTerms(text, sensitiveTerms)
			if tres is not None and len(tres) > 0:
				OUPUT_FILE.write('AMBIG,%s,%s,%s\n' % (apk, v.counter, ','.join(tres)))
			else:
				OUPUT_FILE.write('NONAMBIG,%s,%s,%s\n' % (apk, v.counter, ','.join(tres)))
		if label is not None:
			lres = checkAmbigTerms(label, sensitiveTerms)
			if lres is not None and len(lres) > 0:
				OUPUT_FILE.write('AMBIG,%s,%s,%s\n' % (apk, v.counter, ','.join(lres)))
			else:
				OUPUT_FILE.write('NONAMBIG,%s,%s,%s\n' % (apk, v.counter, ','.join(lres)))

	if hint is not None:
		resolved = resolveSensitiveTerms(hint, sensitiveTerms)
		hres = checkAmbigTerms(hint, sensitiveTerms)
		if len(resolved) > 0:
			with open('AMBIG_TERM_RES_PER_LAYOUT.csv','ab') as OUPUT_FILE:
				if hres is not None and len(hres) > 0:
					OUPUT_FILE.write('RESOLVED_HINT,%s,%s,%s\n' % (apk, v.counter, ','.join(hres)))
				else:
					OUPUT_FILE.write('NOT_HINT,%s,%s,%s\n' % (apk, v.counter, ','.join(hres)))
			if label is not None:
				resolved = prependText(resolved, label)
			if text is not None:
				resolved = appendText(resolved, text)
			resolvedByHint += 1
			return resolved

	if text is not None:
		resolved = resolveSensitiveTerms(text, sensitiveTerms)
		tres = checkAmbigTerms(text, sensitiveTerms)
		if len(resolved) > 0:
			with open('AMBIG_TERM_RES_PER_LAYOUT.csv','ab') as OUPUT_FILE:
				if tres is not None and len(tres) > 0:
					OUPUT_FILE.write('RESOLVED_TEXT,%s,%s,%s\n' % (apk, v.counter, ','.join(tres)))
				else:
					OUPUT_FILE.write('NOT_TEXT,%s,%s,%s\n' % (apk, v.counter, ','.join(tres)))

			if label is not None:
				resolved = prependText(resolved, label)
			if hint is not None:
				resolved = prependText(resolved, hint)
			resolvedByText += 1
			return resolved

	if label is not None:
		resolved = resolveSensitiveTerms(label, sensitiveTerms)
		lres = checkAmbigTerms(label, sensitiveTerms)
		if len(resolved) > 0:
			with open('AMBIG_TERM_RES_PER_LAYOUT.csv','ab') as OUPUT_FILE:
				if lres is not None and len(lres) > 0:
					OUPUT_FILE.write('RESOLVED_LABEL,%s,%s,%s\n' % (apk, v.counter, ','.join(lres)))
				else:
					OUPUT_FILE.write('NOT_LABEL,%s,%s,%s\n' % (apk, v.counter, ','.join(lres)))

			if hint is not None:
				resolved = prependText(resolved, hint)
			if text is not None:
				resolved = prependText(resolved, text)
			resolvedByLabel += 1
			return resolved
	return None
###############################

def resolveLayout(apk,viewHierarchy, sensitiveTerms, stopwords, pattern, subs, useSupor=False):
	global totalInputField
	resolvedIds = {}

	textBefore = []
	disambigList = []
	for v in viewHierarchy.getOrdered():
		if v.is_input_field():
			totalInputField += 1
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
			resolved = resolveSemantics(apk, hint, text, label, sensitiveTerms, v)

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
#		print "COUNTER", widget[0].counter
                # Get target word and context
		for rv in widget[1]:
			targetWord = rv[0]
			context = preprocessor.join_tokens(rv[1].split(" ")[-5:] + rv[2].split(" ")[:5]).strip()
#			print "\t\t",rv[0], '|', context, os.path.basename(apk)
#			print "\t\t\t\t", rv[1].split(" ")[-5:], os.path.basename(apk)
#			print "\t\t\t\t", rv[2].split(" ")[:5], os.path.basename(apk)

			if widget[0].counter not in resVals:
				resVals[widget[0].counter] = []
			resVals[widget[0].counter].append([targetWord, context])
	
	return resVals

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
		viewHierarchy = layoutParser.parseXmlFile(apk)
		resVals = resolveLayout(apk,viewHierarchy, sensitiveTerms, stopwords, pattern, subs, suporFlag)
#                if suporFlag:
#                    resolveSUPOR(apk, resVals)
#                else:
#                    disambiguate(apk, resVals)

	#Resolved by hint(92820), resolved by label(85940), resolved by text(11890)
	print "Resolved by hint(%d), resolved by label(%d), resolved by text(%d)" % (resolvedByHint, resolvedByLabel, resolvedByText)
	print "Total number of input fields: ", totalInputField
