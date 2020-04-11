package com.benandow.uiref.labelResolver;

import java.util.ArrayList;
import java.util.List;

import com.benandow.uiref.layoutModel.Coordinate;
import com.benandow.uiref.layoutModel.Rectangle;

public class CollisionPredictor {
	//TODO remove before release
	public static boolean USE_THIRD_VECTOR = true;
	
	private static int DISTANCE_THRESHOLD = 0; //10 Pixels
	//TODO check for collisions into other widgets
	
	public static List<Vector[]> getCollisionVector(Rectangle r1, List<Rectangle> r2list){		
		List<Vector[]> vlist = new ArrayList<Vector[]>(r2list.size());
		for(Rectangle r2 : r2list){
			vlist.add(calcCollisionVector(r2, r2));
		}
		return vlist;
	}
	
	public static List<Vector[]> getCollisionVector(Rectangle r1, Rectangle[] r2list){		
		List<Vector[]> vlist = new ArrayList<Vector[]>(r2list.length);
		for(Rectangle r2 : r2list){
			vlist.add(calcCollisionVector(r2, r2));
		}
		return vlist;
	}
	
	public static Vector[] calcCollisionVector(Rectangle r1, Rectangle r2){
//		System.out.println(r1.toString() +"\t\t"+r2.toString());
		if(Sector.containedInTop(r1,r2) || Sector.containedInBottom(r1,r2)){
			//r2 is entirely above or below r1 - align based on width
			return calcCollisionVectorW(r1, r2, Sector.containedInTop(r1,r2));
		}
		//Portion of r2 is next to r1 - align based on height
		return calcCollisionVectorH(r1, r2, Sector.containedInLeft(r1, r2));
	}
	
	public static Vector[] sortByMagnitude(Vector[] v){
		 for (int i = 1; i < v.length; i++) {
			 for(int j = i ; j > 0 ; j--){
				 if(v[j].getMagnitude() < v[j-1].getMagnitude()){
					 Vector temp = v[j];
					 v[j] = v[j-1];
					 v[j-1] = temp;
				 }
			 }
		 }
		 return v;
	}
	
	private static Coordinate[] getCommonCoordinatesW(Rectangle r1, Rectangle r2, boolean isAbove){
		int i = r1.getLeft();
		for(i = r1.getLeft(); i < r1.getRight(); i++){
			if(i >= r2.getLeft() && i <= r2.getRight()){
				break;
			}
		}
		return new Coordinate[]{new Coordinate(i, 
										(isAbove ? r1.getTop() : r1.getBottom())),
								new Coordinate(i, 
										(isAbove ? r2.getBottom() : r2.getTop()))};
	}
	
	//isAbove represents that r2 is above r1
	private static Vector[] calcCollisionVectorW(Rectangle r1, Rectangle r2, boolean isAbove){
		Vector v1 = new Vector(
					(isAbove ? r1.getTopLeft() : r1.getBottomLeft()),
					(isAbove ? r2.getBottomLeft() : r2.getTopLeft()),
					(isAbove ? 90.0 : 270.0));
		Vector v2 = new Vector(
					(isAbove ? r1.getTopRight() : r1.getBottomRight()),
					(isAbove ? r2.getBottomRight() : r2.getTopRight()),
					(isAbove ? 90.0 : 270.0));
		
		//If entirely above or entirely below
		if((r1.getLeft() >= r2.getLeft()-DISTANCE_THRESHOLD && r1.getLeft() <= r2.getRight()+DISTANCE_THRESHOLD && r1.getRight() <= r2.getRight()+DISTANCE_THRESHOLD && r1.getRight() >= r2.getLeft()-DISTANCE_THRESHOLD)
				|| (r2.getLeft() >= r1.getLeft()-DISTANCE_THRESHOLD && r2.getLeft() <= r1.getRight()+DISTANCE_THRESHOLD && r2.getRight() <= r1.getRight()+DISTANCE_THRESHOLD && r2.getRight() >= r1.getLeft()-DISTANCE_THRESHOLD)){
			Coordinate[] v3coors = getCommonCoordinatesW(r1, r2, isAbove);		
			Vector v3 = new Vector(
					v3coors[0], 
					v3coors[1], 
					(isAbove ? 90.0 : 270.0));
			if(USE_THIRD_VECTOR){
				return sortByMagnitude(new Vector[]{v1, v2, v3});
			}
		}
		
		return (v1.getMagnitude() <= v2.getMagnitude()) ? new Vector[]{v1, v2} : new Vector[]{v2, v1};
//		return new Vector[]{v1, v2};//(v1.getMagnitude() <= v2.getMagnitude()) ? v1 : v2;
	}
	
	private static Coordinate[] getCommonCoordinatesH(Rectangle r1, Rectangle r2, boolean isLeft){
		int i = r1.getTop();
		for(i = r1.getTop(); i < r1.getBottom(); i++){
			if(i >= r2.getTop() && i <= r2.getBottom()){
				break;
			}
		}
		return new Coordinate[]{new Coordinate(
										(isLeft ? r1.getLeft() : r1.getRight()), i),
								new Coordinate( 
										(isLeft ? r2.getRight() : r2.getLeft()), i)};
	}

	//isLeft represents that r2 is left of r1
	private static Vector[] calcCollisionVectorH(Rectangle r1, Rectangle r2, boolean isLeft){
		Vector v1 = new Vector(
					(isLeft ? r1.getTopLeft() : r1.getTopRight()),
					(isLeft ? r2.getTopRight() : r2.getTopLeft()),
					(isLeft ? 180.0 : 0.0));
		Vector v2 = new Vector(
					(isLeft ? r1.getBottomLeft() : r1.getBottomRight()),
					(isLeft ? r2.getBottomRight() : r2.getBottomLeft()),
					(isLeft ? 180.0 : 0.0));
		//If entirely left or entirely right
		if((r1.getTop() >= r2.getTop()-DISTANCE_THRESHOLD && r1.getTop() <= r2.getBottom()+DISTANCE_THRESHOLD && r1.getBottom() <= r2.getBottom()-DISTANCE_THRESHOLD && r1.getBottom() >= r2.getTop()+DISTANCE_THRESHOLD)
				|| (r2.getTop() >= r1.getTop()-DISTANCE_THRESHOLD && r2.getTop() <= r1.getBottom() && r2.getBottom()+DISTANCE_THRESHOLD <= r1.getBottom()-10 && r2.getBottom() >= r1.getTop()+DISTANCE_THRESHOLD)){
			Coordinate[] v3coors = getCommonCoordinatesH(r1, r2, isLeft);
			Vector v3 = new Vector(
					v3coors[0], 
					v3coors[1], 
					(isLeft ? 180.0 : 0.0));
			if(USE_THIRD_VECTOR){
				return sortByMagnitude(new Vector[]{v1, v2, v3});
			}
		}
		

		return (v1.getMagnitude() <= v2.getMagnitude()) ? new Vector[]{v1, v2} : new Vector[]{v2, v1};
//		return new Vector[]{v1, v2};//(v1.getMagnitude() <= v2.getMagnitude()) ? v1 : v2;
	}
}
