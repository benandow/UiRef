package com.benandow.android.gui.labelResolver;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.benandow.android.gui.layoutModel.Constants;
import com.benandow.android.gui.layoutModel.Coordinate;
import com.benandow.android.gui.layoutModel.HierarchyNode;
import com.benandow.android.gui.layoutModel.HierarchyTree;

public class SuporPlot {

	private HierarchyTree mTree;
	private List<HierarchyNode> mTextViews;
	private List<HierarchyNode> mEditTextViews;
	
	public SuporPlot(HierarchyTree tree){
		this.mTree = tree;
		this.mTextViews = new ArrayList<HierarchyNode>();
		this.mEditTextViews = new ArrayList<HierarchyNode>();
		buildLists(this.mTree.getTreeRoot());
	}
	
	public void resolveDescriptors(){
		for(HierarchyNode uinputfield : this.mEditTextViews){
			double[] scores = new double[this.mTextViews.size()];
			int counter = 0;
			for(HierarchyNode label : this.mTextViews){
				scores[counter++] = computeScore(uinputfield, label);				
			}
			int index = getMinIndex(scores);
			if(!this.mTextViews.isEmpty()){
				uinputfield.setAssociatedSUPORLabel(this.mTextViews.get(index));
			}
			
//			String tag = this.ptagger.getTag(uinputfield.getHint());
//			if(tag != null){
//				uinputfield.setSuporPrivacyTag(tag);
//			}else if(!this.mTextViews.isEmpty()){
//				uinputfield.setSuporPrivacyTag(this.ptagger.getTag(this.mTextViews.get(index).getText()));
//			}
		}
	}
	
	// <EditText NAME, EDITTEXT_ID, HINT, TEXTVIEW, TEXTVIEW_ID, TEXT> 
	public HashMap<String, HierarchyNode> dumpRelationships() {
		HashMap<String, HierarchyNode> map = new HashMap<String, HierarchyNode>();

		for(HierarchyNode uinputfield : this.mEditTextViews){			
			map.put(uinputfield.getCounterId(), uinputfield);
			
//			HierarchyNode node = uinputfield.getAssociatedSUPORLabel();
//			if(node != null){
//				System.out.println("["+uinputfield.getName() +","
//								+uinputfield.getId()+","
//								+uinputfield.getCounterId()+","
//								+((uinputfield.getHint() == null || uinputfield.getHint().isEmpty()) ?  "null" : uinputfield.getHint())+","
//								+node.getName()+","
//								+node.getId()+","
//								+node.getCounterId()+","
//								+node.getText()+"]"
//					);
//			}else{
//				System.out.println("["+uinputfield.getName() +","
//						+uinputfield.getId()+","
//						+uinputfield.getCounterId()+","
//						+((uinputfield.getHint() == null || uinputfield.getHint().isEmpty()) ?  "null" : uinputfield.getHint())+","
//						+"]"
//			);
//			}
		}
		return map;
	}

	
	private boolean isTop(double y, double top){
		return (y < top);
	}
	
	private boolean isBottom(double y, double bottom){
		return (y > bottom);
	}
	
	private boolean isLeft(double x, double left){
		return (x < left);
	}
	
	private boolean isRight(double x, double right){
		return (x > right);
	}
	
	private boolean isCenter(double x, double left, double right){
		return !(isLeft(x, left) || isRight(x, right));
	}
	
	private boolean isMiddle(double y, double top, double bottom){
		return !(isTop(y, top) || isBottom(y,bottom));	
	}
	
	private double getWeight(HierarchyNode editText, Coordinate c){
		double left = (double)editText.getLeft(), right = (double)editText.getRight(),
				top = (double)editText.getTop(), bottom = (double)editText.getBottom();

		if (isLeft(c.x(), left) && isTop(c.y(), top)){// Top left
			return 4.0;
		}else if(isRight(c.x(), right) && isTop(c.y(), top)){// Top right
			return 8.0;
		}else if(isCenter(c.x(), left, right) && isTop(c.y(), top)){// Top center
			return 2.0;
		}else if(isMiddle(c.y(), top, bottom) && isLeft(c.x(), left)){// Middle left
			return 0.8;
		}else if(isMiddle(c.y(), top, bottom) && isCenter(c.x(), left, right)){// Middle center
			return 6.0;
		}else if(isMiddle(c.y(), top, bottom) && isRight(c.x(), right)){ //Middle right
			return 9.0;
		}else if(isLeft(c.x(), left) && isBottom(c.y(), bottom)){// Bottom left
			return 8.0;
		}else if(isCenter(c.x(), left, right) && isBottom(c.y(), bottom)){// Bottom center
			return 9.0;
		}else if(isRight(c.x(), right) && isBottom(c.y(), top)){// Top right			
			return 10.0;
		}
		return 100.0;//This never happens
	}
	
	private Coordinate getClosestCoordinate(HierarchyNode editText, Coordinate c){
		double left = (double)editText.getLeft(), right = (double)editText.getRight(),
				top = (double)editText.getTop(), bottom = (double)editText.getBottom();

		if (isLeft(c.x(), left) && isTop(c.y(), top)){// Top left
			return editText.getRect().getTopLeft();
		}else if(isRight(c.x(), right) && isTop(c.y(), top)){// Top right
			return editText.getRect().getTopRight();
		}else if(isCenter(c.x(), left, right) && isTop(c.y(), top)){// Top center
			return new Coordinate(c.x(), top);
		}else if(isMiddle(c.y(), top, bottom) && isLeft(c.x(), left)){// Middle left
			return new Coordinate(left, c.y());					
		}else if(isMiddle(c.y(), top, bottom) && isCenter(c.x(), left, right)){// Middle center
			return editText.getRect().getCentroid(); // Return itself
		}else if(isMiddle(c.y(), top, bottom) && isRight(c.x(), right)){ //Middle right
			return new Coordinate(right, c.y());
		}else if(isLeft(c.x(), left) && isBottom(c.y(), bottom)){// Bottom left
			return editText.getRect().getBottomLeft();
		}else if(isCenter(c.x(), left, right) && isBottom(c.y(), bottom)){// Bottom center
			return new Coordinate(c.x(), bottom);
		}else if(isRight(c.x(), right) && isBottom(c.y(), top)){// Top right			
			return editText.getRect().getTopRight();
		}
		return editText.getCentroid();//This never happens
	}
	
	private double computeScore(HierarchyNode editText, HierarchyNode textView){
		double score = 0;
		double numPixels = 0;
		
		for(int y = textView.getTop(); y <= textView.getBottom(); y++){
			for(int x = textView.getLeft(); x <= textView.getRight(); x++){
				Coordinate c = new Coordinate(x, y);
				score += c.euclideanDistance(getClosestCoordinate(editText, c)) * getWeight(editText, c);
				//score += c.euclideanDistance(editText.getCentroid()) * getWeight(editText, c);
				numPixels++;
			}
		}		
		return score/numPixels;
	}
	
	private int getMinIndex(double[] scores){
		int min = 0;
		for(int i = 1; i < scores.length; i++){
			if(scores[i] < scores[min]){
				min = i;
			}
		}
		return min;
	}

	private boolean isVisible(HierarchyNode base){
//		return base.isVisible();
		if(base.getParent() == null && base.isVisible()){
			return true;
		}
		if(!base.isVisible()){
			return false;
		}
		return isVisible(base.getParent());
	}
	
	private void buildLists(HierarchyNode base){
		if(base.getSuperClass() != null && base.getSuperClass().length() > 0){
			if(base.getSuperClass().equals(Constants.TEXT_VIEW_CLASS) && isVisible(base)){
				if(base.getText() != null && !base.getText().isEmpty()){
					this.mTextViews.add(base);
				}
			}else if(base.getSuperClass().equals(Constants.EDIT_TEXT_CLASS) && isVisible(base)){
				this.mEditTextViews.add(base);
			}
		}
		
		for(HierarchyNode node : base.getChildren()){
			buildLists(node);
		}
	}
}