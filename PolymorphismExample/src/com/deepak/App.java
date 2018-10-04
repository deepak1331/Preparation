package com.deepak;


public class App {

	public static void main(String[] args) {

		Shape shape = new Circle();
		shape.draw();
		
		shape = new Triangle();
		shape.draw();
		
		Drawing drawObject = new Drawing();
		drawObject.setShape(new Circle());
		drawObject.draw();
	}

}
