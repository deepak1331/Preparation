package Shapes.Chapter20;

import javax.annotation.*;

public class Circle implements Shape {

	private Point center;

	public Point getCenter() {
		return center;
	}

	@Resource(name = "pointC")
	public void setCenter(Point center) {
		this.center = center;
	}

	public void draw() {
		System.out.println("\nCircle's center is at (" + center.getX() + ", " + center.getY() + ")");
	}

	@PostConstruct
	public void initializeCircle() {
		System.out.println("\nInit of circle is called");
	}

	@PreDestroy
	public void destroyCircle() {
		System.out.println("\nDestroy of circle is called");
	}
}
