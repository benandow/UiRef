package com.benandow.android.gui.layoutRendererApp;

import android.text.InputType;

public class InputTypeDecoder {
//FIXME
	public static String decodeInputType(int itype){
		int iclass = itype & InputType.TYPE_MASK_CLASS;
		if(iclass == InputType.TYPE_CLASS_NUMBER){
			return "NUMBER|"+decodeNumberClass(itype);
		}else if(iclass == InputType.TYPE_CLASS_PHONE){
			return "PHONE";
		}else if(iclass == InputType.TYPE_CLASS_DATETIME){
			return "DATETIME|"+decodeDateTimeClass(itype);
		}
		//if(iclass == InputType.TYPE_CLASS_TEXT){
		return "TEXT|"+decodeTextClass(itype);
	}
	
	private static String decodeNumberFlag(int itype){
		int fval = itype & InputType.TYPE_MASK_FLAGS;
		switch(fval){
		case InputType.TYPE_NUMBER_FLAG_DECIMAL:
			return "DECIMAL";
		case InputType.TYPE_NUMBER_FLAG_SIGNED:
			return "SIGNED";
		}
		return "UNKNOWN";
	}
	
	private static String decodeNumberClass(int itype){
		int ivar = itype & InputType.TYPE_MASK_VARIATION;
		String flag = decodeNumberFlag(itype);
		if(ivar == InputType.TYPE_NUMBER_VARIATION_PASSWORD){
			return "PASSWORD|"+flag;
		}else if(ivar == InputType.TYPE_NUMBER_VARIATION_NORMAL){
			return "NORMAL|"+flag;			
		}
		return "UNKNOWN|"+flag;	
	}
	
	private static String decodeDateTimeClass(int itype){
		int ivar = itype & InputType.TYPE_MASK_VARIATION;
		switch(ivar){
		case InputType.TYPE_DATETIME_VARIATION_DATE:
			return "DATE";
		case InputType.TYPE_DATETIME_VARIATION_NORMAL:
			return "NORMAL";
		case InputType.TYPE_DATETIME_VARIATION_TIME:
			return "TIME";
		}
		return "UNKNOWN";
	}
	
	private static String decodeTextClass(int itype){
		int ivar = itype & InputType.TYPE_MASK_VARIATION;
		switch(ivar){
		case InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS:
			return "EMAIL_ADDRESS";
		case InputType.TYPE_TEXT_VARIATION_EMAIL_SUBJECT:
			return "EMAIL_SUBJECT";
		case InputType.TYPE_TEXT_VARIATION_FILTER:
			return "FILTER";
		case InputType.TYPE_TEXT_VARIATION_LONG_MESSAGE:
			return "LONG_MESSAGE";
		case InputType.TYPE_TEXT_VARIATION_NORMAL:
			return "NORMAL";
		case InputType.TYPE_TEXT_VARIATION_PASSWORD:
			return "PASSWORD";
		case InputType.TYPE_TEXT_VARIATION_PERSON_NAME:
			return "PERSON_NAME";
		case InputType.TYPE_TEXT_VARIATION_PHONETIC:
			return "PHONETIC";
		case InputType.TYPE_TEXT_VARIATION_POSTAL_ADDRESS:
			return "POSTAL_ADDRESS";
		case InputType.TYPE_TEXT_VARIATION_SHORT_MESSAGE:
			return "SHORT_MESSAGE";
		case InputType.TYPE_TEXT_VARIATION_URI:
			return "URI";
		case InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD:
			return "VISIBLE_PASSWORD";
		case InputType.TYPE_TEXT_VARIATION_WEB_EDIT_TEXT:
			return "WEB_EDIT_TEXT";
		case InputType.TYPE_TEXT_VARIATION_WEB_EMAIL_ADDRESS:
			return "WEB_EMAIL_ADDRESS";
		case InputType.TYPE_TEXT_VARIATION_WEB_PASSWORD:
			return "WEB_PASSWORD";
		}
		return "UNKNOWN";
	}
}
