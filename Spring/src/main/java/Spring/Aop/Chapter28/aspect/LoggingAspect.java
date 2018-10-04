package Spring.Aop.Chapter28.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;

@Aspect
public class LoggingAspect {

	@Before("execution (public String Spring.Aop.Chapter28.model.Circle.getName())")
//	@Before("allCircleMethodsWithin() && allGetters()")
	public void loggingAdvice(){
		System.out.println("Advice called for getName() method");
	}
	
	
//	@Before("allGetters()")
//	public void loggingAdvice(){
//		System.out.println("Advice called for getName() method");
//	}
//	
//	@Before("allGetters()")
//	public void secondAdvice(){
//		System.out.println("Second advice executed");
//	}
//	
//	@Pointcut("execution (public * get*())")
//	public void allGetters(){}
	
	//Applies only on Circle's getName()
//	@Before("execution(public String Spring.Aop.Chapter28.model.Circle.getName())")
//	public  void loggingAdvice() {		
//		System.out.println("Advice run. Get Method called.");
//
//	}
//	
//	@Before("execution(public String Spring.Aop.Chapter28.model.Circle.getName())")
//	public  void loggingAdvice(JoinPoint joinPoint) {		
//		System.out.println("Advice run. Get Method called." + joinPoint.toLongString());
//
//	}
//	
	@Before("args(String)")
	public void stringArgumentAdvice(){
		System.out.println("This method takes a String argument.");
	}
//	
	@Before("args(argName)")
	public void stringArgumentAdvice(String argName){
		System.out.println("This method takes a String having value : "+argName);
	}
	
//	Applies to any methods starting with get
//	@Before("allGetters()")
//	public  void loggingAdvice() {		
//		System.out.println("Advice run. Get Method called.");
//
//	}
//	
//	@Before("allGetters()")
//	public  void secondAdvice() {		
//		System.out.println("Second Advice run. Get Method called.");
//	}
//	
//	@Before("allCircleMethods()")
//	public  void allMethodsTestAdvice() {		
//		System.out.println("allMethodsTestAdvice Advice run. Get Method called.");
//	}
//	
//	@Before("allCircleMethodsWithin()")
//	public  void allMethodsTestWithin() {		
//		System.out.println("allMethodsTestWithin Advice run. Get Method called.");
//	}
//	
	@Pointcut("execution(* get*())")
	public void allGetters(){}
	
//	@Pointcut("execution(** Spring.Aop.Chapter28.model.Circle.*(..))")
//	public void allCircleMethods(){}
//	
	//Applies to all the methods of class Circle
	@Pointcut("within(Spring.Aop.Chapter28.model.Circle)")
	public void allCircleMethodsWithin(){}

	//Applies to all the methods of all the classes inside model package
//	@Pointcut("within(Spring.Aop.Chapter28.model.*)")
//	public void allModelMethods(){}

//	Applies to all the methods of all the classes inside model package and its sub package
	@Pointcut("within(Spring.Aop.Chapter28.model..*)")
	public void allModelMethods(){}


}
