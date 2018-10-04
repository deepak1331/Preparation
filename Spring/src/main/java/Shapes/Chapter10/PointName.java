package Shapes.Chapter10;

import Shapes.Chapter10.Point;

public class PointName {

	private Point point;
	private User userName;

	public PointName(Point point, User userName) {
		System.out.println("Parametrized Constructor called");
		this.point = point;
		this.userName = userName;
	}
	public PointName() {
		System.out.println("Default Constructor called");
	}

	public Point getPoint() {
		return point;
	}

	public void setPoint(Point point) {
		this.point = point;
	}

	public User getUserName() {
		return userName;
	}

	public void setUserName(User userName) {
		this.userName = userName;
	}

	public void draw() {
		userName.display();
		System.out.println(" entered a point with coordinates : " + point);
	}
}