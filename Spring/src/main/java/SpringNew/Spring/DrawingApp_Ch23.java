package SpringNew.Spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter23.Shape;

// Message Source Interface  - handy to use internationalization by using separate Locale properties files.

public class DrawingApp_Ch23 {

	public static void main(String[] args) {

		ApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter23.xml");

		Shape shape = (Shape) context.getBean("circle");
		shape.draw();

	}
}
