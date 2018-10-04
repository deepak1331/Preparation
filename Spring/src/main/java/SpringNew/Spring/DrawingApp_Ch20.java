package SpringNew.Spring;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter20.Shape;

// @Resource, @PostConstruct, @PreDestroy

public class DrawingApp_Ch20 {

	public static void main(String[] args) {

		AbstractApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter20.xml");
		context.registerShutdownHook();

		Shape shape = (Shape) context.getBean("circle");
		shape.draw();

		shape = (Shape) context.getBean("triangle");
		shape.draw();
	}
}
