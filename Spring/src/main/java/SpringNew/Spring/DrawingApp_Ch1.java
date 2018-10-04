package SpringNew.Spring;

import Shapes.Chapter1.Circle;
import Shapes.Chapter1.Drawing;
import Shapes.Chapter1.Shape;
import Shapes.Chapter1.Triangle;

/**
 * Hello world!
 *
 */
public class DrawingApp_Ch1 {
	public static void main(String[] args) {
		System.out.println("Spring Demo");

		Drawing drawing = new Drawing();
		Shape shape = new Circle();
		drawing.setShape(shape);
		drawing.drawShape();

		shape = new Triangle();
		drawing.setShape(shape);
		drawing.drawShape();
	}

}
