package com.benandow.android.gui.layoutModel;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class LayoutWriter {

	private Document mDoc;
	
	private LayoutWriter(){
	}
	
	public void writeToFile(File output_file) throws TransformerException{
		DOMSource source = new DOMSource(this.mDoc);
		StreamResult result = new StreamResult(output_file);
		Transformer transformer = TransformerFactory.newInstance().newTransformer();
		transformer.transform(source, result);
	}
	
	public static void transformHierarchy(File inputFile, File outputFile, HashMap<String, HierarchyNode> map, HashMap<String, HierarchyNode> suporMap, HashMap<String, HierarchyNode> annotatedMap) throws ParserConfigurationException, SAXException, IOException, TransformerException{
		LayoutWriter converter = new LayoutWriter();
		DocumentBuilder dBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
		converter.mDoc = dBuilder.parse(inputFile);
		Element e = converter.mDoc.getDocumentElement();
		e.normalize();
		converter.transform(e, map, suporMap, annotatedMap);
		converter.writeToFile(outputFile);
	}
	
	public void transform(Node n, HashMap<String, HierarchyNode> map, HashMap<String, HierarchyNode> suporMap, HashMap<String, HierarchyNode> annotatedMap){
		if(n.getNodeType() == Node.ELEMENT_NODE){
			Element e =(Element)n;
			if (e.getTagName().equals(Constants.LAYOUT_DUMP_TAG)) {
				transform(e.getFirstChild(), map, suporMap, annotatedMap);
			} else if (e.getTagName().equals(Constants.LAYOUT_HIERARCHY_TAG)) {
				transform(e.getFirstChild(), map, suporMap, annotatedMap);
			} else{
				if (e.getTagName().equals(Constants.VIEW_GROUP_TAG)) {
					NodeList nl = n.getChildNodes();
					for(int i = 0; i < nl.getLength(); i++){
						transform(nl.item(i), map, suporMap, annotatedMap);
					}
				}else if (e.getTagName().equals(Constants.VIEW_TAG)) {
					String counterRef = e.getAttribute(Constants.COUNTER_REF_ID);
					if(map != null && map.containsKey(counterRef)){
						HierarchyNode node = map.get(counterRef);
						if(node != null && node.getPrivacyTag() != null){
							e.setAttribute(Constants.PRIVACY_TAG, node.getPrivacyTag());
						}else if(node != null && node.getPrivacyTag() == null){
							e.removeAttribute(Constants.PRIVACY_TAG);
						}
						if(node!= null && node.getAssociatedLabel() != null){
							e.setAttribute(Constants.LABEL_NAME_ATTR, node.getAssociatedLabel().getName());
							e.setAttribute(Constants.LABEL_ID_ATTR, node.getAssociatedLabel().getId());
							e.setAttribute(Constants.LABEL_COUNTER_ATTR, node.getAssociatedLabel().getCounterId());
							e.setAttribute(Constants.LABEL_TEXT_ATTR, node.getAssociatedLabel().getText());
						}else if(node!= null && node.getAssociatedLabel() == null){
							e.removeAttribute(Constants.LABEL_NAME_ATTR);
							e.removeAttribute(Constants.LABEL_ID_ATTR);
							e.removeAttribute(Constants.LABEL_COUNTER_ATTR);
							e.removeAttribute(Constants.LABEL_TEXT_ATTR);
						}
					}
					
					if(suporMap != null && suporMap.containsKey(counterRef)){
						HierarchyNode node = suporMap.get(counterRef);
						if(node != null && node.getSuporPrivacyTag() != null){
							e.setAttribute(Constants.SUPOR_PRIVACY_TAG, node.getSuporPrivacyTag());
						}
						
						if(node!= null && node.getAssociatedSUPORLabel() != null){
							e.setAttribute(Constants.SUPOR_LABEL_NAME_ATTR, node.getAssociatedSUPORLabel().getName());
							e.setAttribute(Constants.SUPOR_LABEL_ID_ATTR, node.getAssociatedSUPORLabel().getId());
							e.setAttribute(Constants.SUPOR_LABEL_COUNTER_ATTR, node.getAssociatedSUPORLabel().getCounterId());
							e.setAttribute(Constants.SUPOR_LABEL_TEXT_ATTR, node.getAssociatedSUPORLabel().getText());	
						}else if(node!= null && node.getAssociatedSUPORLabel() == null){
							e.removeAttribute(Constants.SUPOR_LABEL_NAME_ATTR);
							e.removeAttribute(Constants.SUPOR_LABEL_ID_ATTR);
							e.removeAttribute(Constants.SUPOR_LABEL_COUNTER_ATTR);
							e.removeAttribute(Constants.SUPOR_LABEL_TEXT_ATTR);
						}
					}
					
					if(annotatedMap != null && annotatedMap.containsKey(counterRef)){
						HierarchyNode node = annotatedMap.get(counterRef);
						if(node != null && node.getAnnotatedPrivacyTag() != null){
							e.setAttribute(Constants.ANNOTATED_PRIVACY_TAG, node.getAnnotatedPrivacyTag());
						}
						if(node != null && node.getAnnotatedLabelCounter() != null){
							e.setAttribute(Constants.ANNOTATED_LABEL_COUNTER, node.getAnnotatedLabelCounter());
						}
					}
				}//else if
			}//else
		}
	}
}
