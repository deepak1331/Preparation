package Shapes.Chapter9;

import java.util.List;

public class Triangle {

	private List<Point> points;

	public List<Point> getPoints() {
		return points;
	}

	public void setPoints(List<Point> points) {
		this.points = points;
	}

	public void draw() {
		System.out.println("Triangle Vertex are as follows : ");
		for (Point p : getPoints()) {
			System.out.println(p);
		}
	}
}