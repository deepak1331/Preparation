package Spring.Aop;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Spring.Aop.Chapter31.service.ShapeService;

//Spring AOP  - PointCut and WildCard expressions.
public class AppMain31 {

	public static void main(String[] args) {
		ApplicationContext ctx = new ClassPathXmlApplicationContext("spring_chapter31.xml");
		ShapeService shapeService = ctx.getBean("shapeService", ShapeService.class);
		shapeService.getCircle().setName("Dummy-Name");
//		shapeService.getCircle().setNameAndReturn("Dummy-Circle");
	}
}
