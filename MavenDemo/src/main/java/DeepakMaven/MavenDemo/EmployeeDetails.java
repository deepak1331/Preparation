package DeepakMaven.MavenDemo;

public class EmployeeDetails {
	
	private String name;
	private double monthlySalary;
	private int age;

	public EmployeeDetails(String name, double monthlySalary, int age) {
		this.name = name;
		this.monthlySalary = monthlySalary;
		this.age = age;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public double getMonthlySalary() {
		return monthlySalary;
	}

	public void setMonthlySalary(double monthlySalary) {
		this.monthlySalary = monthlySalary;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

}
