package com.benandow.android.gui.layoutModel;


public class HierarchyTree {
	
	private HierarchyNode mRoot;
	private String mPackageName;
	private int mLayoutId;
	
	public HierarchyTree(){ }
	
	public HierarchyTree(String packageName, int layoutId){
		this.mPackageName = packageName;
		this.mLayoutId = layoutId;
	}
	
	public int getWidth(){
		return (this.mRoot == null) ? 0 : this.mRoot.getRight();
	}
	
	public int getHeight(){
		return (this.mRoot == null) ? 0 : this.mRoot.getBottom();
	}

	public void setTreeRoot(HierarchyNode root){
		this.mRoot = root;
	}
	
	public HierarchyNode getTreeRoot(){
		return this.mRoot;
	}
	
	public void setPackageName(String packageName){
		this.mPackageName = packageName;
	}
	
	public String getPackageName(){
		return this.mPackageName;
	}
	
	public int getLayoutId(){
		return this.mLayoutId;
	}
	
	public void setLayoutId(int layoutId){
		this.mLayoutId = layoutId;
	}
	
	public static void dumpHierarchy(HierarchyNode base, String indent){
		System.out.println(indent+base.toString());
		for(HierarchyNode node : base.getChildren()){
			dumpHierarchy(node, indent+"\t");
		}
	}
	
}