package com.shapes;

public class Rectangle {

	Point pointA,pointB,pointC,pointD;

	public Point getPointA() {
		return pointA;
	}

	public void setPointA(Point pointA) {
		this.pointA = pointA;
	}

	public Point getPointB() {
		return pointB;
	}

	public void setPointB(Point pointB) {
		this.pointB = pointB;
	}

	public Point getPointC() {
		return pointC;
	}

	public void setPointC(Point pointC) {
		this.pointC = pointC;
	}

	public Point getPointD() {
		return pointD;
	}

	public void setPointD(Point pointD) {
		this.pointD = pointD;
	}
	
	public void draw(){
		System.out.println("Rectangle Drawn with following coordinates : ");
		System.out.println("PointA : "+getPointA().toString());
		System.out.println("PointB : "+getPointB().toString());
		System.out.println("PointC : "+getPointC().toString());
		System.out.println("PointD : "+getPointD().toString());
	}
	
}
