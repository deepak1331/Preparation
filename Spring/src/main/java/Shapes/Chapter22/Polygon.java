package Shapes.Chapter22;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class Polygon implements Shape {

	private List<Point> points;

	public List<Point> getPoints() {
		return points;
	}

	@Autowired
	public void setPoints(List<Point> points) {
		this.points = points;
	}

	public void draw() {
		System.out.println("Total number of Points in this Polygon are : " + getPoints().size());
		for (Point p : getPoints())
			System.out.println(p);
	}

}
