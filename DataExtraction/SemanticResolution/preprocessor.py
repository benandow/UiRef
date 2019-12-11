import re
import string
import unicodedata
from nltk.stem.snowball import SnowballStemmer

nlp = None
stemmer = SnowballStemmer("english")

prompt_regex = r'^\s*(please\s*)?((re|re-)?enter|(re|re-)?input|provide|(re|re-)?type|give|send|caption|discuss|add|find|put|choose|compose|configure|copy|create|customize|describe|edit|fill|insert|pick|specify|search|submit|update|verify|view|paste|select|confirm|press|click|write|tap|check)(\s+(your|a|the|an|by))?\b'

##### Parsing a line of text
line_regex = re.compile("""
                     ^<(?P<file_name>.*?)_(?P<layout_id>[0-9a-fA-F]+?)\.xml>\\s+
                     (?P<text>.*)
                     """, re.VERBOSE)

ordinal_numbers = ['1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th', '9th', '10th', '11th', '12th', '13th', '14th', '15th', '16th', '17th', '18th', '19th', '20th', '21st', '22nd', '23rd', '24th', '25th', '26th', '27th', '28th', '29th', '30th', '31st', '32nd', '33rd', '34th', '35th', '36th', '37th', '38th', '39th', '40th', '41st', '42nd', '43rd', '44th', '45th', '46th', '47th', '48th', '49th', '50th', '51st', '52nd', '53rd', '54th', '55th', '56th', '57th', '58th', '59th']

###################################################################################
def getStemmer():
	return stemmer

def strip_leading_and_trailing_nums(token):
     if token not in ordinal_numbers:
		return u'number_value_example' if isNumber(token) else token.strip(u'1234567890')
     return token

def remove_non_ascii(text):
	if not isinstance(text, unicode):
		text = unicode(text, 'utf-8').lower()

	nfkd_form = unicodedata.normalize('NFKD', text).encode('ASCII', 'ignore')
	if not isinstance(nfkd_form, unicode):
		nfkd_form = unicode(nfkd_form, 'utf-8').lower()

	return nfkd_form

def replace_hyph_and_symbols(text):
	subst_rules = [
		{r'\be\-mail\b': u'email'},
		{r'\blog in\b' : u'login'},
		{r'\blog\-in\b': u'login'},
		{r'\sign in\b' : u'sign_in'},
		{r'\sign\-in\b': u'sign_in'},
		{r'\blog out\b' : u'logout'},
		{r'\blog\-out\b' : u'logout'},
		{r'\bre-type\b' : u'retype'},
		{r'\bwi-fi\b' : u'wifi'},
		{r'\bwi\bfi\b' : u'wifi'},
		{r'#' : u' number '},
		{r'&' : u' and '},
		{r'%' : u' percent '}
	]
	for rule in subst_rules:
		for (k, v) in rule.items():
#			regex = re.compile(k)
			text = re.sub(k, v, text)
	return re.sub('\s\s+', u' ', text.strip())

# Adapted from www.codigomanso.com/en/2010/09/truco-manso-eliminar-tags-html-en-python
def strip_html_markup(html):
	"""
	Strip HTML tags from any string and transfrom special entities
	"""
	text = html
 
	# apply rules in given order!
	rules = [
#		{ r'>\s+' : u'>'},                  # remove spaces after a tag opens or closes
		{ r'\s+' : u' '},                   # replace consecutive spaces
		{ r'\s*<br\s*/?>\s*' : u'. '},      # newline after a <br>
		{ r'</(div)\s*>\s*' : u'. '},       # newline after </p> and </div> and <h1/>...
		{ r'</(p|h\d)\s*>\s*' : u'. '},   # newline after </p> and </div> and <h1/>...
		{ r'<head>.*<\s*(/head|body)[^>]*>' : u'' },     # remove <head> to </head>
		{ r'<a\s+href=".*"[^>]*>([^"]+)</a>' : r'\1' },  # remove links
		{ r'<[^<]*?/?>' : u'' },            # remove remaining tags
		{ r'^\s+' : u'' }                   # remove spaces at the beginning
	]
 
	for rule in rules:
		for (k,v) in rule.items():
#			regex = re.compile(k)
			text  = re.sub(k, v, text)
 
	# replace special strings
	special = {
		'&nbsp;' : ' ', '&amp;' : '&', '&quot;' : '"',
		'&lt;'   : '<', '&gt;'  : '>'
	}
 
	for (k,v) in special.items():
		text = text.replace (k, v)
 
	return text



def replace_example_information(text):
	#Must keep IP address before date/time
	months = 'january|jan|february|feb|march|mar|april|apr|june|jun|july|jul|august|aug|september|sept|sep|october|oct|november|nov|december|dec|mm'
	fmonths = '%s|may' % (months,)
	days = 'monday|mon|tuesday|tues|tu|wednesday|wed|thursday|thurs|thu|friday|fri|saturday|sat|sunday|sun|dd'
	time = '[0-9x]{1,2}:[0-9x]{2}(:[0-9x]{2})?(\s?(a\.?m\.?|p\.?m\.?))?'
	
	data_example_regexes = [
			{r'\be\.g\.'							:	u'eg'},
			{r'\bi\.e\.'							:	u'ie'},
			{r'\be\.x\.'							:	u'ex'},
			{r'\b[0-9x]{4}(-| )?[0-9x]{4}(-| )?[0-9x]{4}(-| )?[0-9x]{4}\b'	:	u' credit_card_example '},
			{r'\b[0-9x]{4}(-| )?[0-9x]{6}(-| )?[0-9x]{5}\b' 		: 	u' credit_card_example '},
			{r'\b(1(-| )?)?\(?[0-9x]{3}\)?(-| )?[0-9x]{3}(-| )?[0-9x]{4}\b'	:	u' phone_number_example '},
			{r'\$(\s)?[0-9x]+((,[0-9x]{3})*)?(\.[0-9x]{2})?\b'		:	u' dollar_amount_example '},
			{r'\b[0-9x]{3}(-| )[0-9x]{2}(-| )[0-9x]{4}\b'			:	u' soc_sec_num_example '},
			{r'\b([0-9xa-f]{2}:){5}[0-9xa-f]{2}\b'				:	u' mac_addr_example '},
			{r'\b((http|ftp|https)://)?([0-9]{1,3}\.){3}[0-9]{1,3}(:[0-9]+)?\b' : u' ip_addr_example '},
			{r'\b%s\s*-\s*%s\b' % (time, time)				:	u' time_example to time_example '},
			{r'\b%s\b' % (time,) 						:	u' time_example '},
			{r'\b[0-9y]{4}(\s)?(\.|/|-)(\s)?[0-9m]{1,2}(\s)?(\.|/|-)(\s)?[0-9d]{1,2}\b'	:	u' date_example '},
			{r'\b[0-9m]{1,2}(\s)?(\.|/|-)(\s)?[0-9d]{1,2}(\s)?(\.|/|-)(\s)?[0-9y]{4}\b'	:	u' date_example '},
			{r'\b[0-9d]{1,2}(\s)?(\.|/|-)(\s)?[0-9m]{1,2}(\s)?(\.|/|-)(\s)?[0-9y]{4}\b'	:	u' date_example '},
			{r'\b[0-9m]{1,2}(\s)?(\.|/|-)(\s)?[0-9d]{1,2}(\s)?(\.|/|-)(\s)?[0-9y]{2}\b'	:	u' date_example '},
			{r'\b[0-9d]{1,2}(\s)?(\.|/|-)(\s)?[0-9m]{1,2}(\s)?(\.|/|-)(\s)?[0-9y]{2}\b'	:	u' date_example '},
			{r'\b((%s),?\s)?(%s)\s[0-9]{1,2}(,)?\s[0-9]{4}\b' % (days,fmonths,) :	u' date_example '},
			{r'\b((%s),?\s)?[0-9]{1,2}\s(%s)\s[0-9]{4}\b' % (days,fmonths,)	:	u' date_example '},
			{r'\b(%s)\b' % (months,)					:	u' month_example '},
			{r'\b(%s)\b' % (days,)						:	u' day_example '},
			{r'\bmm(yy|yyyy)\b'						:	u' date_example '},
			{r'\b(yy|yyyy)mmdd\b'						:	u' date_example '},
			{r'\bmm(\s)?/(\s)?(yyyy|yy)\b'					:	u' date_example '},
			{r'\byy\b'							:	u' year_example '},
			{r'\b(yyyy|2016|2018)\b'					:	u' year_example '},
			{r'\b[0-9]+(\.[0-9]+)?\%'					:	u' percentage_example '},
			{r'\%([0-9\.\-]+\$)?(s|f|d|x)'					:	u' '},	#Format strings
			{r'\$+'								:	u' dollar_sign '},
			{r'\b[\w\.-]+@[\w\.-]+\b'					:	u' email_address_example '},
			{r'\b[0-9]+\.[0-9]+\b'						:	u' decimal_number_example '},
			{r'\b((http|ftp|https|rtsp)://)([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?\b' : u'ip_addr_example'},
			{r'\b(www\.)([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?\b' : u' ip_addr_example '},
			{r'\bip_addr_example/'						:	u' ip_addr_example '},
			{r'^[0-9]{3}$'							:	u' three_digit_num '},
			{r'^[0-9]{4}$'							:	u' four_digit_num '},
			{r'^[0-9]{5}$'							:	u' five_digit_num '},
			{r'\s\s+'							:	u' '}
		]


	text = text.strip()
	for rule in data_example_regexes:
		for (k, v) in rule.items():
			text = re.sub(k, v, text)	
	return text

###################################################################################

def strip_prompts(text):
	if not isinstance(text, unicode):
		text = unicode(text, 'utf-8').lower()
	return re.sub(prompt_regex, u'', text.strip()).strip()

def strip_heading(text):
	text = text.strip()
	if not isinstance(text, unicode):
		text = unicode(text, 'utf-8').lower()
	
	line_match = line_regex.match(text)

	if not line_match:
		return None

	layout_name = line_match.group('file_name')
	layout_id = line_match.group('layout_id')


	line = remove_non_ascii(line_match.group('text').strip())
	return re.sub(prompt_regex, u'', full_preprocess2(line)).strip()

def parse_field2(line):
	line = line.strip()
	if not isinstance(line, unicode):
		line = unicode(line, 'utf-8').lower()

	line = remove_non_ascii(line.strip())
	line = re.sub(prompt_regex, u'', full_preprocess2(line)).strip()

	# TODO fix me with other punctuation
	split_chars = [',', '(', '/', ':','.']#, 'or', 'and']
	split_regex = r'(,|\(|/|:|\.)'#|\bor\b|\band\b)'
	lines_set = [w.strip() for w in re.split(split_regex, line) if w not in split_chars ] 

	new_set = []
	for t in lines_set:
		w = join_tokens([strip_punctuation(tok) for tok in tokenize(t)]).strip()
		if len(w) > 0:
			new_set.append(w)
	return new_set	


def parse_line(text):
	text = text.strip()
	if not isinstance(text, unicode):
		text = unicode(text, 'utf-8').lower()
	
	line_match = line_regex.match(text)

	if not line_match:
		return None

	layout_name = line_match.group('file_name')
	layout_id = line_match.group('layout_id')


	line = remove_non_ascii(line_match.group('text').strip())
	line = re.sub(prompt_regex, u'', full_preprocess2(line)).strip()

	# TODO fix me with other punctuation
	split_chars = [',', '(', '/', ':','.']#, 'or', 'and']
	split_regex = r'(,|\(|/|:|\.)'#|\bor\b|\band\b)'
	lines_set = [w.strip() for w in re.split(split_regex, line) if w not in split_chars ] 

	new_set = []
	for t in lines_set:
		w = join_tokens([strip_punctuation(tok) for tok in tokenize(t)]).strip()
		if len(w) > 0:
			new_set.append(w)

	return (layout_name, layout_id, new_set)


def parse_line2(text):
	text = text.strip()
	if not isinstance(text, unicode):
		text = unicode(text, 'utf-8').lower()
	
	line_match = line_regex.match(text)

	if not line_match:
		return None

	layout_name = line_match.group('file_name')
	layout_id = line_match.group('layout_id')
	line = full_preprocess2(line_match.group('text'))

	return (layout_name, layout_id, line)

#####

def full_preprocess2(text):
	if not isinstance(text, unicode):
		text = unicode(text, 'utf-8')

	line = strip_html_markup(text.strip()).strip()
	line = replace_example_information(line).strip()
	line = replace_hyph_and_symbols(line).strip()
	line = line.replace(u'/', u' / ')
	line = line.replace(u'\'', u'')	
	line = join_tokens([ strip_leading_and_trailing_nums(t) for t in tokenize2(line) ])

	return line.strip()

def splitNgram(ngram, ret_string_flag=False):
	n = len(ngram)
	if n <= 1:
		return None
	retVal = (ngram[:(n/2)], ngram[(n/2):]) if (n % 2 == 0) else (ngram[:(n/2)+1], ngram[(n/2):])
	return [join_tokens(retVal[0]), join_tokens(retVal[1])] if ret_string_flag else retVal

def join_tokens(tokens):
	return u' '.join(tokens)

def load_stop_words():
	from nltk.corpus import stopwords
	stop = set(stopwords.words('english'))
	stop.update((u'\n', u'cancel', u'ok', 're-enter', 'reenter', u'enter', u'set', u'use', u'go', u'button', u'new', u'please', u'app', u'select', u'applic', u'option', u'optional',  u'optionally', u'required', u'mandatory', u'...', u'..', u'click', u'add', u'edit', u'update', u'show', u'search', u'e.g.', u'i.e.', u'come', u'soon', u'include', u'get', u'could', u'would', u'take', u'also', u'continue', u'(required', u'(optional', u'come', u'many', u'within', u'find', u'press', u'want', u'let', u'along', u'every', u'keep', u'be', u'thank', u'choose', u'not', u'choose', u'via', u'something', u'else', u'without', u'like', u'must', u'need', u'specify', u'always', u'send', u'already', u'save', u'\'s', u'enable', u'disable', u'per', u'follow', u'may', u'etc', u'help', u'different', u'paste', u'non', u'see', u'insert', u'another', u'eg', u'ie', u'automatically', u'manually', u'accept', u'provide', u'since', u'whatever', u'completely', u'require', u'nt', u'll', u'textview', u'edittext', u've'))
	return stop
#	return set([stemmer.stem(s) for s in stop])

def load_spacy_nlp():
	global nlp
	if nlp is None:
		import spacy
		nlp = spacy.load('en')
	return nlp

def tokenize(text, lemmatize=True):
	if not isinstance(text, unicode):
		text = unicode(text, 'utf-8')

	load_spacy_nlp()
        textSafe = re.sub(r'(\.{2,})', u' ',text) # Due to spacy throwing assertion error (https://github.com/spacy-io/spaCy/issues/360)
	doc  = nlp(textSafe)
	if lemmatize:
		return [token.lemma_.strip() for token in doc if token.orth_ != u' ' ]
	return [token.orth_.strip() for token in doc if token.orth_ != u' ' ]

def tokenize2(text):
	return tokenize(text, False)
	
def strip_punctuation(token):
	punct = string.punctuation.replace('_', '')
	return u''.join([ t for t in token if t not in punct ])

#Conditon if word contains three or more consecutive tokens which are the same (e.g., ===, ----, xxxxxxx)
def containsThreeConsecTokens(token):
	return re.search(r'(.)\1\1', token)

def isPunctuation(token):
	return token in string.punctuation

def translate_non_alphanumerics(to_translate, translate_to=u''):
    not_letters_or_digits = u'!"#%\'()*+,-./:;<=>?@[\]^_`{|}~'
    translate_table = dict((ord(char), translate_to) for char in not_letters_or_digits)
    return to_translate.translate(translate_table)

def isNumber(token):
	try:
		if not isinstance(token, unicode):
			token = unicode(token, 'utf-8')
		float(translate_non_alphanumerics(token))
		return True
	except ValueError:
		return False


