package Shapes.Chapter6;

public class Triangle {

	private String type;
	private int height;

	private Triangle(String type) {
		System.out.println("Constructor called");
		this.type = type;
	}

	public Triangle(int height) {

		this.height = height;
	}

	public Triangle(String type, int height) {
		this.type = type;
		this.height = height;
	}

	public String getType() {
		return type;
	}

	public int getHeight() {
		return height;
	}

	public void draw() {
		System.out.println(getType() + " Triangle Drawn with height : " + getHeight() + " units");
	}

}
