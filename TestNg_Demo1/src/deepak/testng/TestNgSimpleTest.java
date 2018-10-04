package deepak.testng;

import static org.testng.Assert.assertEquals;

import org.testng.annotations.Test;

public class TestNgSimpleTest {

	@Test
	public void areEqualString(){
		String str = "I love INDIA";
		assertEquals("I love INDIA", str);
	}
}
