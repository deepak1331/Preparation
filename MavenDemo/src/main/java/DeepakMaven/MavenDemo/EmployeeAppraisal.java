package DeepakMaven.MavenDemo;

public class EmployeeAppraisal {

	public double calculateYearlySalary(EmployeeDetails emp) {
		return emp.getMonthlySalary() * 12;
	}

	public int calculateAppraisalAmount(EmployeeDetails emp) {
		return emp.getMonthlySalary() <= 10000 ? 500 : 1000;
	}
}
