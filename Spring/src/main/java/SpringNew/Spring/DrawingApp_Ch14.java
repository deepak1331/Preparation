package SpringNew.Spring;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import Shapes.Chapter14.Polygon;
import Shapes.Chapter14.Triangle;

//InitializingBean, DisposableBean , default-init/destroy-method through spring.xml

public class DrawingApp_Ch14 {

	public static void main(String[] args) {

		AbstractApplicationContext context = new ClassPathXmlApplicationContext("spring_chapter14.xml");
		context.registerShutdownHook();
		Triangle triangle = (Triangle) context.getBean("triangle1");
		triangle.draw();

		Polygon p = (Polygon) context.getBean("polygon");
		p.display();
	}
}
