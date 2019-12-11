package com.benandow.android.gui.layoutModel;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Stack;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class LayoutParser {

	//FIXME change from DOM to SAX to speed up
	
	private HierarchyTree mTree;
	private Stack<HierarchyNode> mStack;
	private Document mDoc;
	private String fileName;
	
	private LayoutParser(){
		this.mTree = new HierarchyTree();
		this.mStack = new Stack<HierarchyNode>();
	}

	public static HierarchyTree getHierarchy(File f) throws ParserConfigurationException, SAXException, IOException{
		LayoutParser converter = new LayoutParser();
		DocumentBuilder dBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
		converter.mDoc = dBuilder.parse(f);
		Element e = converter.mDoc.getDocumentElement();
		converter.fileName = f.getName();
		e.normalize();
		converter.parse(e);
		return converter.mTree;
	}

	//TODO parse resolved labels and supor labels
	private HashMap<String, String> parseAttrs(Element e){
		//Convert to absolute coordinates
		int parentLeft = mStack.isEmpty() ? 0 : mStack.peek().getLeft();
		int parentTop = mStack.isEmpty() ? 0 : mStack.peek().getTop();
		int nleft = Integer.valueOf(e.getAttribute(Constants.LEFT_ATTR)) + parentLeft;
		int ntop = Integer.valueOf(e.getAttribute(Constants.TOP_ATTR)) + parentTop;
		int nright = Integer.valueOf(e.getAttribute(Constants.RIGHT_ATTR)) + parentLeft;
		int nbottom = Integer.valueOf(e.getAttribute(Constants.BOTTOM_ATTR)) + parentTop;
		HashMap<String, String> map = new HashMap<String, String>();
		map.put(Constants.NODE_TYPE, e.getTagName());
		map.put(Constants.NAME_ATTR, e.getAttribute(Constants.NAME_ATTR));
		map.put(Constants.LEFT_ATTR, String.valueOf(nleft));
		map.put(Constants.TOP_ATTR, String.valueOf(ntop));
		map.put(Constants.RIGHT_ATTR, String.valueOf(nright));
		map.put(Constants.BOTTOM_ATTR, String.valueOf(nbottom));
		map.put(Constants.TEXT_ATTR, e.getAttribute(Constants.TEXT_ATTR));
		map.put(Constants.HINT_ATTR, e.getAttribute(Constants.HINT_ATTR));
		map.put(Constants.ID_ATTR, e.getAttribute(Constants.ID_ATTR));
		map.put(Constants.SUPER_ATTR, e.getAttribute(Constants.SUPER_ATTR));
		map.put(Constants.VISIBILITY_ATTR, e.getAttribute(Constants.VISIBILITY_ATTR));
		map.put(Constants.COUNTER_REF_ID, e.getAttribute(Constants.COUNTER_REF_ID));
		map.put(Constants.INPUT_TYPE, e.getAttribute(Constants.INPUT_TYPE));
		map.put(Constants.DRAWABLE_ID_ATTR, e.getAttribute(Constants.DRAWABLE_ID_ATTR));
		map.put(Constants.DRAWABLE_TOP_ATTR, e.getAttribute(Constants.DRAWABLE_TOP_ATTR));
		map.put(Constants.DRAWABLE_RIGHT_ATTR, e.getAttribute(Constants.DRAWABLE_RIGHT_ATTR));
		map.put(Constants.DRAWABLE_BOTTOM_ATTR, e.getAttribute(Constants.DRAWABLE_BOTTOM_ATTR));
		map.put(Constants.DRAWABLE_LEFT_ATTR, e.getAttribute(Constants.DRAWABLE_LEFT_ATTR));
		map.put(Constants.DRAWABLE_VISIBILITY, e.getAttribute(Constants.DRAWABLE_VISIBILITY));
		map.put(Constants.SUPOR_PRIVACY_TAG, e.getAttribute(Constants.SUPOR_PRIVACY_TAG));
		map.put(Constants.PRIVACY_TAG, e.getAttribute(Constants.PRIVACY_TAG));
		map.put(Constants.ANNOTATED_LABEL_COUNTER, e.getAttribute(Constants.ANNOTATED_LABEL_COUNTER));
		map.put(Constants.ANNOTATED_PRIVACY_TAG, e.getAttribute(Constants.ANNOTATED_PRIVACY_TAG));
		map.put(Constants.SUPOR_LABEL_COUNTER_ATTR, e.getAttribute(Constants.SUPOR_LABEL_COUNTER_ATTR));
		map.put(Constants.LABEL_COUNTER_ATTR, e.getAttribute(Constants.LABEL_COUNTER_ATTR));
		
//		String label = e.getAttribute(Constants.LABEL_TEXT_ATTR);
//		String hint = e.getAttribute(Constants.HINT_ATTR);
//		String superClass = e.getAttribute(Constants.SUPER_ATTR);
//		if(	(superClass.equals(Constants.EDIT_TEXT_CLASS)		||
//				superClass.equals(Constants.ABS_SPINNER_CLASS) 		||
//				superClass.equals(Constants.CHECKBOX_CLASS) 		||
//				superClass.equals(Constants.RADIO_BUTTON_CLASS) 	||
//				superClass.equals(Constants.SWITCH_CLASS) 			||
//				superClass.equals(Constants.SWITCH_COMPAT_CLASS) 	||
//				superClass.equals(Constants.TOGGLE_BUTTON_CLASS) 	||
//				superClass.equals(Constants.RATING_BAR_CLASS))	
//			&&	((hint != null && !hint.isEmpty()) || (label != null && !label.isEmpty()))){
//			System.out.printf("%s\tLABEL={%s}\tHINT={%s}\n", fileName, label.toLowerCase(), hint.toLowerCase());
//		}
		
		return map;
	}
	
	private void parse(Node n){		
		if(n.getNodeType() == Node.ELEMENT_NODE){
			Element e =(Element)n;
			if (e.getTagName().equals(Constants.LAYOUT_DUMP_TAG)) {
				this.mTree.setPackageName(e.getAttribute(Constants.NAME_ATTR));
				parse(e.getFirstChild());
			} else if (e.getTagName().equals(Constants.LAYOUT_HIERARCHY_TAG)) {
				this.mTree.setLayoutId(Integer.parseInt(e.getAttribute(Constants.ID_ATTR),16));
				parse(e.getFirstChild());
			} else{
				
				HierarchyNode node = new HierarchyNode(parseAttrs(e));
				
//				HierarchyNode node = new HierarchyNode(
//						e.getTagName(), 
//						e.getAttribute(Constants.NAME_ATTR), 
//						e.getAttribute(Constants.TEXT_ATTR),
//						e.getAttribute(Constants.HINT_ATTR),
//						e.getAttribute(Constants.ID_ATTR),
//						nleft,
//						ntop,
//						nright,
//						nbottom,
//						e.getAttribute(Constants.SUPER_ATTR),
//						e.getAttribute(Constants.VISIBILITY_ATTR),
//						e.getAttribute(Constants.COUNTER_REF_ID),
//						e.getAttribute(Constants.INPUT_TYPE),
//						e.getAttribute(Constants.DRAWABLE_ID_ATTR),
//						e.getAttribute(Constants.DRAWABLE_TOP_ATTR),
//						e.getAttribute(Constants.DRAWABLE_RIGHT_ATTR),
//						e.getAttribute(Constants.DRAWABLE_BOTTOM_ATTR),
//						e.getAttribute(Constants.DRAWABLE_LEFT_ATTR),
//						e.getAttribute(Constants.DRAWABLE_VISIBILITY),
//						e.getAttribute(Constants.SUPOR_PRIVACY_TAG),
//						e.getAttribute(Constants.PRIVACY_TAG)
//						);
				if (e.getTagName().equals(Constants.VIEW_GROUP_TAG)) {
					if(mStack.isEmpty()){
						this.mTree.setTreeRoot(node);
					}else{
						mStack.peek().setChild(node);
					}
					mStack.push(node);
					NodeList nl = n.getChildNodes();
					for(int i = 0; i < nl.getLength(); i++){
						parse(nl.item(i));
					}
					mStack.pop();
				}else if (e.getTagName().equals(Constants.VIEW_TAG)) {
					mStack.peek().setChild(node);
				}//else if
			}//else
		}
	}//parse
}