import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.core.io.FileSystemResource;

import com.package1.Circle;
import com.package1.Triangle;

public class SpringMain {

	public static void main(String[] args) {
		
		BeanFactory factory = new XmlBeanFactory(new FileSystemResource("spring1.xml"));
		
//		ApplicationContext factory =  new ClassPathXmlApplicationContext("springContext.xml");
		Triangle triangle = (Triangle) factory.getBean("Triangle_Property");		
		triangle.draw();
		
		Circle circle = (Circle) factory.getBean("Circle");
		circle.draw();

	}

}
