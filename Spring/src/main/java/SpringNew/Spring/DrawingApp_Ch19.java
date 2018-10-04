package SpringNew.Spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter19.Shape;

// @Autowired, @Qualifier

public class DrawingApp_Ch19 {

	public static void main(String[] args) {

		ApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter19.xml");
		// context.registerShutdownHook();
		Shape shape = (Shape) context.getBean("triangle");
		shape.draw();

		Shape shape2 = (Shape) context.getBean("circle");
		shape2.draw();
		
		shape = (Shape) context.getBean("polygon");
		shape.draw();
	}
}
