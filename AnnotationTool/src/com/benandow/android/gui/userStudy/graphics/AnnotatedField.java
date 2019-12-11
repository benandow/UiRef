package com.benandow.android.gui.userStudy.graphics;

import java.util.HashSet;

import com.benandow.android.gui.layoutModel.HierarchyNode;

public class AnnotatedField {
	
	public static enum FieldType {
		TITLE,
		LABEL,
		UNKNOWN
	}
	public static boolean HIGHLIGHT_DEFAULT = true;	
	
	private HierarchyNode mNode;
	private FieldType mType;
	private boolean mHighlighted;
	private boolean mIsAnchor;
	private HashSet<AnnotatedField> mAssociatedFields;
	
	public AnnotatedField(HierarchyNode node){
		this.mNode = node;
		this.mAssociatedFields = new HashSet<AnnotatedField>();
		this.mType = FieldType.UNKNOWN;
		this.mIsAnchor = false;
		this.mHighlighted = (this.mNode.containsText()) ? !HIGHLIGHT_DEFAULT: HIGHLIGHT_DEFAULT;
	}
	
	public void setDefaultHighlight(){
		this.mHighlighted = (this.mNode.containsText()) ? !HIGHLIGHT_DEFAULT: HIGHLIGHT_DEFAULT;
	}
	
	public void setAnchor(boolean enable){
		this.mIsAnchor = enable;
	}
	
	public boolean isAnchor(){
		return this.mIsAnchor;
	}
	
	public void reset(){
		this.mAssociatedFields.clear();
		this.mHighlighted = HIGHLIGHT_DEFAULT;
		this.mType = FieldType.UNKNOWN;
		this.mIsAnchor = false;
	}

	public FieldType getType() {
		return mType;
	}

	public void setType(FieldType mType) {
		this.mType = mType;
	}

	public boolean isHighlighted() {
		return mHighlighted;
	}

	public void setHighlighted(boolean mHighlighted) {
		this.mHighlighted = mHighlighted;
	}
	
	public void highlight(){
		this.mHighlighted = !this.mHighlighted;
	}

	public HierarchyNode getNode() {
		return mNode;
	}
	
	public boolean addAssociatedField(AnnotatedField field){
		return this.mAssociatedFields.add(field);
	}
	
	public boolean removeAssociatedField(AnnotatedField field){
		return this.mAssociatedFields.remove(field);
	}
	
	public HashSet<AnnotatedField> getAssociatedFields(){
		return this.mAssociatedFields;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((mNode == null) ? 0 : mNode.hashCode());
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
		AnnotatedField other = (AnnotatedField) obj;
		if (mNode == null) {
			if (other.mNode != null)
				return false;
		} else if (!mNode.equals(other.mNode))
			return false;
		return true;
	}
}