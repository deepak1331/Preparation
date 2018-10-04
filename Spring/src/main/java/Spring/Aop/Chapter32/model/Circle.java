package Spring.Aop.Chapter32.model;

public class Circle {

	private String name;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
		System.out.println("Circle's Setter called.");
	}

	public String setNameAndReturn(String name) {
		this.name = name;
		System.out.println("Circle's Setter called.");
		return name;
	}

}
