package com.benandow.android.gui.labelResolver;

import com.benandow.android.gui.layoutModel.Rectangle;

public class Sector {

	//TODO changed to allow equals
	//Per pixel methods
	private static boolean isTop(double y, double top){
		return (y <= top);
	}
	
	private static boolean isBottom(double y, double bottom){
		return (y >= bottom);
	}
	
	private static boolean isLeft(double x, double left){
		return (x <= left);
	}
	
	private static boolean isRight(double x, double right){
		return (x >= right);
	}
	
	private static boolean isCenter(double x, double left, double right){
		return !(isLeft(x, left) || isRight(x, right));
	}
	
	private static boolean isMiddle(double y, double top, double bottom){
		return !(isTop(y, top) || isBottom(y,bottom));
	}
		
	
	//Per shape methods
	// Is there a point in r2, that is in the top left partition of r1
	// Top left side of r2 is in top left
	public static boolean pointInTopLeft(Rectangle r1, Rectangle r2){
		return isTop(r2.getTop(), r1.getTop()) && isLeft(r2.getLeft(), r1.getLeft());
	}
	
	// Is there a point in r2, that is in the top right partition of r1
	// Top right side of r2 is above r1 and to the right of r1
	public static boolean pointInTopRight(Rectangle r1, Rectangle r2){
		return isTop(r2.getTop(), r1.getTop()) && isRight(r2.getRight(), r1.getRight());
	}
	
	//Is there a point in r2, that is in the center partition of r1
	// Not a point in top left, not a point in top right
	public static boolean pointInTopCenter(Rectangle r1, Rectangle r2){
		return isTop(r2.getTop(), r1.getTop()) && 
				!(pointInTopLeft(r1, r2) || pointInTopRight(r1, r2));
		
	}

	public static boolean pointInBottomLeft(Rectangle r1, Rectangle r2){
		return isBottom(r2.getBottom(), r1.getBottom()) && isLeft(r2.getLeft(), r1.getLeft());
	}
	
	public static boolean pointInBottomRight(Rectangle r1, Rectangle r2){
		return isBottom(r2.getBottom(), r1.getBottom()) && isRight(r2.getRight(), r1.getRight());
	}
	
	public static boolean pointInBottomCenter(Rectangle r1, Rectangle r2){
		return isBottom(r2.getBottom(), r1.getBottom()) && 
				!(pointInBottomLeft(r1, r2) || pointInBottomRight(r1, r2));
	}
	
	//There is a point in r2 that is in the middle partition of r1
	public static boolean pointInMidLeft(Rectangle r1, Rectangle r2){
		return isLeft(r2.getLeft(), r1.getLeft()) &&
				(isMiddle(r2.getTop(), r1.getTop(), r1.getBottom()) ||
				isMiddle(r2.getBottom(), r1.getTop(), r1.getBottom()) ||
				isMiddle(r1.getTop(), r2.getTop(), r2.getBottom()) ||
				isMiddle(r1.getBottom(), r2.getTop(), r2.getBottom()));		
	}
	
	public static boolean pointInMidRight(Rectangle r1, Rectangle r2){
		return isRight(r2.getLeft(), r1.getLeft()) &&
				(isMiddle(r2.getTop(), r1.getTop(), r1.getBottom()) ||
				isMiddle(r2.getBottom(), r1.getTop(), r1.getBottom()) ||
				isMiddle(r1.getTop(), r2.getTop(), r2.getBottom()) ||
				isMiddle(r1.getBottom(), r2.getTop(), r2.getBottom()));	
	}
	
	
	// Is entirety of r2 in center partition of r1
	public static boolean containedInCenter(Rectangle r1, Rectangle r2){		
		return isCenter(r2.getLeft(), r1.getLeft(), r1.getRight())
				&& isCenter(r2.getRight(), r1.getLeft(), r1.getRight());
	}
	
	public static boolean containedInLeft(Rectangle r1, Rectangle r2){
		return isLeft(r2.getLeft(), r1.getLeft()) && isLeft(r2.getRight(), r1.getLeft());
	}
	
	public static boolean containedInRight(Rectangle r1, Rectangle r2){
		return isRight(r2.getLeft(), r1.getRight()) && isRight(r2.getRight(), r1.getRight());
	}
	
	public static boolean containedInTop(Rectangle r1, Rectangle r2){
		return isTop(r2.getTop(), r1.getTop()) && isTop(r2.getBottom(), r1.getTop());
	}
	
	public static boolean containedInBottom(Rectangle r1, Rectangle r2){
		return isBottom(r2.getTop(), r1.getBottom()) && isBottom(r2.getTop(), r1.getBottom());
	}
	
	public static boolean containedInMiddle(Rectangle r1, Rectangle r2){
		return !(containedInTop(r1, r2) || containedInBottom(r1, r2));
	}
	
}