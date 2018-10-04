package Shapes.Chapter17;

public class Triangle implements Shape {

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
	
	public void draw(){
		System.out.println("Triangle's vertex's are :\nPoint A" + pointA);
		System.out.println("Point B" + pointB);
		System.out.println("Point C" + pointC);
	}
}
