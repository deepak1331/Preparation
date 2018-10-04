package Shapes.Chapter13;

import org.springframework.context.ApplicationContext;

import Shapes.Chapter13.Point;

public class Triangle {

	private Point pointA;
	private Point pointB;
	private Point pointC;
	private ApplicationContext context = null;

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

	public void draw() {
		System.out.println("Point A" + pointA);
		System.out.println("Point B" + pointB);
		System.out.println("Point C" + pointC);
	}
}