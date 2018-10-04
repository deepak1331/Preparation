package SpringNew.Spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter10.PointName;

// Autowire : initializing the list object in class 

//Autowire=byType and Autowire=constructor , to achieve this we should have only one bean per type in the .xml file

public class DrawingApp_Ch10 {

	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter10.xml");

		// Autowire by Name
		// Triangle triangle = (Triangle) context.getBean("triangle");
		// triangle.draw();

		// Autowire by Type
		PointName point = (PointName) context.getBean("userPoint");
		point.draw();

		// Autowire by Type
		PointName point2 = (PointName) context.getBean("userPoint2");
		point2.draw();
	}

}
