import os
import re
import string
from lxml import etree

import LayoutParser
import Preprocessor
import Util
from adagramDisambigModule import *

#NOTE Need to run with: DYLD_LIBRARY_PATH="$JULIA_PATH/lib/julia/:lib/ set

class SemanticResolver:

	def __init__(self, ):
		self.resolvedByHint = 0
		self.resolvedByText = 0
		self.resolvedByLabel = 0

		COLLOCATIONS_FILE = '/ext/data/COLLOC.txt'
		AMBIG_TERM_FILE = "/ext/data/AMBIG_WORDS.csv"
		SEMANTIC_BUCKETS_FILE = '/ext/data/SEMANTIC_BUCKETS.xml'
		self.ambig_terms = Util.readDisambiguatedTerms(AMBIG_TERM_FILE) 
		self.sensitiveTerms = Util.readSensitiveTerms(SEMANTIC_BUCKETS_FILE)
		self.stopwords = Preprocessor.load_stop_words()
		self.stopwords.update("number_value_example")
		self.pattern, self.subs = Util.readTerms(COLLOCATIONS_FILE)

	# Append text to "text before" array
	def prependText(self, resolved, tval):
		for r in resolved:
			r[1] = re.sub(r'\s\s+', u' ', '%s %s' % (tval, r[1])).strip()
		return resolved	

	# Append text to "text after array"
	def appendText(self, resolved, tval):
		for r in resolved:
			r[2] = re.sub(r'\s\s+', u' ', '%s %s' % (r[2], tval)).strip()
		return resolved	

	def resolveSensitiveTerms(self, word):
		if word is None:
			return None
	
		# Sensitive term dictionary
		resolvedTerms = {}
		# Text before the sensitive term
		textBefore = []
		# For each word
		for idx,tok in enumerate(word.split(u' ')):
			# Append token to "text after" array
			for poskey in resolvedTerms:
				resolvedTerms[poskey][2].append(tok.strip())
	                
			# If a sensitive term or ambiguous term add the term to the resolvedTerm, add textBefore, and empty array for text after
			if tok.strip() in self.sensitiveTerms:
				resolvedTerms[idx] = [self.sensitiveTerms[tok.strip()], Preprocessor.join_tokens(textBefore), []]#term,before,after
			elif tok.strip() in self.ambig_terms:
				resolvedTerms[idx] = [tok.strip(), Preprocessor.join_tokens(textBefore), []]#term,before,after
			#Append the token to "text before" array
			textBefore.append(tok.strip())
	
		# Return resolved terms [][]
		return [ [resolvedTerms[key][0], resolvedTerms[key][1], Preprocessor.join_tokens(resolvedTerms[key][2]) ] for key in resolvedTerms ]


	def resolve_internal(self, t1, t2, t3, appendFlag, counterId):
		if t1 is not None:
			resolved = self.resolveSensitiveTerms(t1)
			if len(resolved) > 0:
				if t2 is not None:
					resolved = self.prependText(resolved, t2)
				if t3 is not None:
					if self.appendFlag:
						resolved = self.appendText(resolved, t3)
					else:
						resolved = self.prependText(resolved, t3)
				setattr(self, counterId, getattr(self, counterId) + 1)
				return resolved
		return None

	def resolveSemantics(self, hint, text, label):
		resolved = self.resolve_internal(hint, label, text, True, 'resolvedByHint')
		if resolved is not None:
			return resolved
		resolved = self.resolve_internal(text, label, hint, False, 'resolvedByText')
		if resolved is not None:
			return resolved
		resolved = self.resolve_internal(label, hint, text, False, 'resolvedByLabel')
		if resolved is not None:
			return resolved
		return None
###############################

	def resolveLayout(self, apk, viewHierarchy):
		def safeStrip(text):
			return text.strip() if text is not None else None
	
	
		def getText(text, pattern, subs, stopwords):
			if text is not None and len(text) > 0:
				text = text.replace(u'\n', u' ').replace('(', ' (').strip().lower()
				tlines = Preprocessor.parse_field(text)
				lines = []
				for t in tlines:
					t = Preprocessor.join_tokens([ tok for tok in Preprocessor.tokenize(t)])
					t = pattern.sub(lambda m: subs[re.escape(m.group(0))], t)
					t = Preprocessor.join_tokens([ Preprocessor.strip_leading_and_trailing_nums(tok) for tok in Preprocessor.tokenize(t, lemmatize=False) if tok not in stopwords and tok not in set(string.punctuation) and len(tok) > 1 and not Preprocessor.containsThreeConsecTokens(tok)])
					lines.append(t)
				t = Preprocessor.join_tokens(lines)
				return t if len(t) > 1 else None
			return None
	
	
	
		resolvedIds = {}
		textBefore = []
		disambigList = []
		for v in viewHierarchy.getOrdered():
			if v.is_input_field():
				hint = safeStrip(getText(v.hint, self.pattern, self.subs, self.stopwords))
				text = safeStrip(getText(v.text, self.pattern, self.subs, self.stopwords))
				label = safeStrip(getText(v.label, self.pattern, self.subs, self.stopwords))
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
						disambigList[idx][1] = self.appendText(disambigList[idx][1], label)
					if hint is not None:
						disambigList[idx][1] = self.appendText(disambigList[idx][1], hint)
					if text is not None:
						disambigList[idx][1] = self.appendText(disambigList[idx][1], text)
	
	                        
				# Resolve semantics
				resolved = self.resolveSemantics(hint, text, label)
	
				#If we resolved the text, add to the list
				if resolved is not None:
					resolved = self.prependText(resolved, Preprocessor.join_tokens(textBefore))
					disambigList.append([v, resolved])
	
				if label is not None:
					textBefore.append(label)				
				if hint is not None:
					textBefore.append(hint)
				if text is not None:
					textBefore.append(text)
			else:
				# Not an input field
				text = safeStrip(getText(v.text, self.pattern, self.subs, self.stopwords))
				if text is not None:
					textBefore.append(text)
					for idx,widget in enumerate(disambigList):
						disambigList[idx][1] = self.appendText(disambigList[idx][1], text)
	
		#Iterate through list of resolved terms
		resVals = {}
		for widget in disambigList:
			print("COUNTER", widget[0].counter)
			# Get target word and context
			for rv in widget[1]:
				targetWord = rv[0]
				context = Preprocessor.join_tokens(rv[1].split(" ")[-5:] + rv[2].split(" ")[:5]).strip()
				print("\t\t",rv[0], '|', context, os.path.basename(apk))	
				if widget[0].counter not in resVals:
					resVals[widget[0].counter] = []
				resVals[widget[0].counter].append([targetWord, context])
		return resVals

	def disambiguate(self, apk, resVals):
		resolved = {}
		for counterId in resVals:
			print("COUNTER",counterId,apk)
			for sensTags in resVals[counterId]:
				targetWord = sensTags[0]
				context = sensTags[1]
	
				if counterId not in resolved:
					resolved[counterId] = []
	
				if targetWord in self.ambig_terms:
					value = disambig(targetWord, context)
					print("\t\t%s_%d\t\t%s" % (targetWord, value, apk))
					if value in self.ambig_terms[targetWord]:
	# HERE
						print("Disambiguated as", self.ambig_terms[targetWord][value])
						resolved[counterId].append(self.ambig_terms[targetWord][value])
				else:
					print("Adding tag ",targetWord)
					resolved[counterId].append("%s" % (targetWord,)) #FIXME add disambiguation
		LayoutParser.updateXmlTags(apk, resolved)
		if len(resolved) > 0:
			print(resolved)

########################

def getLayoutFiles(filename='/ext/data/LAYOUT_FILES.txt'):
	return [line.strip() for line in open(filename, 'r')] if os.path.isfile(filename) else []

def LOG(apk, logfile='/ext/semanticres.log',):
	with open(logfile, 'a') as logoutfile:
		logoutfile.write(apk)
		logoutfile.write('\n')



def main(logfile='/ext/semanticres.log'):
	print("Running UiRef")
	layout_files = getLayoutFiles()
	print("Loaded {} layouts".format(len(layout_files)))
	resolver = SemanticResolver()
	for apk in layout_files:
		LOG(apk, logfile)
		try:
			viewHierarchy = LayoutParser.parseXmlFile(apk)
		except:
			print("Error while parsing: {}".format(apk))
			continue
		resVals = resolver.resolveLayout(apk, viewHierarchy)
		if len(resVals) > 0:
			print(resVals)
		resolver.disambiguate(apk, resVals)
	print("Resolved by hint(%d), resolved by label(%d), resolved by text(%d)" % (resolver.resolvedByHint, resolver.resolvedByLabel, resolver.resolvedByText))

if __name__ == '__main__':
	main()
