package com.benandow.uiref.layoutModel;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class HierarchyNode {
	
	private List<HierarchyNode> mChildren;
	private HierarchyNode mParent;
	private String mType, mName, mText, mHint, mId, mSuperclass, mVisibility, mCounterId, mInputType;
	private String mAnnotatedLabelCounter, mAnnotatedPrivacyTag;
	private DrawableNode[] mDrawables;	
	private Rectangle rect;
	private HierarchyNode mAssocLabel;
	private String mAssocLabelCounter;
	private HierarchyNode mAssocSUPORLabel;
	private String mAssocSUPORLabelCounter;
	
	private String mSuporPrivacyTag;
	private String mPrivacyTag;
	
	
	
	//Populated HierarchyNode object with values in Constants.java
	public HierarchyNode(HashMap<String, String> attrMap){
		this.mType = returnNullIfEmpty(attrMap.get(Constants.NODE_TYPE));
		this.mName = returnNullIfEmpty(attrMap.get(Constants.NAME_ATTR));
		this.mText = returnNullIfEmpty(attrMap.get(Constants.TEXT_ATTR));
		this.mHint = returnNullIfEmpty(attrMap.get(Constants.HINT_ATTR));
		this.mId = returnNullIfEmpty(attrMap.get(Constants.ID_ATTR));
		this.rect = new Rectangle(
				Integer.parseInt(attrMap.get(Constants.LEFT_ATTR)),
				Integer.parseInt(attrMap.get(Constants.TOP_ATTR)),
				Integer.parseInt(attrMap.get(Constants.RIGHT_ATTR)),
				Integer.parseInt(attrMap.get(Constants.BOTTOM_ATTR))
				);
		this.mChildren = new ArrayList<HierarchyNode>();
		this.mSuperclass = attrMap.get(Constants.SUPER_ATTR);
		this.mVisibility = returnNullIfEmpty(attrMap.get(Constants.VISIBILITY_ATTR));
		this.mParent = null;
		this.mCounterId = returnNullIfEmpty(attrMap.get(Constants.COUNTER_REF_ID));
		this.mInputType = returnNullIfEmpty(attrMap.get(Constants.INPUT_TYPE));
		this.mDrawables = DrawableNode.parse(
				returnNullIfEmpty(attrMap.get(Constants.DRAWABLE_ID_ATTR)),
				returnNullIfEmpty(attrMap.get(Constants.DRAWABLE_TOP_ATTR)),
				returnNullIfEmpty(attrMap.get(Constants.DRAWABLE_RIGHT_ATTR)),
				returnNullIfEmpty(attrMap.get(Constants.DRAWABLE_BOTTOM_ATTR)),
				returnNullIfEmpty(attrMap.get(Constants.DRAWABLE_LEFT_ATTR)),
				returnNullIfEmpty(attrMap.get(Constants.DRAWABLE_VISIBILITY))
				);
		this.mSuporPrivacyTag = returnNullIfEmpty(attrMap.get(Constants.SUPOR_PRIVACY_TAG));
		this.mPrivacyTag = returnNullIfEmpty(attrMap.get(Constants.PRIVACY_TAG));
		this.mAnnotatedPrivacyTag = returnNullIfEmpty(attrMap.get(Constants.ANNOTATED_PRIVACY_TAG));
		this.mAnnotatedLabelCounter = returnNullIfEmpty(attrMap.get(Constants.ANNOTATED_LABEL_COUNTER));
		this.mAssocLabelCounter =  returnNullIfEmpty(attrMap.get(Constants.LABEL_COUNTER_ATTR));
		this.mAssocSUPORLabelCounter = returnNullIfEmpty(attrMap.get(Constants.SUPOR_LABEL_COUNTER_ATTR));
		this.mAssocLabel = null;
		this.mAssocSUPORLabel = null;
	}
	
	public DrawableNode[] getDrawables() {
		return this.mDrawables;
	}

	private String returnNullIfEmpty(String s){
		return (s == null || s.trim().isEmpty()) ? null : s.trim();
	}
	
	public String getAnnotatedLabelCounter() {
		return this.mAnnotatedLabelCounter;
	}

	public void setAnnotatedLabelCounter(String annotatedLabelCounter) {
		this.mAnnotatedLabelCounter = annotatedLabelCounter;
	}

	public String getAnnotatedPrivacyTag() {
		return this.mAnnotatedPrivacyTag;
	}

	public void setAnnotatedPrivacyTag(String annotatedPrivacyTag) {
		this.mAnnotatedPrivacyTag = annotatedPrivacyTag;
	}

	public void setDrawables(DrawableNode[] drawables) {
		this.mDrawables = drawables;
	}

	public String getInputType(){
		return this.mInputType;
	}
	
	public String getCounterId(){
		return this.mCounterId;
	}
	
	public HierarchyNode getParent(){
		return this.mParent;
	}
	
	public boolean hasParent(){
		return (this.mParent != null);
	}
	
	public void setParent(HierarchyNode node){
		this.mParent = node;
	}
	
	public String getSuperClass(){
		return this.mSuperclass;
	}
	
	public String getVisibility(){
		return this.mVisibility;
	}
	
	public boolean isVisible(){
		return (this.mVisibility.equals(Constants.VISIBLE_ATTR));
	}
	
	public HierarchyNode getAssociatedLabel(){
		if(this.mAssocLabel == null && this.mAssocLabelCounter != null){
			//TODO resolve HierarchyNode label by counter id
			
		}
		return this.mAssocLabel;
	}
	
	public String getAssociatedLabelCounter(){
		return this.mAssocLabelCounter;
	}
	
	public String getAssociatedSUPORLabelCounter(){
		return this.mAssocSUPORLabelCounter;
	}
	
	public HierarchyNode getAssociatedSUPORLabel(){
		if(this.mAssocSUPORLabel == null && this.mAssocSUPORLabelCounter != null){
			//TODO resolve HierarchyNode label by counter id
			
		}
		return this.mAssocSUPORLabel;
	}
	
	public void setAssociatedLabel(HierarchyNode node){
		this.mAssocLabel = node;
	}
	
	public void setAssociatedSUPORLabel(HierarchyNode node){
		this.mAssocSUPORLabel = node;
	}
	
	public void setSuporPrivacyTag(String tag){
		this.mSuporPrivacyTag = tag;
	}
	
	public String getSuporPrivacyTag(){
		return this.mSuporPrivacyTag;
	}
	
	public void setPrivacyTag(String tag){
		this.mPrivacyTag = tag;
	}
	
	public String getPrivacyTag(){
		return this.mPrivacyTag;
	}
	
	public int numChildren(){
		return mChildren.size();
	}
	
	public List<HierarchyNode> getChildren(){
		return this.mChildren;
	}
	
	public HierarchyNode getChild(int pos){
		return this.mChildren.get(pos);
	}
	
	public void setChild(HierarchyNode node){
		node.setParent(this);
		this.mChildren.add(node);
	}

	@Override
	public String toString() {
		return  this.mName+
				", Id = "+this.mId+
				", Text = "+this.mText+
				", Hint = "+this.mHint+
				", Left = "+this.rect.mLeft+
				", Top = "+this.rect.mTop+
				", Right = "+this.rect.mRight+
				", Bottom = "+this.rect.mBottom;		
	}
	
	public String getType() {
		return this.mType;
	}

	public String getName() {
		return this.mName;
	}

	public String getText() {
		return this.mText;
	}

	public String getHint() {
		return this.mHint;
	}

	public String getId() {
		return this.mId;
	}

	public Coordinate getCentroid(){
		return this.rect.getCentroid();
	}
	
	public int getLeft() {
		return this.rect.getLeft();
	}

	public int getTop() {
		return this.rect.getTop();
	}

	public int getRight() {
		return this.rect.getRight();
	}
	
	public int getBottom() {
		return this.rect.getBottom();
	}
	
	public Rectangle getRect(){
		return this.rect;
	}

	public boolean isView(){
		return this.mType.equals(Constants.VIEW_TAG);
	}
	
	public boolean isViewGroup(){
		return this.mType.equals(Constants.VIEW_GROUP_TAG);

	}
	
	public boolean isTextField(){
		return this.mSuperclass.equals(Constants.TEXT_VIEW_CLASS);
	}
	
	public boolean isEditText(){
		return this.mSuperclass.equals(Constants.EDIT_TEXT_CLASS);
	}
	
	public boolean containsText(){
		return (this.mText != null && !this.mText.isEmpty()) || 
				(this.mHint != null && !this.mHint.isEmpty());
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((mCounterId == null) ? 0 : mCounterId.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		HierarchyNode other = (HierarchyNode) obj;
		if (mCounterId == null) {
			if (other.mCounterId != null)
				return false;
		} else if (!mCounterId.equals(other.mCounterId))
			return false;
		return true;
	}
}
