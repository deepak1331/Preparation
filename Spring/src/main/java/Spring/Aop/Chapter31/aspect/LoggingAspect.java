package Spring.Aop.Chapter31.aspect;

import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;

@Aspect
public class LoggingAspect {

	// @Before("allCircleMethods()")
	// public void loggingAdvice(JoinPoint joinPoint) {
	// System.out.println("A Circle method has been called : " +
	// joinPoint.toLongString());
	// }

	// @Before("args(name)")
	// public void loggingAdvice(String name) {
	// System.out.println("A method which takes String argument has been called.
	// Value is : " + name);
	// }

	// Runs after the setter is called (whether is was successful or not) in
	// this use case
	// @After("args(name)")
	// public void loggingAdviceAfter(String name) {
	// System.out.println("A method which takes String argument has been called.
	// Value was : " + name);
	// }

	// Runs after the setter is called successfully in this usecase
//	@AfterReturning("args(name)")
//	public void loggingAdviceAfter(String name) {
//		System.out.println("A method which takes String argument has been called. Value was : " + name);
//	}

	// Executed when an exception is thrown
//	@AfterThrowing("args(name)")
//	public void exceptionAdvice(String name) {
//		System.out.println("An Exception is thrown");
//	}
	
	@AfterThrowing(pointcut="args(name)", throwing="ex")
	public void exceptionAdvice(String name, RuntimeException ex) {
		System.out.println("An Exception is thrown : " + ex);
	}

	@AfterReturning(pointcut="args(name)", returning="returnString")
//	public void loggingAdviceAfter(String name, String returnString) {	
	//Use object type as return type to capture any kind of datatype
	public void loggingAdviceAfter(String name, Object returnString) { 
		System.out.println("A method which takes String argument has been called. Value was : " + name+ "\nOutput value is : "+returnString);
	}
	
	@Pointcut("within(Spring.Aop.Chapter31.model.Circle)")
	public void allCircleMethods() {
	}

}
