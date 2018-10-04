package SpringNew.Spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter18.Shape;

// @Required Annotation - Exceptions are caught before the execution

public class DrawingApp_Ch18 {

	public static void main(String[] args) {

		ApplicationContext context = new ClassPathXmlApplicationContext("spring_Chapter18.xml");
		// context.registerShutdownHook();
		Shape shape = (Shape) context.getBean("triangle");
		shape.draw();

		shape = (Shape) context.getBean("circle");
		shape.draw();
	}
}
