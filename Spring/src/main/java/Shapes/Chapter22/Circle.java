package Shapes.Chapter22;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;

public class Circle implements Shape {

	private Point center;
	private MessageSource messageSource;

	public Point getCenter() {
		return center;
	}

	@Autowired
	public void setCenter(Point center) {
		this.center = center;
	}

	@Autowired
	public void setMessageSource(MessageSource messageSource) {
		this.messageSource = messageSource;
	}

	 
	public MessageSource getMessageSource() {
		return messageSource;
	}

	public void draw() {
		System.out.println(this.messageSource.getMessage("drawing.circle", null, "Default Greeting", null));
		System.out.println(this.messageSource.getMessage("drawing.point", 
				new Object[]{center.getX(), center.getY()}, "Default Point Message", null));
		
	}

}
