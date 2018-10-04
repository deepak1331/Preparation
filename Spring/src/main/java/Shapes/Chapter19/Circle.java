package Shapes.Chapter19;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

public class Circle implements Shape {

	private Point center;

	public Point getCenter() {
		return center;
	}

	@Autowired
	@Qualifier("circle_related")
	public void setCenter(Point center) {
		this.center = center;
	}

	public void draw() {
		System.out.println("\nCircle's center is at (" + center.getX() + ", " + center.getY() + ")");
	}
}
