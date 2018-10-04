package Shapes.Chapter12;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.BeanNameAware;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import Shapes.Chapter12.Point;

public class Triangle implements ApplicationContextAware, BeanNameAware {

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

	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		this.context = context;

	}

	public void setBeanName(String name) {
		System.out.println("Bean Name is : " + name);
	}
}