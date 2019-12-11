from lxml import etree
from io import BytesIO
import os
import sys
import re

#################

ROOT_DIR = '/Users/benandow/Documents/GUIAndroidFramework/SEMANTIC_RESOLUTION/'

inputFieldClasses = ['com.widget.EditText', 'android.widget.AbsSpinner', 'android.widget.CheckedTextView', 'android.widget.RadioButton', 'android.widget.CheckBox', 'android.widget.ToggleButton', 'android.widget.Switch', 'android.support.v7.widget.SwitchCompat', 'android.widget.RatingBar']

class ViewObject:
	def __init__(self, counter=-1, name=None, l=0, r=0, t=0, b=0):
		self.counter = counter
		self.name = name
		self.l = l
		self.r = r
		self.t = t
		self.b = b
		self.text = None
		self.label = None
		self.suporLabel = None
		self.superclass = None
		self.inputType = None
		self.labelCounter = None
		self.suporLabelCounter = None
		self.hint = None
		self.privacyTag = None
		self.suporPrivacyTag = None
                self.annotatedLabelCounter = None
                self.annotatedPrivacyTag = None


	def set_text(self, text):
		self.text = text

	def set_privacy_tag(self, tag):
		self.privacyTag = tag

	def set_supor_privacy_tag(self, tag):
		self.suporPrivacyTag = tag

	def set_hint(self, hint):
		self.hint = hint

	def set_input_type(self, inputType):
		self.inputType = inputType

	def is_input_field(self):
			return self.superclass in inputFieldClasses 
	
	def is_edit_text(self):
		return self.superclass == 'com.widget.EditText'

	def set_label(self, text):
		self.label = text

	def set_supor_label(self, text):
		self.suporLabel = text

	def set_superclass(self, superclass):
		self.superclass = superclass

	def set_label_counter(self, labelcounter):
		self.labelCounter = labelcounter

	def set_supor_label_counter(self, suporlabelcounter):
		self.suporLabelCounter = suporlabelcounter

	def set_annotated_label_counter(self, annotatedlabelcounter):
		self.annotatedLabelCounter = annotatedlabelcounter

	def set_annotated_privacy_tag(self, annotatedprivacytag):
		self.annotatedPrivacyTag = annotatedprivacytag

	def inBounds(self, x, y):
		return x >= self.l and x <= self.r and y >= self.t and y <= self.b


class ViewHierarchy:
	def __init__(self):
		self.hierarchy = []
		self.sorted_y = None
	
	def set_package_name(self, package_name):
		self.package = package_name

	def set_layout_id(self, layout_id):
		self.layout = layout_id

	def append(self, v):
		self.hierarchy.append(v)

	def getHierarchy(self):
		return self.hierarchy

	def getViewInBounds(self, x, y):
		return [ v for v in self.hierarchy if v.inBounds(x, y) ]

	def getOrdered(self):
		if self.sorted_y is not None:
			return self.sorted_y
		labelIds = set([ v.labelCounter for v in self.hierarchy if v.labelCounter is not None ])
		sorted_vals  = sorted([(v.t, v.l, v) for v in self.hierarchy if v.counter not in labelIds])
		self.sorted_y = [y[2] for y in sorted_vals]
		return self.sorted_y
	
	def getBeforeAndAfter(self, v):
		if self.sorted_y is None:
			getOrdered(self)
		for idx,val in enumerate(self.sorted_y):
			if val.labelCounter == v.labelCounter:
				return (self.sorted_y[:idx], self.sorted_y[idx+1:])
		return None


#################

def traverse():
	for root in open(os.path.join(ROOT_DIR, 'APKS.txt')):
		basepath = os.path.join(os.path.join(ROOT_DIR, root.strip()), 'layouts')
		for f in os.listdir(basepath):
			if f.strip().endswith('.xml'):
				try:
					parseXmlFile(os.path.join(basepath, f))
				except:
					pass


def parseXmlFile(filename):
	viewHierarchy = ViewHierarchy()
	try:
		tree = etree.parse(filename)
		iterNode(tree.getroot(), viewHierarchy, 0, 0)
	except:
		print "Error", filename
	return viewHierarchy

def createViewObject(node, newL, newT):
	v = ViewObject(counter = node.get('counter'), name = node.get('name'), l=int(node.get('left'))+newL, r=int(node.get('right'))+newL, t=int(node.get('top'))+newT, b=int(node.get('bottom'))+newT)
	if node.get('text') is not None:
		v.set_text(node.get('text'))
	if node.get('hint') is not None:
		v.set_hint(node.get('hint'))
	if node.get('labeltext') is not None:
		v.set_label(node.get('labeltext'))
	if node.get('superclass') is not None:
		v.set_superclass(node.get('superclass'))
	if node.get('input') is not None:
		v.set_input_type(node.get('input'))
	if node.get('labelcounter') is not None:
		v.set_label_counter(node.get('labelcounter'))
	if node.get('privacyTag') is not None:
		v.set_privacy_tag(node.get('privacyTag'))
	if node.get('suporLabelCounter') is not None:
		v.set_supor_label_counter(node.get('suporLabelCounter'))
	if node.get('suporLabeltext') is not None:
		v.set_supor_label(node.get('suporLabeltext'))
	if node.get('suporPrivacyTag') is not None:
		v.set_supor_privacy_tag(node.get('suporPrivacyTag'))
	if node.get('annotatedLabelCounter') is not None:
		v.set_annotated_label_counter(node.get('annotatedLabelCounter'))
	if node.get('annotatedPrivacyTag') is not None:
		v.set_annotated_privacy_tag(node.get('annotatedPrivacyTag'))

	return v

def iterNode(node, viewHierarchy, parentL, parentT):
	newL = parentL
	newT = parentT
	if node.tag == u'LayoutDump':
		viewHierarchy.set_package_name(node.get('name'))
	elif node.tag == u'LayoutHierarchy':
		viewHierarchy.set_layout_id(node.get('id'))
	elif node.tag == u'ViewGroup':
		if node.get('visibility') != u'visible':
			return
		newL = newL + int(node.get('left'))
		newT = newT + int(node.get('top'))
	elif node.tag == u'View' and node.get('visibility') == u'visible':
		v = createViewObject(node, newL, newT)
		viewHierarchy.append(v)

	for child in node.iterchildren():
	#	print child.tag	
		iterNode(child, viewHierarchy, newL, newT)


def iterNode2(node, resolved, suporLabelFlag=False):
	if node.tag == u'View' and node.get('counter') in resolved:
		if not suporLabelFlag:
#		try:
#    			del node.attrib["privacyTag"]
#		except:
#		    pass
			node.attrib['privacyTag'] = resolved[node.get('counter')]
		else:
#		try:
#    			del node.attrib["suporPrivacyTag"]
#		except:
#		    pass
			node.attrib['suporPrivacyTag'] = resolved[node.get('counter')]
	for child in node.iterchildren():
		iterNode2(child, resolved, suporLabelFlag)

def iterNode3(node, resolved, suporLabelFlag=False):
	if node.tag == u'View' and node.get('counter') in resolved:
		if not suporLabelFlag:
#		try:
#    			del node.attrib["privacyTag"]
#		except:
#		    pass
			node.attrib['privacyTag'] = '|'.join(set(resolved[node.get('counter')]))
		else:
#		try:
#    			del node.attrib["suporPrivacyTag"]
#		except:
#		    pass
			node.attrib['suporPrivacyTag'] = '|'.join(set(resolved[node.get('counter')]))
	for child in node.iterchildren():
		iterNode3(child, resolved, suporLabelFlag)


def updateXmlTags2(filename, resolved,suporLabelFlag=False):
	if not os.path.exists(filename):
		return
	tree = etree.parse(filename)
	iterNode3(tree.getroot(), resolved, suporLabelFlag)
	with open(filename, 'w') as xmlFile:
		xmlFile.write(etree.tostring(tree))
		xmlFile.close()


def updateXmlTags(filename, resolved,suporLabelFlag=False):
	tree = etree.parse(filename)
	iterNode2(tree.getroot(), resolved, suporLabelFlag)
	with open(filename, 'w') as xmlFile:
		xmlFile.write(etree.tostring(tree))
		xmlFile.close()



if __name__ == '__main__':
	viewHierarchy = parseXmlFile(sys.argv[1])
	print "%s-%s" % (viewHierarchy.package, viewHierarchy.layout)

	for v in viewHierarchy.getOrdered():
		print v.counter, v.l, v.t, v.text.replace(u'\n', u' ') if v.text is not None else None
