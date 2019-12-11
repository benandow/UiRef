package com.benandow.android.gui.labelResolver;

import com.benandow.android.gui.layoutModel.Coordinate;
import com.benandow.android.gui.layoutModel.HierarchyNode;

public class SuporScore {

	public static double computeScore(HierarchyNode editText, HierarchyNode textView){
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
	
	private static boolean isTop(double y, double top){
		return (y < top);
	}
	
	private static boolean isBottom(double y, double bottom){
		return (y > bottom);
	}
	
	private static boolean isLeft(double x, double left){
		return (x < left);
	}
	
	private static boolean isRight(double x, double right){
		return (x > right);
	}
	
	private static boolean isCenter(double x, double left, double right){
		return !(isLeft(x, left) || isRight(x, right));
	}
	
	private static boolean isMiddle(double y, double top, double bottom){
		return !(isTop(y, top) || isBottom(y,bottom));	
	}
	
	private static double getWeight(HierarchyNode editText, Coordinate c){
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
	
	private static Coordinate getClosestCoordinate(HierarchyNode editText, Coordinate c){
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
	
}
