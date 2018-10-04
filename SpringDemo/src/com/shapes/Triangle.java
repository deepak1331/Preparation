package com.shapes;

public class Triangle {

	private int height;
	private String type;

	public Triangle(String type, int height) {
		this.height = height;
		this.type = type;
	}

	public int getHeight() {
		return height;
	}

	public String getType() {
		return type;
	}

	public void show() {
		System.out.println("Triangle Type   : " + getType());
		System.out.println("Triangle Height : " + getHeight());
	}
}
