package SpringNew.Spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter17.Shape;

// Coding to Interface

public class DrawingApp_Ch17 {

	public static void main(String[] args) {

		ApplicationContext context = new ClassPathXmlApplicationContext("spring_Chapter17.xml");
		// context.registerShutdownHook();
		Shape shape = (Shape) context.getBean("triangle");
		shape.draw();

		shape = (Shape) context.getBean("circle");
		shape.draw();
	}
}
