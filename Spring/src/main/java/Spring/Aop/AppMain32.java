package Spring.Aop;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Spring.Aop.Chapter32.service.ShapeService;

//Spring AOP  - PointCut and WildCard expressions.
public class AppMain32 {

	public static void main(String[] args) {
		ApplicationContext ctx = new ClassPathXmlApplicationContext("spring_Chapter32.xml");
		ShapeService shapeService = ctx.getBean("shapeService", ShapeService.class);
//		shapeService.getCircle().setName("Dummy-Name");
		shapeService.getCircle().getName();
	}
}
