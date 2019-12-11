package com.benandow.android.gui.labelResolver;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.benandow.android.gui.layoutModel.Constants;
import com.benandow.android.gui.layoutModel.HierarchyNode;
import com.benandow.android.gui.layoutModel.HierarchyTree;

public class GuiPlot {
	//TODO remove before release
	public static boolean DEBUG = false;
	
	private HierarchyTree mTree;
	private List<HierarchyNode> mTextViews;
	private List<HierarchyNode> mEditTextViews;
	
	public GuiPlot(HierarchyTree tree){
		this.mTree = tree;
		this.mTextViews = new ArrayList<HierarchyNode>();
		this.mEditTextViews = new ArrayList<HierarchyNode>();
		constructLists(this.mTree.getTreeRoot());
	}
		
	public HashMap<String, HierarchyNode> dumpRelationships(List<Pair<HierarchyNode, HierarchyNode>> resolved) {
		HashMap<String, HierarchyNode> resMap = new HashMap<String, HierarchyNode>();

		for(HierarchyNode n : mEditTextViews){
//			n.setAssociatedLabel(null);
			resMap.put(n.getCounterId(), n);
		}
		return resMap;
	}
	
	public List<Pair<HierarchyNode, HierarchyNode>> resolveDescriptors(){
		List<Pair<HierarchyNode, HierarchyNode>> resolved = LabelResolver.resolveLabels(this.mTextViews, this.mEditTextViews);
		
		//Set associated labels and init map of resolved
		for(Pair<HierarchyNode, HierarchyNode> p : resolved){
			p.getL().setAssociatedLabel(p.getR());
		}
		
		if(DEBUG){
			System.out.println("-----------DONE---------");
			for(Pair<HierarchyNode, HierarchyNode> p : resolved){
				//DEBUG PRINT
				Vector[] v = CollisionPredictor.calcCollisionVector(p.getL().getRect(), p.getR().getRect());
				System.out.printf("InputField(%s) %s-->Label(%s - %s) = <magnitude, direction>=<%f, %f>AND<%f, %f>\n",
						p.getL().getCounterId(), p.getL().getHint(), p.getR().getCounterId(), p.getR().getText(),
						v[0].getMagnitude(), v[0].getDirection(), v[1].getMagnitude(), v[1].getDirection());
				System.out.printf("\tSupor Score = %f\n", SuporScore.computeScore(p.getL(), p.getR()));
			}
		}
		return resolved;
	}

	private boolean isVisible(HierarchyNode base){
		if(base.getParent() == null && base.isVisible()){
			return true;
		}
		if(!base.isVisible()){
			return false;
		}
		return isVisible(base.getParent());
	}
	
	private void constructLists(HierarchyNode base){
		if(base.getSuperClass() != null && !base.getSuperClass().isEmpty()){
			if(base.getSuperClass().equals(Constants.TEXT_VIEW_CLASS) && isVisible(base)
					&& base.getText() != null && !base.getText().isEmpty()){
				this.mTextViews.add(base);
			}else if((
					base.getSuperClass().equals(Constants.EDIT_TEXT_CLASS)		||
					base.getSuperClass().equals(Constants.ABS_SPINNER_CLASS) 	||
					base.getSuperClass().equals(Constants.CHECKBOX_CLASS) 		||
					base.getSuperClass().equals(Constants.RADIO_BUTTON_CLASS) 	||
					base.getSuperClass().equals(Constants.SWITCH_CLASS) 		||
					base.getSuperClass().equals(Constants.SWITCH_COMPAT_CLASS) 	||
					base.getSuperClass().equals(Constants.TOGGLE_BUTTON_CLASS) 	||
					base.getSuperClass().equals(Constants.RATING_BAR_CLASS))
					&& isVisible(base)){				
				this.mEditTextViews.add(base);
			}
		}
		for(HierarchyNode node : base.getChildren()){
			constructLists(node);
		}
	}
}
