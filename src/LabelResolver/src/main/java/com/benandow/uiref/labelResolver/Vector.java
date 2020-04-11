package com.benandow.uiref.labelResolver;

import com.benandow.uiref.layoutModel.Coordinate;

public class Vector {

	public Coordinate mDisplacement;
	private double mMagnitude;
	private double mDirection;
	private Coordinate mC1;
	private Coordinate mC2;
	
	public Vector(Coordinate c1, Coordinate c2, double defaultVal){
		this.mC1 = c1;
		this.mC2 = c2;
		double x = c2.x() - c1.x();
		double y = -(c2.y() - c1.y());
		this.mDisplacement = new Coordinate(x, y);
		this.mMagnitude = Math.round(Math.sqrt(Math.pow(x, 2.0)+Math.pow(y, 2.0)));		
		this.mDirection = Math.round(calcDirection(x, y, defaultVal));
	}
		
	private double calcDirection(double x, double y, double defaultVal){
		double deg = Math.toDegrees(Math.atan(Math.abs(y)/Math.abs(x)));
		if((Math.abs(y) == 0.0 || Math.abs(x) == 0.0)){// && deg == 0.0){
			return defaultVal;			
		}
		if(Math.abs(y) == 0.0 && Math.abs(x) == 0.0){//Origin NaN
			return defaultVal;
		}else if(y == 0.0 && x > 0.0){//Boundary bt. Q1 & Q4
			return 0.0;
		}else if(x == 0.0 && y > 0.0){//Boundary bt. Q1 & Q2
			return 90.0;
		}else if(y == 0.0 && x < 0.0){//Boundary bt. Q2 & Q3
			return 180.0;
		}else if(x == 0.0 && y < 0.0){//Boundary bt. Q3 & Q4
			return 270.0;
		}else if(x > 0.0 && y > 0.0){//Quadrant 1
			deg += 0.0;
		}else if(x < 0.0 && y > 0.0){//Quadrant 2
			deg = (90.0-deg)+90.0;
		}else if(x < 0.0 && y < 0.0){//Quadrant 3
			deg += 180.0;
		}else if(x > 0.0 && y < 0.0){//Quadrant 4
			deg= (90.0-deg)+270.0;
		}
		return deg;
	}
	
	public double getMagnitude(){
		return this.mMagnitude;
	}

	public double getDirection(){
		return this.mDirection;
	}
	
	public Coordinate getC1(){
		return this.mC1;
	}
	
	public Coordinate getC2(){
		return this.mC2;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		long temp;
		temp = Double.doubleToLongBits(mDirection);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		temp = Double.doubleToLongBits(mMagnitude);
		result = prime * result + (int) (temp ^ (temp >>> 32));
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
		Vector other = (Vector) obj;
		if (Double.doubleToLongBits(mDirection) != Double.doubleToLongBits(other.mDirection))
			return false;
		if (Double.doubleToLongBits(mMagnitude) != Double.doubleToLongBits(other.mMagnitude))
			return false;
		return true;
	}
}
