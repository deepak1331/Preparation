package SpringNew.Spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter7.Triangle;

// Application Context Example (Injecting Objects, using ref )

public class DrawingApp_Ch7 {

	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter7.xml");
		Triangle triangle = (Triangle) context.getBean("triangle1");
		triangle.draw();
	}

}
