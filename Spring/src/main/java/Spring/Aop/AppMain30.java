package Spring.Aop;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Spring.Aop.Chapter30.service.ShapeService;

//Spring AOP  - PointCut and WildCard expressions.
public class AppMain30 {

	public static void main(String[] args) {
		ApplicationContext ctx = new ClassPathXmlApplicationContext("spring_chapter30.xml");
		ShapeService shapeService = ctx.getBean("shapeService", ShapeService.class);
		shapeService.getCircle().setName("Dummy-Circle");
//		shapeService.getCircle().setNameAndReturn("Dummy-Circle");
//		System.out.println(shapeService.getCircle().getName());
//		System.out.println(shapeService.getTriangle().getName());
	}

}
