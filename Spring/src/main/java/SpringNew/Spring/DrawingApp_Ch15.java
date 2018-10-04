package SpringNew.Spring;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter15.Polygon;
import Shapes.Chapter15.Triangle;

//BeanPostProcessor 

public class DrawingApp_Ch15 {

	public static void main(String[] args) {

		AbstractApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter15.xml");
		context.registerShutdownHook();
		Triangle triangle = (Triangle) context.getBean("triangle1");
		triangle.draw();

		Polygon p = (Polygon) context.getBean("polygon");
		p.display();
	}
}
