package SpringNew.Spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter5.Triangle;

//Application Context & property initialization Example (Setter Injection)

public class DrawingApp_Ch5 {

	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter5.xml");
		Triangle triangle = (Triangle) context.getBean("triangle");
		triangle.draw();

		triangle = (Triangle) context.getBean("triangle2");
		triangle.draw();
	}

}
