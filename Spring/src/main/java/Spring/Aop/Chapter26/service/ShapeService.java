package Spring.Aop.Chapter26.service;

import Spring.Aop.Chapter26.model.Circle;
import Spring.Aop.Chapter26.model.Triangle;

public class ShapeService {

	private Circle circle;
	private Triangle triangle;
	
	public Circle getCircle() {
		return circle;
	}
	public void setCircle(Circle circle) {
		this.circle = circle;
	}
	public Triangle getTriangle() {
		return triangle;
	}
	public void setTriangle(Triangle triangle) {
		this.triangle = triangle;
	}
	
	
}
