package com.benandow.android.gui.layoutModel;

import java.io.File;

public class TestMain {

	static String filename =  "/Users/benandow/Documents/GUIAnalysisFramework/guianalysisframework/PYTHON_TERM_DISAMBIGUATION/WORKSPACE/out.xml";

	public static void main(String[] args) {
		String test = "  ".trim();
		if(test.isEmpty()){
			System.out.println("Empty");
		}
		
		try{
			HierarchyTree hier = LayoutParser.getHierarchy(new File(filename));
			HierarchyTree.dumpHierarchy(hier.getTreeRoot(), "\t");
			if(hier == null){
				System.out.println("Error");
			}else{
				System.out.println("No error");
			}
		}catch(Exception e){
			System.out.println("Exception");
		}
	}

}
