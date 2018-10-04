package SpringNew.Spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter8.Triangle;

// Application Context Example (Inner beans, alias, name, id-ref Objects)

public class DrawingApp_Ch8 {

	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter8.xml");
		Triangle triangle = (Triangle) context.getBean("triangle");
		
//		//Accessing using alias
//		Triangle triangle2 = (Triangle) context.getBean("triangle-alias");
//
//		//Accessing using name
//		Triangle triangle3 = (Triangle) context.getBean("triangle-name");
		
		
		triangle.draw();
//		triangle2.draw();
//		triangle3.draw();
	}

}
