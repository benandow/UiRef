package com.benandow.uiref;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;

import org.xml.sax.SAXException;

import com.benandow.uiref.labelResolver.GuiPlot;
import com.benandow.uiref.labelResolver.Pair;
import com.benandow.uiref.layoutModel.HierarchyNode;
import com.benandow.uiref.layoutModel.HierarchyTree;
import com.benandow.uiref.layoutModel.LayoutParser;
import com.benandow.uiref.layoutModel.LayoutWriter;

public class App {
	
	private static double times = 0.0d;
	private static int count = 0;
	
	public static File parseArguments(String[] args){
		//Takes layout file as input, outputs
		if(args.length < 1){
			dumpErrorMsg();
			System.exit(1);
		}
		File f = new File(args[0]);
		if(!f.exists()){
			dumpErrorMsg();
			System.exit(1);
		}
		return f;
	}
	
	public static void traverseFiles(File dir) {
		File[] files = dir.listFiles(new FilenameFilter() {
			public boolean accept(File dir, String name) {
				return name.toLowerCase().endsWith(".xml") || new File(dir, name).isDirectory();
			}
		});
		
		for(File f : files){
			if(f.isFile()){
				try{
					processFile(f);
				}catch(Exception e){
					e.printStackTrace();
					System.exit(0);
				}
			}else if(f.isDirectory()){
				traverseFiles(f);
			}
		}
	}

	public static void processFile(File layout_file) throws IOException, ParserConfigurationException, SAXException, TransformerException, XPathExpressionException{

		long t1 = System.currentTimeMillis();
		HierarchyTree tree = LayoutParser.getHierarchy(layout_file);
		if(tree == null || tree.getTreeRoot() == null){
			System.out.println("Error resolving values" + layout_file);
			System.exit(0);
			return;
		}
		System.out.println("Starting "+ layout_file.toString());

		GuiPlot plot = new GuiPlot(tree);
		List<Pair<HierarchyNode, HierarchyNode>> resolved = plot.resolveDescriptors();
		HashMap<String, HierarchyNode> map = plot.dumpRelationships(resolved);

		LayoutWriter.transformHierarchy(layout_file, layout_file, map, null, null);
		times += (System.currentTimeMillis()-t1);
		count++;
	}

	public static void dumpErrorMsg() {
		System.err.println("USAGE: java -jar labelresolver.jar <METADATA_DIRECTORY|LAYOUT_XML_FILE>");
		System.err.println("USAGE: java -jar labelresolver.jar");
	}
	

	public static void main(String[] args) throws ParserConfigurationException, SAXException, IOException, TransformerException {
		if(args.length < 1){
			dumpErrorMsg();
			return;
		}
		File f = parseArguments(args);
		if(f.isDirectory()){
			traverseFiles(f);
		}else{
			try{
				processFile(f);
			}catch(Exception e){
				e.printStackTrace();
				System.exit(0);
			}
		}
		System.out.println("Avg time = "+(times/(double)count)+" total = "+times+" "+count);
	}
}
