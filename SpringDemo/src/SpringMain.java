import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.shapes.Rectangle;
import com.shapes.Square;
import com.shapes.Triangle;

public class SpringMain {

	public static void main(String[] args) {

		ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
		
		Triangle triangle = (Triangle) context.getBean("triangle");
		triangle.show();
		
//		Triangle triangle2 = (Triangle) context.getBean("triangle-name");
//		triangle2.show();
//		
//		Triangle triangle3 = (Triangle) context.getBean("triangle-alias");
//		triangle3.show();
		
		Rectangle rectangle = (Rectangle)context.getBean("rect");
		rectangle.draw();

		Square square = (Square) context.getBean("square");
		square.show();

	}

}
