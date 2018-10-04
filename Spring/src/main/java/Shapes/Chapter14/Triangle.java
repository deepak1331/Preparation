package Shapes.Chapter14;

import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;

//Its using Spring specific methods and code is bind to the framework.
public class Triangle implements InitializingBean, DisposableBean {

	private Point pointA;
	private Point pointB;
	private Point pointC;

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

	public void afterPropertiesSet() throws Exception {
		System.out.println("\nInitializingBean init() called for Triangle.\nMember variables are implemented.\n");
	}

	public void destroy() throws Exception {
		System.out.println("\nDisposableBean destroy() called for Triangle.");
	}
	
	public void myInit(){
		System.out.println("\n myInit() method called for Triangle"); 
	}
	
	public void cleanUp(){
		System.out.println("\n myDestroy/cleanUp() method called for Triangle"); 
	}
}
