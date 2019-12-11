package com.benandow.android.gui.layoutRendererApp;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

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


public class GuiXmlDump {

	private Document doc;
	private Element root_element;
	private List<Element> hierarchy;
	private int id_counter;
	
	private GuiXmlDump(){
		this.hierarchy = new ArrayList<Element>();
		this.id_counter = 0;
	}
	
	private int getTos(){
		return this.hierarchy.size() - 1;
	}
	
	private Element getCurrentElement(){
		int tos = this.getTos();
		if(tos < 0 || tos >= this.hierarchy.size()){
			return null;
		}
		return this.hierarchy.get(tos);
	}
	
	public static GuiXmlDump createHierarchyXmlDump(String package_name){
		GuiXmlDump xml = new GuiXmlDump();
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		try {
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
			xml.doc = docBuilder.newDocument();
			xml.root_element = xml.doc.createElement(Constants.LAYOUT_DUMP_TAG);
			xml.hierarchy.add(xml.root_element);
			xml.doc.appendChild(xml.root_element);
			xml.root_element.setAttribute(Constants.NAME_ATTR, package_name);
		} catch (ParserConfigurationException e) {
			return null;
		}
		return xml;
	}
	
	public void addLayout(int layout_id, double render_time){
		Element layout = this.doc.createElement(Constants.LAYOUT_HIERARCHY_TAG);
		Element root = this.getCurrentElement();
		if(root == null){
			//TODO we have a problem
			return;
		}
		root.appendChild(layout);
		layout.setAttribute(Constants.ID_ATTR, Integer.toHexString(layout_id));
		layout.setAttribute(Constants.RENDER_TIME_ATTR, Double.toString(render_time));
		//Add view to stack
		this.hierarchy.add(layout);
	}
		
	public void addViewGroup(HashMap<String, String> params){
		Element vg = this.doc.createElement(Constants.VIEW_GROUP_TAG);
		
		vg.setAttribute(Constants.COUNTER_REF_ID, Integer.toString(this.id_counter++));

		for(String key : params.keySet()){
			String value = params.get(key);
			if(value != null){
				vg.setAttribute(key, value);
			}
		}
		
		Element root = this.getCurrentElement();
		if(root == null){
			return;
		}
		root.appendChild(vg);
		
		//Add view to stack
		this.hierarchy.add(vg);
	}
		
	public void addViewElement(HashMap<String, String> params){
		Element view = doc.createElement(Constants.VIEW_TAG);
		view.setAttribute(Constants.COUNTER_REF_ID, Integer.toString(this.id_counter++));

		//Add attributes
		for(String key : params.keySet()){
			String value = params.get(key);
			if(value != null){
				view.setAttribute(key, value);
			}
		}
		
		//Get layout = write
		Element root = this.getCurrentElement();
		if(root == null){
			//TODO we have a problem
			return;
		}
		root.appendChild(view);
	}
	
		
	//Remove view from stack
	public void endElement(){
		int tos = this.getTos();
		if(tos > 0 && tos < this.hierarchy.size()){
			this.hierarchy.remove(tos);
		}
	}
	
	public void writeToFile(File output_file) throws TransformerException{
		DOMSource source = new DOMSource(doc);
		StreamResult result = new StreamResult(output_file);
		Transformer transformer = TransformerFactory.newInstance().newTransformer();
		transformer.transform(source, result);
	}
	
	
//// REMOVE CODE BELOW ONCE CORRECTNESS VERIFIED
	
	//FIXME pass parameters with HashMap
	public void addViewGroup(String class_name, int[] ltrb, int id, String visibility){
		Element vg = this.doc.createElement(Constants.VIEW_GROUP_TAG);
		vg.setAttribute(Constants.NAME_ATTR, class_name);
		Element root = this.getCurrentElement();
		if(root == null){
			//TODO we have a problem
			return;
		}
		root.appendChild(vg);
		vg.setAttribute(Constants.COUNTER_REF_ID, Integer.toString(this.id_counter++));
		vg.setAttribute(Constants.LEFT_ATTR, Integer.toString(ltrb[0]));
		vg.setAttribute(Constants.TOP_ATTR, Integer.toString(ltrb[1]));
		vg.setAttribute(Constants.RIGHT_ATTR, Integer.toString(ltrb[2]));
		vg.setAttribute(Constants.BOTTOM_ATTR, Integer.toString(ltrb[3]));
		vg.setAttribute(Constants.ID_ATTR, Integer.toHexString(id));
		
		if(visibility != null){
			vg.setAttribute(Constants.VISIBILITY_ATTR, visibility);
		}
		
		//Add view to stack
		this.hierarchy.add(vg);
	}
	
	
	//FIXME Pass parameters using a hashmap to clean up method signature
	public void addViewElement(String class_name, int[] ltrb, String text, String hint, int id, String superClass, String visibility, String inputType, String textOn, String textOff){
		Element view = doc.createElement(Constants.VIEW_TAG);
		view.setAttribute(Constants.COUNTER_REF_ID, Integer.toString(this.id_counter++));
		view.setAttribute(Constants.NAME_ATTR, class_name);
		view.setAttribute(Constants.LEFT_ATTR, Integer.toString(ltrb[0]));
		view.setAttribute(Constants.TOP_ATTR, Integer.toString(ltrb[1]));
		view.setAttribute(Constants.RIGHT_ATTR, Integer.toString(ltrb[2]));
		view.setAttribute(Constants.BOTTOM_ATTR, Integer.toString(ltrb[3]));
		view.setAttribute(Constants.ID_ATTR, Integer.toHexString(id));
		
		if(inputType != null){
			view.setAttribute(Constants.INPUT_TYPE, inputType);
		}
		
		//FIXME: We should have a better way to do this
		if(superClass.equals(Constants.WEBVIEW_CLASS)){
			view.setAttribute(Constants.URL_TEXT, text);
		}else if(text != null){
			view.setAttribute(Constants.TEXT_ATTR, text);
		}
		
		if(superClass.equals(Constants.WEBVIEW_CLASS)){
			view.setAttribute(Constants.ORIGINAL_URL_TEXT, text);
		}else if(hint != null){
			view.setAttribute(Constants.HINT_ATTR, hint);
		}
		
		if(superClass != null){
			view.setAttribute(Constants.SUPER_ATTR, superClass);
		}
		if(visibility != null){
			view.setAttribute(Constants.VISIBILITY_ATTR, visibility);
		}
		if(textOn != null){
			view.setAttribute(Constants.TEXT_ON_ATTR, textOn);
		}
		if(textOff != null){
			view.setAttribute(Constants.TEXT_OFF_ATTR, textOff);
		}
		
		//Get layout = write
		Element root = this.getCurrentElement();
		if(root == null){
			//TODO we have a problem
			return;
		}
		root.appendChild(view);
	}
	
}