package com.benandow.android.gui.layout.statistics;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPathExpressionException;

import org.xml.sax.SAXException;

import com.benandow.android.gui.layoutModel.HierarchyNode;
import com.benandow.android.gui.layoutModel.HierarchyTree;
import com.benandow.android.gui.layoutModel.LayoutParser;

public class Main2 {

	public static int count = 0;
	public static ArrayList<Double> textLengths;
	public static ArrayList<Double> hintLengths;
	
	
	//TODO make more robust and collect other stats
	
	public static void main(String[] args) throws ParserConfigurationException, SAXException, IOException {
		if(args.length < 1){
			System.out.println("Usage: java -jar name.jar <DIRECTORY OF RESULTS>");
		}
		
		File f = new File("/Users/benandow/Documents/GUIAnalysisFramework/guianalysisframework/results/results");
		
		textLengths = new ArrayList<Double>();
		hintLengths = new ArrayList<Double>();
		if(f.exists()){
			walk(f);
		}
		System.out.println("TEXT (mean, stdev, count) = ("+mean(textLengths)+","+stdev(textLengths)+" "+textLengths.size()+")");
		System.out.println("HINT (mean, stdev, count) = ("+mean(hintLengths)+", "+stdev(hintLengths)+" "+hintLengths.size()+")");
		System.out.println("Total layout files: "+count);		
	}
	
	public static double mean(ArrayList<Double> array){
		double total = 0.0;
		for(Double d : array){
			total+=d.doubleValue();
		}
		return total/array.size();
	}
	
	public static double stdev(ArrayList<Double> array){
		double mean = mean(array);
		double result = 0.0;
		for(Double d : array){
			result += ((d.doubleValue()-mean)*(d.doubleValue()-mean));
		}
		return Math.sqrt(result/array.size());
	}
	
	public static void traverse(HierarchyNode node){
		if(node.isViewGroup()){
			for(HierarchyNode cnode : node.getChildren()){
				traverse(cnode);
			}
		}else if(node.isView()){
			if(node.getText() != null && !node.getText().isEmpty()){
				textLengths.add(Double.valueOf(node.getText().length()));
			}
			if(node.getHint() != null && !node.getHint().isEmpty()){
				hintLengths.add(Double.valueOf(node.getHint().length()));
			}
			
		}
	}
	
    public static void walk(File root) throws ParserConfigurationException, SAXException, IOException {

        File[] list = root.listFiles();

        if (list == null) return;

        for ( File f : list ) {
            if ( f.isDirectory() ) {
                walk(f);
               // System.out.println( "Dir:" + f.getAbsoluteFile() );
            }
            else if (f.getName().endsWith(".xml")){
        		HierarchyTree tree = LayoutParser.getHierarchy(f);
            	count++;
            	if(tree != null){
            		traverse(tree.getTreeRoot());
            	}
              //  System.out.println( "File:" + f.getAbsoluteFile() );
            }
        }
    }
	

}
