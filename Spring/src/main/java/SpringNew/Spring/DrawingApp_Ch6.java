package SpringNew.Spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter6.Triangle;

//Application Context Example (Constructor Injection)
public class DrawingApp_Ch6 {

	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter6.xml");
		Triangle triangle = (Triangle) context.getBean("triangle1");
		triangle.draw();

		triangle = (Triangle) context.getBean("triangle2");
		triangle.draw();
		
		triangle = (Triangle) context.getBean("triangle3");
		triangle.draw();
		
		triangle = (Triangle) context.getBean("triangle4");
		triangle.draw();
	}

}
