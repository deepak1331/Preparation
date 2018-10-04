package SpringNew.Spring;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter21.Shape;

// @Component - Define the role(stereotype) of the enterprise bean (@Service, @Repository - for DAO, @Controller )
// It gives extra info about the bean to the bean.

public class DrawingApp_Ch21 {

	public static void main(String[] args) {

		AbstractApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter21.xml");
		context.registerShutdownHook();

		Shape shape = (Shape) context.getBean("circle");
		shape.draw();
		
		shape = (Shape) context.getBean("polygon");
		shape.draw();
	}
}
