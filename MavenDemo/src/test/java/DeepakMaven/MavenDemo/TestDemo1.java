package DeepakMaven.MavenDemo;

import static org.testng.Assert.assertEquals;

import org.testng.annotations.Test;

public class TestDemo1 {
	@Test
	public void checkString() {
		String str = "Softcrylic Technology Solutions Pvt. Ltd";
		assertEquals("Softcrylic Technology Solutions Pvt. Ltd", str);
	}
}
