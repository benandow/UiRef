package com.benandow.android.gui.labelResolver;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

public class PrivacyTagger {

	private Set<String> mPrivateTerms;
	
	private PrivacyTagger(){
		this.mPrivateTerms = new HashSet<String>();
	};
	
	public static PrivacyTagger init(File name) throws IOException{
		PrivacyTagger tagger = new PrivacyTagger();
		BufferedReader reader = new BufferedReader(new FileReader(name));
		String term = null;
		while((term = reader.readLine()) != null){
			tagger.mPrivateTerms.add(term.toLowerCase());
		}
		reader.close();
		return tagger;
	}
	

	//FIXME
	public String getTag(String text){
		if(text == null){
			return null;
		}
		for(Iterator<String> iter = this.mPrivateTerms.iterator(); iter.hasNext(); ){
			String term = iter.next();
			if(text.toLowerCase().trim().contains(term.toLowerCase().trim())){
				return term.toLowerCase().trim();
			}
		}
		return null;
		//return this.mPrivateTerms.contains(text.toLowerCase());
	}
}