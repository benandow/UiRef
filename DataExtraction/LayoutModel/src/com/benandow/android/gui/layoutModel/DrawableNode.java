package com.benandow.android.gui.layoutModel;

public class DrawableNode {

	//FIXME need to convert to absolute coordinates
	private Rectangle mRect;
	private String mDrawableId;
	private boolean mDrawableVisibility;
	
	public DrawableNode(Rectangle rect, String id, boolean visibility){
		this.mRect = rect;
		this.mDrawableId = id;
		this.mDrawableVisibility = visibility;
	}
	
	public static DrawableNode[] parse(String drawableId, String drawableTop, String drawableRight, String drawableBottom, String drawableLeft, String drawableVisibility){
		if(drawableId == null || drawableId.isEmpty() 
				|| drawableTop == null || drawableTop.isEmpty()
				|| drawableRight == null || drawableRight.isEmpty()
				|| drawableBottom == null || drawableBottom.isEmpty()
				|| drawableLeft == null || drawableLeft.isEmpty()
				|| drawableVisibility == null || drawableVisibility.isEmpty()){
			return null;
		}
		
		String[] ids = drawableId.split(Constants.DRAWABLE_SEPARATOR);
		String[] tops = drawableTop.split(Constants.DRAWABLE_SEPARATOR);
		String[] rights = drawableRight.split(Constants.DRAWABLE_SEPARATOR);
		String[] bottoms =  drawableBottom.split(Constants.DRAWABLE_SEPARATOR);
		String[] lefts = drawableLeft.split(Constants.DRAWABLE_SEPARATOR);
		String[] visibilities = drawableVisibility.split(Constants.DRAWABLE_SEPARATOR);
	
		if(ids.length > 0 && ids.length == tops.length && tops.length == rights.length && 
				rights.length == bottoms.length && bottoms.length == lefts.length && 
				lefts.length == visibilities.length){
			DrawableNode[] nodes = new DrawableNode[ids.length];
			for(int i = 0; i < ids.length; i++){
				nodes[i] = new DrawableNode(new Rectangle(Integer.parseInt(lefts[i]), 
						Integer.parseInt(tops[i]), Integer.parseInt(rights[i]), Integer.parseInt(bottoms[i])),
						ids[i], Boolean.parseBoolean(visibilities[i]));
			}
			return nodes;
		}
		return null;		
	}

	public Rectangle getmRect() {
		return mRect;
	}

	public void setmRect(Rectangle mRect) {
		this.mRect = mRect;
	}

	public String getmDrawableId() {
		return mDrawableId;
	}

	public void setmDrawableId(String mDrawableId) {
		this.mDrawableId = mDrawableId;
	}

	public boolean ismDrawableVisibility() {
		return mDrawableVisibility;
	}

	public void setmDrawableVisibility(boolean mDrawableVisibility) {
		this.mDrawableVisibility = mDrawableVisibility;
	}
}