package SpringNew.Spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter22.Shape;

// Message Source Interface  - handy to use internationalization by using separate Locale properties files.

public class DrawingApp_Ch22 {

	public static void main(String[] args) {

		ApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter22.xml");

		Shape shape = (Shape) context.getBean("circle");
		shape.draw();
		System.out.println(context.getMessage("welcome", null, "Default Greeting", null));

		System.out.println(context.getMessage("greeting", null, "Default Greeting", null));

	}
}
