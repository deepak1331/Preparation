/**
 * 
 */
package com.shapes;

import java.util.List;

/**
 * @author deepakr
 *
 */
public class Square {

	List<Point> points;

	public List<Point> getPoints() {
		return points;
	}

	public void setPoints(List<Point> points) {
		this.points = points;
	}
	
	public void show(){
		System.out.println("\n\nSquare Drawn with co-ordinates : ");
		for(Point p: points){
			System.out.println(p);
		}
	}
}
