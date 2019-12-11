package com.benandow.android.gui.labelResolver;

import com.benandow.android.gui.layoutModel.Coordinate;

public class Trapezoid {

	private Vector mV1, mV2;
	
	public Trapezoid(Vector v1, Vector v2){
		this.mV1 = v1;
		this.mV2 = v2;
	}
	
	public static double calculateArea(Vector v1, Vector v2){
		return new Trapezoid(v1, v2).getArea();
	}
	
	public double getArea(){
		Coordinate v1c1 = this.mV1.getC1();
		Coordinate v1c2 = this.mV1.getC2();
		Coordinate v2c1 = this.mV2.getC1();
		Coordinate v2c2 = this.mV2.getC2();
		double base1 = 0.0;
		double base2 = 0.0;
		double height = 0.0;
		
		if(v1c1.x() == v2c1.x()){
			base1 = Math.abs(v1c1.y()-v2c1.y());
			height = Math.abs(v1c1.x()-v2c2.x());
		}else if(v1c1.x() == v2c2.x()){
			base1 = Math.abs(v1c1.y()-v2c2.y());
			height = Math.abs(v1c1.x()-v2c1.x());
		}else if(v1c1.y() == v2c1.y()){
			base1 = Math.abs(v1c1.x()-v2c1.x());
			height = Math.abs(v1c1.y()-v2c2.y());
		}else if(v1c1.y() == v2c2.y()){
			base1 = Math.abs(v1c1.x()-v2c2.x());
			height = Math.abs(v1c1.y()-v2c1.y());
		}else{
			System.out.println("ERR RESOLVING B1");
		}

		if(v2c1.x() == v1c1.x()){
			base2 = Math.abs(v2c1.y()-v1c1.y());
		}else if(v2c1.x() == v1c2.x()){
			base2 = Math.abs(v2c1.y()-v1c2.y());
		}else if(v2c1.y() == v1c1.y()){
			base2 = Math.abs(v2c1.x()-v1c1.x());
		}else if(v2c1.y() == v1c2.y()){
			base2 = Math.abs(v2c1.x()-v1c2.x());
		}else{
			System.out.println("ERR RESOLVING B2");
		}
		return (base1*base2)/2*height;
	}
}