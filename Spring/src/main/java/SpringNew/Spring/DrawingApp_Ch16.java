package SpringNew.Spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter16.Triangle;

//BeanFactoryPostProcessor  & PropertyConfigurer 

public class DrawingApp_Ch16 {

	public static void main(String[] args) {

		ApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter16.xml");
		// context.registerShutdownHook();
		Triangle triangle = (Triangle) context.getBean("triangle");
		triangle.draw();
	}
}
