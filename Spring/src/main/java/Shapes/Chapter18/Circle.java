package Shapes.Chapter18;

import org.springframework.beans.factory.annotation.Required;

public class Circle implements Shape {

	private Point center;
	
	public Point getCenter() {
		return center;
	}

	@Required
	public void setCenter(Point center) {
		this.center = center;
	}

	public void draw() {
		System.out.println("\nCircle's center is at ("+ center.getX()+", "+center.getY()+")");
	}
}
