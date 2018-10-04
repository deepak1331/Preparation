package Shapes.Chapter14;

import java.util.List;

public class Polygon {

	private List<Point> points;

	public List<Point> getPoints() {
		return points;
	}

	public void setPoints(List<Point> points) {
		this.points = points;
	}

	public void display() {
		System.out.println("Total number of Points in this Polygon are : " + getPoints().size());
		for (Point p : getPoints())
			System.out.println(p);
	}
	
	public void myInit(){
		System.out.println("\n myInit() method called for Polygon"); 
	}
	
	public void cleanUp(){
		System.out.println("\n myDestroy/cleanUp() method called for Polygon"); 
	}
}
