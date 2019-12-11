package com.benandow.android.gui.layoutModel;


public class Coordinate {
	
	private double x, y;
	
	public Coordinate(int x, int y){
		this.x = (double)x;
		this.y = (double)y;
	}
	
	public Coordinate(double x, double y){
		this.x = x;
		this.y = y;
	}
	
	public double x(){
		return this.x;
	}
	
	public double y(){
		return this.y;
	}
	
	public static double euclideanDistance(Coordinate c1, Coordinate c2){
		return Math.sqrt(Math.pow(c1.x - c2.x, 2.0) + Math.pow(c1.y - c2.y, 2.0));
	}
	
	public double euclideanDistance(Coordinate c2){
		return euclideanDistance(this, c2);
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		long temp;
		temp = Double.doubleToLongBits(x);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		temp = Double.doubleToLongBits(y);
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
		Coordinate other = (Coordinate) obj;
		if (Double.doubleToLongBits(x) != Double.doubleToLongBits(other.x))
			return false;
		if (Double.doubleToLongBits(y) != Double.doubleToLongBits(other.y))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return String.format("(%f, %f)", this.x, this.y);
	}
}