package Spring.Aop;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Spring.Aop.Chapter26.service.ShapeService;

//Spring AOP  -Introduction to Aspects
public class AppMain26 {

	public static void main(String[] args) {
		ApplicationContext ctx = new ClassPathXmlApplicationContext("spring_chapter26.xml");
		ShapeService shapeService = ctx.getBean("shapeService", ShapeService.class);

		System.out.println(shapeService.getCircle().getName());
		System.out.println(shapeService.getTriangle().getName());
	}

}
