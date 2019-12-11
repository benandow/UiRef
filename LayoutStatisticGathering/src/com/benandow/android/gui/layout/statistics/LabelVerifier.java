package com.benandow.android.gui.layout.statistics;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPathExpressionException;

import org.xml.sax.SAXException;

import com.benandow.android.gui.layoutModel.HierarchyNode;
import com.benandow.android.gui.layoutModel.HierarchyTree;
import com.benandow.android.gui.layoutModel.LayoutParser;

public class LabelVerifier {

	static List<String> xmlFiles;
	static int suporCorrect = 0, suporIncorrect=0;
	static int disagreementCorrect = 0, disagreementIncorrect=0;
	static int guiRipperCorrect=0, guiRipperIncorrect=0;
	static int disagreeGuiRipperCorrect = 0, disagreeSuporCorrect = 0, bothAgreeIncorrect =0;
	static int totalCount=0;
	static int correctSemCount = 0;
	static int totalSemCount = 0;
	
	public static void main(String[] args) throws IOException, ParserConfigurationException, SAXException, XPathExpressionException {
		xmlFiles = new ArrayList<String>();
		getXmlFiles(new File("/Volumes/garfield/Desktop/GUI_EVAL/ANNOTATED_EVAL_SAMPLE/LAYOUT_FILES.txt"));
		
		for(String s : xmlFiles){
			HierarchyTree mTree = LayoutParser.getHierarchy(new File("/Volumes/garfield/Desktop/GUI_EVAL/ANNOTATED_EVAL_SAMPLE/layouts2/"+s));
			if(mTree == null || mTree.getTreeRoot() == null){
				System.err.println("Error resolving values\n ");
				System.exit(0);
			}
			
			
			checkLabels(mTree.getTreeRoot(), s);
		}
		System.out.printf("SUPOR: %d/%d = %f\n",suporCorrect, (suporCorrect+suporIncorrect),((double)suporCorrect/(double)(suporCorrect+suporIncorrect)));
		System.out.printf("GuiRipper: %d/%d = %f\n",guiRipperCorrect, (guiRipperCorrect+guiRipperIncorrect),((double)guiRipperCorrect/(double)(guiRipperCorrect+guiRipperIncorrect)));
		System.out.printf("%d %d %d\n", disagreeGuiRipperCorrect, disagreeSuporCorrect, bothAgreeIncorrect);
		System.out.println(correctSemCount+"/"+totalSemCount);
	}
	
	private static boolean isVisible(HierarchyNode base){
//		return base.isVisible();
		if(base.getParent() == null && base.isVisible()){
			return true;
		}
		if(!base.isVisible()){
			return false;
		}
		return isVisible(base.getParent());
	}
	

	private static String normalizeLabel(String val){
		if(val == null){
			return null;
		}
		
		switch(val.trim()){
		case "twitter_url" : return "username_or_email_address";
		case "facebook_url" : return "username_or_email_address";
		case "first_name" : return "full_name";
		case "last_name" : return "full_name";
		case "email_address" : return "username_or_email_address";
		case "username" : return "username_or_email_address";
		case "phone_number|email_address" : return "phone_number|username_or_email_address";
		case "loan_amount" : return "loan_info";
		case "loan_term" : return "loan_info";
		case "interest_rate" : return "loan_info";
		case "card_number" : return "credit_card_info";
		case "card_code" : return "credit_card_info";
		case "zip_code" : return "location_info";
		case "height" : return "person_height";
		case "weight" : return "person_weight";
		case "postal_location" : return "location_info";
		case "postal_address" : return "location_info";
		case "credit_card_expiration_month" : return "credit_card_expiration_date";
		case "bank_account_number" : return "bank_account_info";
		case "city|zip_code" : return "location_info";
		case "city|state" : return "location_info";
		case "state" : return "location_info";
		case "city" : return "location_info";
		case "country" : return "location_info";
		case "credit_card_expiration_year" : return "credit_card_expiration_date";
		case "vehicle_mileage" : return "vehicle_info";
		case "house_price" : return "house_financial_info";
		case "loan_interest_rate" : return "loan_info";
		case "birth_date" : return "date_of_birth";
		case "bank_name"	: return "bank_info";
		case "recipient_last_name" : return "full_name";
		case "routing_number" : return "bank_account_info";
		case "other_person_name" : return "null";
		case "email_address|phone_number" : return "phone_number|username_or_email_address";
		case "personal_name" : return "full_name";
		case "credit_card_expiration_date" : return "credit_card_info";
		case "credit_card_number" : return "credit_card_info";
		case "credit_card_code" : return "credit_card_info";
		case "mortgage_term" : return "loan_info";
		case "area_code" : return null;
		case "password_hint" : return null;
		case "app_authorization_code" : return null;
		case "license_plate_number" : return "license_plate";
		case "pin_number" : return null;
//		case "dentist_name" : return "other_person_name";
		case "pdanet_serial_number" :  return null;
		case "app_verification_code": return null;
		case "downpayment_amount" : return null;
		case "person_name" : return "full_name";
		case "medical_treatment" : return null;
		case "location" : return "location_info";
		case "friend_name" : return null;
		case "security_question_answer" : return null;
		}
//annotatedPrivacyTag="postal_location"		
		
		return val;
	}
	//287
	
	private static int ccounter = 0;
	private static int cccounter = 0;
	private static void checkLabels(HierarchyNode base, String pname) {
		if(base != null && base.isEditText() && isVisible(base)){
			int suporLabelId = (base.getAssociatedSUPORLabelCounter() == null) ? -1 : Integer.parseInt(base.getAssociatedSUPORLabelCounter());
			int annotatedLabelId = (base.getAnnotatedLabelCounter() == null) ? -1 : Integer.parseInt(base.getAnnotatedLabelCounter());
			int assocLabelId = (base.getAssociatedLabelCounter() == null) ? -1 : Integer.parseInt(base.getAssociatedLabelCounter());
//692/750 ==> 91.6 92.5
//707/750 ==> 92.8 93.8
//			String bptag = base.getPrivacyTag();
			String bptag = base.getSuporPrivacyTag();
			
			String antag = normalizeLabel(base.getAnnotatedPrivacyTag());
			if(antag == bptag || (antag != null && antag.equals(bptag))){
				correctSemCount++;
				totalSemCount++;
			}else{
				totalSemCount++;
			}
			if(((antag != null && bptag == null) || (antag == null && bptag != null)) ||
				(antag != null && bptag != null && antag != bptag && !antag.equals(bptag))
					){
				cccounter += 1;				
				System.out.println(cccounter+"\t\t"+pname+":\t\t"+antag +"\t\t"+bptag);			
				
			}

			
			
//			if((antag != bptag && bptag == null) || (antag != null && !antag.equals(bptag))){
//				cccounter += 1;
//				System.out.println(cccounter+" "+pname+": "+antag +"\t"+bptag);
//			}

			
			if(annotatedLabelId != assocLabelId){
				ccounter += 1;
		//		System.out.println(pname + " " + base.getCounterId());
		//		System.out.printf("%d. %s: INPUTFIELD(%s) --> SUPORLABEL(%s), ANNOTATED(%s), OURS(%s)\n", ccounter, pname, base.getCounterId(), base.getAssociatedSUPORLabelCounter(), base.getAnnotatedLabelCounter(), base.getAssociatedLabelCounter());
			}
			
			if(suporLabelId == annotatedLabelId){
				LabelVerifier.suporCorrect++;
			}else{
				LabelVerifier.suporIncorrect++;
			}
			
			if(assocLabelId == annotatedLabelId){
				LabelVerifier.guiRipperCorrect++;
			}else{
				LabelVerifier.guiRipperIncorrect++;
			}
			
			if(suporLabelId != assocLabelId){
				if(assocLabelId == annotatedLabelId){
					LabelVerifier.disagreeGuiRipperCorrect++;
				}else if(suporLabelId == annotatedLabelId){
//					System.out.printf("3. %s: INPUTFIELD(%s) --> SUPORLABEL(%s), ANNOTATED(%s), OURS(%s)\n", pname, base.getCounterId(), base.getAssociatedSUPORLabelCounter(), base.getAnnotatedLabelCounter(), base.getAssociatedLabelCounter());
					LabelVerifier.disagreeSuporCorrect++;
				}else{
					LabelVerifier.bothAgreeIncorrect++;
				}
			}else if(assocLabelId != annotatedLabelId){
				LabelVerifier.bothAgreeIncorrect++;
			}
			
			LabelVerifier.totalCount++;


//			if(base.getAssociatedSUPORLabelCounter() != null && !base.getAssociatedSUPORLabelCounter().equals(base.getAssociatedLabelCounter())){
//				System.out.printf("1. %s: INPUTFIELD(%s) --> SUPORLABEL(%s), ANNOTATED(%s), OURS(%s)\n", pname, base.getCounterId(), base.getAssociatedSUPORLabelCounter(), base.getAnnotatedLabelCounter(), base.getAssociatedLabelCounter());
//
//			}else if(base.getAssociatedSUPORLabelCounter() != null && !base.getAssociatedSUPORLabelCounter().equals(base.getAnnotatedLabelCounter())){
//				System.out.printf("2. %s: INPUTFIELD(%s) --> SUPORLABEL(%s), ANNOTATED(%s), OURS(%s)\n", pname, base.getCounterId(), base.getAssociatedSUPORLabelCounter(), base.getAnnotatedLabelCounter(), base.getAssociatedLabelCounter());
//
//			}else
				
//			if(assocLabelId != annotatedLabelId){
//				System.out.printf("3. %s: INPUTFIELD(%s) --> SUPORLABEL(%s), ANNOTATED(%s), OURS(%s)\n", pname, base.getCounterId(), base.getAssociatedSUPORLabelCounter(), base.getAnnotatedLabelCounter(), base.getAssociatedLabelCounter());
//			}
			
			
		}
		

		
		for(HierarchyNode node : base.getChildren()){
			checkLabels(node, pname);
		}
	}

	
	private static void getXmlFiles(File name) throws IOException{
		BufferedReader reader = new BufferedReader(new FileReader(name));
		String term = null;
		while((term = reader.readLine()) != null){
			xmlFiles.add(term.toLowerCase());
		}
		reader.close();
	}
	
}
