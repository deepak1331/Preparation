package DeepakMaven.MavenDemo;

import org.testng.annotations.Test;

import junit.framework.Assert;

public class TestEmployee {

	EmployeeDetails emp1 = new EmployeeDetails("Shipra Yadav",5000, 27);
	EmployeeDetails emp2 = new EmployeeDetails("Deepak Yadav",10000, 27);
	EmployeeAppraisal empBusinessLogic = new EmployeeAppraisal();
	
	@Test
	public void testcalculateAppraisalAmount(){
		Assert.assertEquals(60000.0, empBusinessLogic.calculateYearlySalary(emp1));
	}
	
	public void testCalculateAppraisalAmount(){
		Assert.assertEquals(500, empBusinessLogic.calculateAppraisalAmount(emp2));
	}
	
	
}
