package com.benandow.android.gui.labelResolver;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;

import org.xml.sax.SAXException;

import com.benandow.android.gui.layoutModel.HierarchyNode;
import com.benandow.android.gui.layoutModel.HierarchyTree;
import com.benandow.android.gui.layoutModel.LayoutParser;
import com.benandow.android.gui.layoutModel.LayoutWriter;

public class Main {

	private static double times = 0.0d;
	private static int count = 0;
	
	public static File parseArguments(String[] args){
		//Takes layout file as input, outputs
		if(args.length < 1){
			System.out.println("command <directory_of_layout_files>");
			System.exit(1);
		}
		
		File dir = new File(args[0]);
		if(!dir.isDirectory()){
			System.out.println("command <directory_of_layout_files>");
			System.exit(1);
		}
		return dir;
	}
	
	public static void traverseFiles(File dir) {
		File[] files = dir.listFiles(new FilenameFilter() {
			@Override
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

	public static void main(String[] args) throws ParserConfigurationException, SAXException, IOException, TransformerException {
//		args = new String[]{"/Users/benandow/Research/annotatedLayoutsDavis/layouts/", "/Users/benandow/Documents/GUIAnalysisFramework/privateTermsClean.txt"};

		if(args.length < 1){
			System.err.println("USAGE: java -jar labelresolver.jar <METADATA_DIRECTORY>");
			return;
		}
		traverseFiles(parseArguments(args));
		System.out.println("Avg time = "+(times/(double)count)+" total = "+times+" "+count);
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

		//Resolve using our method
		GuiPlot plot = new GuiPlot(tree);
		List<Pair<HierarchyNode, HierarchyNode>> resolved = plot.resolveDescriptors();
		HashMap<String, HierarchyNode> map = plot.dumpRelationships(resolved);
		System.gc();

		//Resolve using SUPOR's method
		SuporPlot suporPlot = new SuporPlot(tree);
		suporPlot.resolveDescriptors();
		HashMap<String, HierarchyNode> suporMap = suporPlot.dumpRelationships();
		LayoutWriter.transformHierarchy(layout_file, layout_file, map, suporMap, null);
		times += (System.currentTimeMillis()-t1);
		count++;
	}
}
