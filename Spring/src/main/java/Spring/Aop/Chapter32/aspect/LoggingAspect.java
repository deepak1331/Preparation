package Spring.Aop.Chapter32.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;

@Aspect
public class LoggingAspect {

//	@Before("allCircleMethods()")
//	public void loggingAdvice(JoinPoint joinPoint) {
//		System.out.println("A Circle method has been called : " + joinPoint.toLongString());
//	}

	@Pointcut("within(Spring.Aop.Chapter31.model.Circle)")
	public void allCircleMethods() {
	}

	@Around("allGetters()")
	public Object myAroundAdvice(ProceedingJoinPoint proceedingJoinPoint) {
		Object returnValue = null;
		try {
			System.out.println("Before Advice");
			returnValue = proceedingJoinPoint.proceed();
			System.out.println("After return");
		} catch (Throwable e) {
			System.out.println("After Throwing");
			e.printStackTrace();
		}
		System.out.println("After Finally");
		return returnValue;
	}

	@Pointcut("execution(* get*())")
	public void allGetters() {
	}
}
