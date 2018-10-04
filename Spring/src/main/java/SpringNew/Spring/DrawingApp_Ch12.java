package SpringNew.Spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter12.Triangle;

//ApplicationContextAware, BeanNameAware

public class DrawingApp_Ch12 {

	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter12.xml");

		// Autowire by Name
		Triangle triangle = (Triangle) context.getBean("triangle");
		triangle.draw();
		
		triangle.setApplicationContext(context);
	}

}
