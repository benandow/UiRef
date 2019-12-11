package com.benandow.android.gui.userStudy.graphics;

import java.awt.Insets;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.imageio.ImageIO;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JSplitPane;
import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.SAXException;

import com.benandow.android.gui.layoutModel.Constants;
import com.benandow.android.gui.layoutModel.HierarchyNode;
import com.benandow.android.gui.layoutModel.HierarchyTree;
import com.benandow.android.gui.layoutModel.LayoutParser;

public class ScreenPlot {

	//FIXME check into scaling issue when opening window
	
	private List<File> mFileList;
	private File mCurrentFile;
	private File mRootDir;
	
	// User interface variables
	private JFrame mWindow;
	private BufferedImage mScreenshot;
	private ScreenCanvas mCanvas;
	private HierarchyCanvas hCanvas;
	private JSplitPane mSplitPane;
	private int mWidth;//= 768 1080/Constants.SCALE;
	private int mHeight;// = 1280 1701/Constants.SCALE;
	
//	private Dimension mScreenDimensions;
	public boolean begin;
	
	//Backend variables
	private HierarchyTree mTree;
	public List<AnnotatedField> mAnnotatedFields;
	
	public static ScreenPlot renderGui(File dir) throws ParserConfigurationException, SAXException, IOException{
		return new ScreenPlot(dir);
	}
	
	public File getInputFile(){
		return this.mCurrentFile;
	}
	
	public File getOutputFile(){
		return this.mCurrentFile;
	}

	public ScreenPlot(File dir) throws ParserConfigurationException, SAXException, IOException{
		this.mFileList = new ArrayList<File>();
		this.mRootDir = dir;
		traverseFiles(this.mRootDir);
		nextLayout();
		
	}
	
	//TODO probably a better way to do this
	private String[] getPackageAndId(String layout_name){		
		String l = layout_name.replace(".xml", "");
		String[] arr = new String[2];
		int i = l.length() -1;
		while(i >= 0 && l.charAt(i) != '_'){
			i--;
		}
		arr[0] = l.substring(0, i);
		arr[1] = l.substring(i+1, l.length());
		return arr;
	}
	
	protected void nextLayout() throws ParserConfigurationException, SAXException, IOException{
		this.begin = false;
		if(this.mFileList.isEmpty()){
			JOptionPane.showMessageDialog(null, "Rendering completed -- exiting");
			System.exit(0);
		}
		if(this.hCanvas != null){
			this.hCanvas.removeAll();
		}
		if(this.mCanvas != null){
			this.mCanvas.removeAll();
		}
		if(this.mSplitPane != null){
			this.mSplitPane.removeAll();
		}

		File screenshotFile = null;
		while(screenshotFile == null || !screenshotFile.exists()){
			if(this.mFileList.isEmpty()){
				JOptionPane.showMessageDialog(null, "Rendering completed -- exiting");
				System.exit(0);
			}
			this.mCurrentFile = this.mFileList.remove(0);

			String[] strArr = getPackageAndId(this.mCurrentFile.getName());
			System.out.println(strArr[0]+" "+strArr[1]);
			File screenshotDir = new File(this.mRootDir, "screenshots");
		//		File screenshotDir = new File(this.mCurrentFile.getParentFile().getParentFile(), "screenshots");
			screenshotFile = new File(screenshotDir, strArr[0]+"_"+strArr[1]+".png");
			System.out.println("HIT " + screenshotFile.getAbsolutePath());
		}
		
		this.mScreenshot = ImageIO.read(screenshotFile);
		
		this.mTree = LayoutParser.getHierarchy(this.mCurrentFile);
		if(this.mTree == null || this.mTree.getTreeRoot() == null){
			System.err.println("Error resolving values\n");
			System.exit(0);
		}
				
//	    this.mScreenDimensions = Toolkit.getDefaultToolkit().getScreenSize();	    
//	    System.out.println(this.mScreenDimensions.getWidth() + " "+this.mScreenDimensions.getHeight());
	    
		this.mAnnotatedFields = new ArrayList<AnnotatedField>();
		//Highlight all TextViews + EditTexts
		initAnnotatedFields(this.mTree.getTreeRoot());
		
		initGUI();
		
		this.draw();
	}

	
	public void traverseFiles(File dir) {
		File[] files = dir.listFiles(new FilenameFilter() {
			@Override
			public boolean accept(File dir, String name) {
				return name.toLowerCase().endsWith(".xml") || new File(dir, name).isDirectory();
			}
		});
		
		for(File f : files){
			if(f.isFile()){
				try{
					this.mFileList.add(f);
				}catch(Exception e){ }
			}else if(f.isDirectory()){
				traverseFiles(f);
			}
		}
	}
	

	public static int scale(int val){
		return val / 3;
	}
	
	public void initGUI(){
		this.mWidth = ScreenPlot.scale(this.mTree.getWidth());
		this.mHeight = ScreenPlot.scale(this.mTree.getHeight());
		if(this.mWindow == null){
			this.mWindow = new JFrame();
		}else{
			this.mWindow.dispose();
		}
    	this.mWindow.pack();
    	this.mWindow.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

	    Insets ins = this.mWindow.getInsets();
	    this.mWindow.getContentPane().setSize(mWidth*2, mHeight);
	    this.mWindow.setSize(mWidth*2+ins.left+ins.right, mHeight+ins.top+ins.bottom);

	    this.hCanvas = new HierarchyCanvas(mWidth, mHeight, this);
	    
		this.mCanvas = new ScreenCanvas(mScreenshot, mWidth, mHeight, this);

		this.mSplitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, this.mCanvas, this.hCanvas);
		this.mSplitPane.setDividerLocation(mWidth+ins.left+ins.right);
		this.mSplitPane.setSize(mWidth*2, mHeight);
		this.mSplitPane.setEnabled(false);
		
	    this.mWindow.getContentPane().add(this.mSplitPane);
	    this.mWindow.setVisible(true);

	}
	
	public void reset(){
		for(AnnotatedField field : this.mAnnotatedFields){
			field.setDefaultHighlight();
		}
		this.draw();
	}
	
	public void selectField(AnnotatedField field){
		if(field != null){
			this.hCanvas.selectField(field);
			this.draw();
		}
	}
	
	public boolean inBounds(HierarchyNode node){
		return (node.getBottom() <= this.mTree.getHeight() && node.getRight() <= this.mTree.getWidth());
	}
	
	private static boolean isVisible(HierarchyNode base){
		if(base.getParent() == null && base.isVisible()){
			return true;
		}
		if(!base.isVisible()){
			return false;
		}
		return isVisible(base.getParent());
	}
	
	private void initAnnotatedFields(HierarchyNode node){
        if(node.isViewGroup()){
        	for(HierarchyNode cnode : node.getChildren()){
        		initAnnotatedFields(cnode);
        	}
       	}else if(node.isView() && inBounds(node) && (node.isTextField() ||
       			node.getSuperClass().equals(Constants.EDIT_TEXT_CLASS)		||
       			node.getSuperClass().equals(Constants.ABS_SPINNER_CLASS) 	||
       			node.getSuperClass().equals(Constants.CHECKBOX_CLASS) 		||
       			node.getSuperClass().equals(Constants.RADIO_BUTTON_CLASS) 	||
       			node.getSuperClass().equals(Constants.SWITCH_CLASS) 		||
				node.getSuperClass().equals(Constants.SWITCH_COMPAT_CLASS) 	||
				node.getSuperClass().equals(Constants.TOGGLE_BUTTON_CLASS) 	||
				node.getSuperClass().equals(Constants.RATING_BAR_CLASS)) && isVisible(node)){
       			this.mAnnotatedFields.add(new AnnotatedField(node));
        }
	}
	
	public void draw(){
		this.mWindow.repaint();
	}
	
	public HashMap<String, HierarchyNode> getAnnotatedFields(){
		HashMap<String, HierarchyNode> map = new HashMap<String, HierarchyNode>();
		for(AnnotatedField f : this.mAnnotatedFields){
			HierarchyNode label = f.getNode();
			Iterator<AnnotatedField> it = f.getAssociatedFields().iterator();
			while(it.hasNext()){
				HierarchyNode uifield = it.next().getNode();
				uifield.setAnnotatedLabelCounter(label.getCounterId());
				map.put(uifield.getCounterId(), uifield);
			}
		}
		return map;
	}
}