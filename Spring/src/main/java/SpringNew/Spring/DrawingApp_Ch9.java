package SpringNew.Spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter9.Triangle;

// initializing the list object in class

public class DrawingApp_Ch9 {

	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter9.xml");
		Triangle triangle = (Triangle) context.getBean("triangle");
		triangle.draw();
	}

}
