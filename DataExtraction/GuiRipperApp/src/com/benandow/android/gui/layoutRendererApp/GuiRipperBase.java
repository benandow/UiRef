package com.benandow.android.gui.layoutRendererApp;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;

import javax.xml.transform.TransformerException;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.webkit.WebView;
import android.widget.AbsSpinner;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CheckedTextView;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RatingBar;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.ToggleButton;


public class GuiRipperBase {

	private static int drawableIdCounter = 0;

	private Activity activity;
	private Integer[] layout_res_ids;
	private int current_layout_counter;
	private File output_dir;
	
	public GuiRipperBase(Activity activity){
		this.activity = activity;
		//Retrieve the layout IDs from assets
		this.layout_res_ids = getLayoutIds();
		//Get the output path
		this.output_dir = Environment.getExternalStorageDirectory();
		//Instantiate the counter
		this.current_layout_counter = getLayoutCounter();
	}

	public void renderLayout(){
		if(this.current_layout_counter >= layout_res_ids.length){
			Log.w("GuiRipper", "RenderingComplete(0):"+current_layout_counter+"/"+layout_res_ids.length);
			this.activity.finish();
			return;
		}
		updateLayoutCounter(this.current_layout_counter);
		final int layout_id = layout_res_ids[current_layout_counter++];
		Log.w("GuiRipper", "Rendering("+layout_id+"):"+current_layout_counter+"/"+layout_res_ids.length);
		try{

			final long startTime = System.currentTimeMillis();
			// Render the view
			this.activity.setContentView(layout_id);

			View cv = this.activity.findViewById(android.R.id.content);
			if(cv == null){
				renderLayout();
				return;
			}
			final ViewGroup viewGroup = (ViewGroup)((ViewGroup)cv).getChildAt(0);
				
			final String package_name = this.activity.getPackageName();
			//Set callback when finished rendering
		    ViewTreeObserver vto = viewGroup.getViewTreeObserver();
		    while(!vto.isAlive()){
		    	vto = viewGroup.getViewTreeObserver();
		    }
		    vto.addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
				@Override
		        public void onGlobalLayout() {
					ViewTreeObserver vto = viewGroup.getViewTreeObserver();
				    while(!vto.isAlive()){
				    	vto = viewGroup.getViewTreeObserver();
				    }
				    vto.removeOnGlobalLayoutListener(this);

					long endTime = System.currentTimeMillis();
				    //Dump screenshot
					dumpScreenshot(viewGroup, new File(output_dir, String.format("%s_%s.png", package_name, Integer.toHexString(layout_id))), layout_id);
//					dumpScreenshot(viewGroup, new File(output_dir, package_name+"_"+layout_id+".png"), layout_id);

					//Dump XML Layout
					GuiXmlDump layout_xml_dump = GuiXmlDump.createHierarchyXmlDump(activity.getPackageName());					
					layout_xml_dump.addLayout(layout_id, (endTime-startTime));
					layout_xml_dump.addViewGroup(viewGroup.getClass().getName(), new int[]{viewGroup.getLeft(), viewGroup.getTop(), viewGroup.getRight(),  viewGroup.getBottom()}, viewGroup.getId(), getVisibilityString(viewGroup.getVisibility()));
					traverseViewHierarchy(viewGroup, layout_xml_dump, String.format("%s_%s", package_name, Integer.toHexString(layout_id)));
					layout_xml_dump.endElement();
					layout_xml_dump.endElement();
					
					try {
						layout_xml_dump.writeToFile(new File(output_dir, String.format("%s_%s.xml", package_name, Integer.toHexString(layout_id))));
						//layout_xml_dump.writeToFile(new File(output_dir, package_name+"_layout_"+layout_id+".xml"));
					} catch (TransformerException e) {
						e.printStackTrace();
					}
					
					if(current_layout_counter < layout_res_ids.length){
						renderLayout();
					}else{
						Log.w("GuiRipper", "RenderingComplete(0):"+current_layout_counter+"/"+layout_res_ids.length);
					}
					
		        }
		    });
			
		}catch(Exception e){
			Log.w("GuiRipper", "RenderingException("+layout_id+"):"+current_layout_counter+"/"+layout_res_ids.length);
			renderLayout();
			return;
		}
	}
	
	private void updateLayoutCounter(int counter){
		File f = new File(this.output_dir, this.activity.getPackageName()+"_PROGRESS.txt");
		try {
			BufferedWriter writer = new BufferedWriter(new FileWriter(f));
			writer.write(String.valueOf(counter));
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private int getLayoutCounter(){
		File f = new File(this.output_dir, this.activity.getPackageName()+"_PROGRESS.txt");
		if(!f.exists() || !f.canRead()){
			return 0;
		}
		try {
			BufferedReader reader = new BufferedReader(new FileReader(f));
			String line = reader.readLine();
			reader.close();
			if(line == null){
				return 0;
			}
			//Log layout rendering failure
			int counter = Integer.valueOf(line);
			final int layout_id = layout_res_ids[counter];
			Log.w("GuiRipper", "RenderingFailure("+Integer.toHexString(layout_id)+"):"+counter+"/"+layout_res_ids.length);
			return counter + 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	private String getVisibilityString(int vis){
		if (vis == View.VISIBLE){
			return Constants.VISIBLE_ATTR;
		}else if (vis == View.INVISIBLE){
			return Constants.INVISIBLE_ATTR;
		}else if (vis == View.GONE){
			return Constants.GONE_ATTR;
		}
		return null;
	}
	
	//Convert drawable to bitmap from http://stackoverflow.com/a/10600736
	private static Bitmap drawableToBitmap(Drawable drawable){
		Bitmap bitmap = null;

		if (drawable instanceof BitmapDrawable){
			BitmapDrawable bitmapDrawable = (BitmapDrawable) drawable;
			if(bitmapDrawable.getBitmap() != null){
				return bitmapDrawable.getBitmap();
			}
		}

		if(drawable.getIntrinsicWidth() <= 0 || drawable.getIntrinsicHeight() <= 0){
			bitmap = Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888); // Single color bitmap will be created of 1x1 pixel
		}else{
			bitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
		}

		Canvas canvas = new Canvas(bitmap);
		drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
		drawable.draw(canvas);
		return bitmap;
	}
	
	//TODO add drawables as children of XML node instead of attr
	private void addDrawable(HashMap<String, String> params, Drawable d, String fileBaseName){
		if(d == null){
			return;
		}
		//Save drawable file
		String drawableFileName = String.format("%s_%s.png", fileBaseName, Integer.toString(GuiRipperBase.drawableIdCounter++));
	    try {
	    	Bitmap bitmap = GuiRipperBase.drawableToBitmap(d);
	    	FileOutputStream fos = new FileOutputStream(new File(this.output_dir, drawableFileName));
		    bitmap.compress(CompressFormat.PNG, 100, fos);
	        fos.flush();
	        fos.close();
	    } catch (Exception e) {
	    	//TODO log error message
	    }
		
		if(params.containsKey(Constants.DRAWABLE_VISIBILITY)){
			params.put(Constants.DRAWABLE_VISIBILITY, params.get(Constants.DRAWABLE_VISIBILITY)+Constants.DRAWABLE_SEPARATOR+Boolean.toString(d.isVisible()));

		}else{							
			params.put(Constants.DRAWABLE_VISIBILITY, Boolean.toString(d.isVisible()));
		}
	    
		if(params.containsKey(Constants.DRAWABLE_ID_ATTR)){
			params.put(Constants.DRAWABLE_ID_ATTR, params.get(Constants.DRAWABLE_ID_ATTR)+Constants.DRAWABLE_SEPARATOR+drawableFileName);

		}else{
			params.put(Constants.DRAWABLE_ID_ATTR, drawableFileName);
		}
		
		Rect r = d.getBounds();
		if(params.containsKey(Constants.DRAWABLE_TOP_ATTR)){
			params.put(Constants.DRAWABLE_TOP_ATTR, params.get(Constants.DRAWABLE_TOP_ATTR)+Constants.DRAWABLE_SEPARATOR+Integer.toString(r.top));
		}else{
			params.put(Constants.DRAWABLE_TOP_ATTR, Integer.toString(r.top));
		}
		
		if(params.containsKey(Constants.DRAWABLE_RIGHT_ATTR)){
			params.put(Constants.DRAWABLE_RIGHT_ATTR, params.get(Constants.DRAWABLE_RIGHT_ATTR)+Constants.DRAWABLE_SEPARATOR+Integer.toString(r.right));
		}else{
			params.put(Constants.DRAWABLE_RIGHT_ATTR, Integer.toString(r.right));
		}
		
		if(params.containsKey(Constants.DRAWABLE_BOTTOM_ATTR)){
			params.put(Constants.DRAWABLE_BOTTOM_ATTR, params.get(Constants.DRAWABLE_BOTTOM_ATTR)+Constants.DRAWABLE_SEPARATOR+Integer.toString(r.bottom));
		}else{
			params.put(Constants.DRAWABLE_BOTTOM_ATTR, Integer.toString(r.bottom));
		}
		
		if(params.containsKey(Constants.DRAWABLE_LEFT_ATTR)){
			params.put(Constants.DRAWABLE_LEFT_ATTR, params.get(Constants.DRAWABLE_LEFT_ATTR)+Constants.DRAWABLE_SEPARATOR+Integer.toString(r.left));
		}else{
			params.put(Constants.DRAWABLE_LEFT_ATTR, Integer.toString(r.left));
		}
		
	}

	//TODO Clean up redundant code in IF statements.
	private void traverseViewHierarchy(ViewGroup vgroup, GuiXmlDump layout_xml_dump, String fileBaseName){
		try{
			for(int i = 0; i < vgroup.getChildCount(); i++){
				final View v = vgroup.getChildAt(i);
				//Create parameter HashMap
				HashMap<String, String> params = new HashMap<String, String>();
				params.put(Constants.LEFT_ATTR, Integer.toString(v.getLeft()));
				params.put(Constants.TOP_ATTR, Integer.toString(v.getTop()));
				params.put(Constants.RIGHT_ATTR, Integer.toString(v.getRight()));
				params.put(Constants.BOTTOM_ATTR, Integer.toString(v.getBottom()));
				
				if(v instanceof TextView){
					TextView tv = (TextView)v;
					Drawable[] drawables = tv.getCompoundDrawables();
					for(Drawable d : drawables){
						this.addDrawable(params, d, fileBaseName);
					}
				}
				
				if(v instanceof RatingBar){
					RatingBar rb = (RatingBar)v;
					params.put(Constants.NAME_ATTR, rb.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(rb.getId()));
					params.put(Constants.SUPER_ATTR, Constants.RATING_BAR_CLASS);
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(rb.getVisibility()));
				}else if(v instanceof CheckedTextView){
					CheckedTextView ctv = (CheckedTextView)v;
					params.put(Constants.TEXT_SIZE_ATTR, Float.toString(ctv.getTextSize()));
					params.put(Constants.TEXT_COLOR_ATTR, Integer.toString(ctv.getTextColors().getDefaultColor()));
					params.put(Constants.NAME_ATTR, ctv.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(ctv.getId()));
					params.put(Constants.SUPER_ATTR, Constants.CHECKED_TEXT_VIEW_CLASS);
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(ctv.getVisibility()));
					params.put(Constants.INPUT_TYPE, InputTypeDecoder.decodeInputType(ctv.getInputType()));
					params.put(Constants.TEXT_ATTR, (ctv.getText() == null) ? null : ctv.getText().toString());
					params.put(Constants.HINT_ATTR, (ctv.getHint() == null) ? null : ctv.getHint().toString());					
					layout_xml_dump.addViewElement(params);
				}else if(v instanceof AbsSpinner){
					AbsSpinner abs = (AbsSpinner)v;
					params.put(Constants.NAME_ATTR, abs.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(abs.getId()));
					params.put(Constants.SUPER_ATTR, Constants.ABS_SPINNER_CLASS);
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(abs.getVisibility()));
					layout_xml_dump.addViewElement(params);
				}else if(v instanceof RadioButton){
					RadioButton rb = (RadioButton)v;
					params.put(Constants.TEXT_SIZE_ATTR, Float.toString(rb.getTextSize()));
					params.put(Constants.TEXT_COLOR_ATTR, Integer.toString(rb.getTextColors().getDefaultColor()));
					params.put(Constants.NAME_ATTR, rb.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(rb.getId()));
					params.put(Constants.SUPER_ATTR, Constants.RADIO_BUTTON_CLASS);
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(rb.getVisibility()));
					params.put(Constants.INPUT_TYPE, InputTypeDecoder.decodeInputType(rb.getInputType()));
					params.put(Constants.TEXT_ATTR, (rb.getText() == null) ? null : rb.getText().toString());
					params.put(Constants.HINT_ATTR, (rb.getHint() == null) ? null : rb.getHint().toString());
					layout_xml_dump.addViewElement(params);
				}else if(v instanceof CheckBox){
					CheckBox cb = (CheckBox)v;
					params.put(Constants.TEXT_SIZE_ATTR, Float.toString(cb.getTextSize()));
					params.put(Constants.TEXT_COLOR_ATTR, Integer.toString(cb.getTextColors().getDefaultColor()));
					params.put(Constants.NAME_ATTR, cb.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(cb.getId()));
					params.put(Constants.SUPER_ATTR, Constants.CHECKBOX_CLASS);
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(cb.getVisibility()));
					params.put(Constants.INPUT_TYPE, InputTypeDecoder.decodeInputType(cb.getInputType()));
					params.put(Constants.TEXT_ATTR, (cb.getText() == null) ? null : cb.getText().toString());
					params.put(Constants.HINT_ATTR, (cb.getHint() == null) ? null : cb.getHint().toString());
					layout_xml_dump.addViewElement(params);
				}else if(v instanceof ToggleButton){
					ToggleButton tb = (ToggleButton)v;
					params.put(Constants.TEXT_SIZE_ATTR, Float.toString(tb.getTextSize()));
					params.put(Constants.TEXT_COLOR_ATTR, Integer.toString(tb.getTextColors().getDefaultColor()));
					params.put(Constants.NAME_ATTR, tb.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(tb.getId()));
					params.put(Constants.SUPER_ATTR, Constants.TOGGLE_BUTTON_CLASS);
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(tb.getVisibility()));
					params.put(Constants.INPUT_TYPE, InputTypeDecoder.decodeInputType(tb.getInputType()));
					params.put(Constants.TEXT_ATTR, (tb.getText() == null) ? null : tb.getText().toString());
					params.put(Constants.HINT_ATTR, (tb.getHint() == null) ? null : tb.getHint().toString());
					params.put(Constants.TEXT_ON_ATTR, (tb.getTextOn() == null) ? null : tb.getTextOn().toString());
					params.put(Constants.TEXT_OFF_ATTR, (tb.getTextOff() == null) ? null : tb.getTextOff().toString());
					layout_xml_dump.addViewElement(params);
				}else if(v instanceof Switch){
					Switch sw = (Switch)v;
					params.put(Constants.TEXT_SIZE_ATTR, Float.toString(sw.getTextSize()));
					params.put(Constants.TEXT_COLOR_ATTR, Integer.toString(sw.getTextColors().getDefaultColor()));
					params.put(Constants.NAME_ATTR, sw.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(sw.getId()));
					params.put(Constants.SUPER_ATTR, Constants.SWITCH_CLASS);
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(sw.getVisibility()));
					params.put(Constants.INPUT_TYPE, InputTypeDecoder.decodeInputType(sw.getInputType()));
					params.put(Constants.TEXT_ATTR, (sw.getText() == null) ? null : sw.getText().toString());
					params.put(Constants.HINT_ATTR, (sw.getHint() == null) ? null : sw.getHint().toString());
					params.put(Constants.TEXT_ON_ATTR, (sw.getTextOn() == null) ? null : sw.getTextOn().toString());
					params.put(Constants.TEXT_OFF_ATTR, (sw.getTextOff() == null) ? null : sw.getTextOff().toString());
					layout_xml_dump.addViewElement(params);
//				}else if(v instanceof SwitchCompat){
//					FIXME catch java.lang.NoClassDefFoundError
//					SwitchCompat swc = (SwitchCompat)v;
//					params.put(Constants.TEXT_SIZE_ATTR, Float.toString(swc.getTextSize()));
//					params.put(Constants.TEXT_COLOR_ATTR, Integer.toString(swc.getTextColors().getDefaultColor()));
//					params.put(Constants.NAME_ATTR, swc.getClass().toString());
//					params.put(Constants.ID_ATTR, Integer.toString(swc.getId()));
//					params.put(Constants.SUPER_ATTR, Constants.SWITCH_COMPAT_CLASS);
//					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(swc.getVisibility()));
//					params.put(Constants.INPUT_TYPE, InputTypeDecoder.decodeInputType(swc.getInputType()));
//					params.put(Constants.TEXT_ATTR, (swc.getText() == null) ? null : swc.getText().toString());
//					params.put(Constants.HINT_ATTR, (swc.getHint() == null) ? null : swc.getHint().toString());
//					params.put(Constants.TEXT_ON_ATTR, (swc.getTextOn() == null) ? null : swc.getTextOn().toString());
//					params.put(Constants.TEXT_OFF_ATTR, (swc.getTextOff() == null) ? null : swc.getTextOff().toString());
//					layout_xml_dump.addViewElement(params);
				}else if(v instanceof ImageButton){
					ImageButton ib = (ImageButton)v;
					params.put(Constants.NAME_ATTR, ib.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(ib.getId()));
					params.put(Constants.SUPER_ATTR, Constants.IMAGE_BUTTON_CLASS);
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(ib.getVisibility()));
					this.addDrawable(params, ib.getDrawable(), fileBaseName);
					layout_xml_dump.addViewElement(params);
				}else if(v instanceof ImageView){
					ImageView iv = (ImageView)v;
					params.put(Constants.NAME_ATTR, iv.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(iv.getId()));
					params.put(Constants.SUPER_ATTR, Constants.IMAGE_VIEW_CLASS);
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(iv.getVisibility()));
					this.addDrawable(params, iv.getDrawable(), fileBaseName);
					layout_xml_dump.addViewElement(params);
				}else if(v instanceof WebView){
					WebView wv = (WebView)v;
					params.put(Constants.NAME_ATTR, wv.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(wv.getId()));
					params.put(Constants.SUPER_ATTR, Constants.WEBVIEW_CLASS);
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(wv.getVisibility()));
					params.put(Constants.URL_TEXT, wv.getUrl());
					params.put(Constants.ORIGINAL_URL_TEXT, wv.getOriginalUrl());
					layout_xml_dump.addViewElement(params);
				}else if(v instanceof EditText){
					EditText et = (EditText)v;
					params.put(Constants.NAME_ATTR, et.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(et.getId()));
					params.put(Constants.SUPER_ATTR, Constants.EDIT_TEXT_CLASS);
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(et.getVisibility()));
					params.put(Constants.INPUT_TYPE, InputTypeDecoder.decodeInputType(et.getInputType()));
					params.put(Constants.TEXT_ATTR, (et.getText() == null) ? null : et.getText().toString());
					params.put(Constants.HINT_ATTR, (et.getHint() == null) ? null : et.getHint().toString());
					layout_xml_dump.addViewElement(params);
				}else if(v instanceof Button){
					Button btn = (Button)v;
					params.put(Constants.TEXT_SIZE_ATTR, Float.toString(btn.getTextSize()));
					params.put(Constants.TEXT_COLOR_ATTR, Integer.toString(btn.getTextColors().getDefaultColor()));
					params.put(Constants.NAME_ATTR, btn.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(btn.getId()));
					params.put(Constants.SUPER_ATTR, Constants.BUTTON_CLASS);
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(btn.getVisibility()));
					params.put(Constants.INPUT_TYPE, InputTypeDecoder.decodeInputType(btn.getInputType()));
					params.put(Constants.TEXT_ATTR, (btn.getText() == null) ? null : btn.getText().toString());
					params.put(Constants.HINT_ATTR, (btn.getHint() == null) ? null : btn.getHint().toString());
					layout_xml_dump.addViewElement(params);
				}else if(v instanceof TextView){
					TextView tv = (TextView)v;
					params.put(Constants.TEXT_SIZE_ATTR, Float.toString(tv.getTextSize()));
					params.put(Constants.TEXT_COLOR_ATTR, Integer.toString(tv.getTextColors().getDefaultColor()));
					params.put(Constants.NAME_ATTR, tv.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(tv.getId()));
					params.put(Constants.SUPER_ATTR, Constants.TEXT_VIEW_CLASS);
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(tv.getVisibility()));
					params.put(Constants.INPUT_TYPE, InputTypeDecoder.decodeInputType(tv.getInputType()));
					params.put(Constants.TEXT_ATTR, (tv.getText() == null) ? null : tv.getText().toString());
					params.put(Constants.HINT_ATTR, (tv.getHint() == null) ? null : tv.getHint().toString());
					layout_xml_dump.addViewElement(params);
				}else if(v instanceof ViewGroup){
					params.put(Constants.NAME_ATTR, v.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(v.getId()));
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(v.getVisibility()));
					layout_xml_dump.addViewGroup(params);
					traverseViewHierarchy((ViewGroup)v, layout_xml_dump, fileBaseName);
					layout_xml_dump.endElement();
				}else{
					params.put(Constants.NAME_ATTR, v.getClass().toString());
					params.put(Constants.ID_ATTR, Integer.toString(v.getId()));
					params.put(Constants.VISIBILITY_ATTR, getVisibilityString(v.getVisibility()));
					layout_xml_dump.addViewElement(params);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	private void dumpScreenshot(View v, File file, int layout_id){
	    try {
	    	v.setDrawingCacheEnabled(true);
	    	Bitmap bitmap = Bitmap.createBitmap(v.getDrawingCache());
	    	v.setDrawingCacheEnabled(false);
	    	FileOutputStream fos = new FileOutputStream(file);
		    bitmap.compress(CompressFormat.PNG, 100, fos);
	        fos.flush();
	        fos.close();
	    } catch (Exception e) {
			Log.w("GuiRipper", "ScreendumpException("+Integer.toHexString(layout_id)+"):"+current_layout_counter+"/"+layout_res_ids.length);
	    }
	}

	private Integer[] getLayoutIds() {
		ArrayList<Integer> res = new ArrayList<Integer>();
		try {
			InputStream istream = this.activity.getResources().getAssets().open("com_benandow_ncsu_gui_layouts.txt");
			BufferedReader reader = new BufferedReader(new InputStreamReader(istream));
			String line = null;
			while((line = reader.readLine()) != null){
				try{
					if(line.startsWith("0x")){
						line = line.substring(2);
					}
					res.add(Integer.valueOf(line,16));
				}catch(NumberFormatException e){
					//Ignore
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return res.toArray(new Integer[res.size()]);
	}
	
	
}