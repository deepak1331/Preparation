package com.deepak;

public class Drawing {
	
	Shape shape;

	public void setShape(Shape shape) {
		this.shape = shape;
	}
	
	public void draw(){
		this.shape.draw();
	}

}
