package Spring.Aop.Chapter30.aspect;

import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;

@Aspect
public class LoggingAspect {

	
//	@Before("args(argName)")
//	public void stringArgumentAdvice(String argName){
//		System.out.println("This method takes a String argument "+argName);
//	}
//	
//	
//	@After("args(argName)")
//	public void stringArgumentAdvice(String argName){
//		System.out.println("This method takes a String argument "+argName);
//	}
	

//	@AfterReturning("args(argName)")
//	public void stringAfterReturnArgumentAdvice(String argName){
//		System.out.println("This method takes a String argument : "+argName);
//	}
//	
//	@AfterThrowing("args(argName)")
//	public void exceptionAdvice(String argName){
//		System.out.println("Exception has been thrown for : "+argName);
//	}
	
	@AfterReturning(pointcut = "args(argName)", returning = "returnString")
	public void stringAfterReturnArgumentAdvice(String argName, String returnString){
		System.out.println("This method takes a String argument : "+argName);
	}
	
	@AfterThrowing(pointcut = "args(argName)", throwing = "ex")
	public void exceptionAdvice(String argName, Exception ex){
		System.out.println("Exception has been thrown for : "+argName + "\n Exception thrown : "+ex);
	}
}
