package com.benandow.android.gui.userStudy;

import java.io.File;
import java.io.IOException;

import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.SAXException;

import com.benandow.android.gui.userStudy.graphics.ScreenPlot;

public class Main {

	public static void main(String[] args) throws ParserConfigurationException, SAXException, IOException {
//		args = new String[]{"/Users/benandow/Documents/GUIAnalysisFramework/TEMP/results/SAMPLE_DATASET/"};
		if(args.length < 1){
			System.err.println("USAGE: java -jar annotator.jar <METADATA_DIRECTORY>");
			return;
		}
	
		File layout_file_dir = new File(args[0]);
		ScreenPlot.renderGui(layout_file_dir);
		
	}	
}