package SpringNew.Spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter13.Triangle;
import Shapes.Chapter13.Polygon;

//ApplicationContextAware, BeanNameAware

public class DrawingApp_Ch13 {

	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter13.xml");

		// Inheritence
		Triangle triangle = (Triangle) context.getBean("triangle1");
		triangle.draw();

		triangle = (Triangle) context.getBean("triangle2");
		triangle.draw();

		System.out.println("\nCalling Parent Polygon Bean : ");
		Polygon myPolygon = (Polygon) context.getBean("parentPolygon");
		myPolygon.display();

		System.out.println("\nCalling Polygon1 Bean (merge not used)");
		myPolygon = (Polygon) context.getBean("polygon1");
		myPolygon.display();

		System.out.println("\nCalling Polygon2 Bean (list defined as merge='true')");
		myPolygon = (Polygon) context.getBean("polygon2");
		myPolygon.display();

	}
}
