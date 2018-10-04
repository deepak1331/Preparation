package AthenaSimba.AthenaSimbatest;

import java.util.Date;

/**
 * Hello world!
 *
 */
public class App 
{
    public static void main( String[] args )
    {
    	CommonUtil commonUtil = new CommonUtil();
		ErrorInfo errorInfo = new ErrorInfo();
		boolean sendNotification = false;
		short errorCount = 0;

		try {
			if (commonUtil.loadPropertyFile() != null) {

				System.out.println(
						"**********************Migration started at " + new Date() + " *************************");
				long startTime = System.currentTimeMillis();
				sendNotification = commonUtil.getPropertyByKey("sendEmailNotification").equalsIgnoreCase("on") ? true
						: false;
				errorCount = Short.parseShort(commonUtil.getPropertyByKey("errorCount"));

				if (args != null && args.length == 2) {
					errorInfo = new Sales(args[0], args[1]).automateRange();
				} else if (args.length == 0) {
					errorInfo = new Sales().automate();
				}
				
				Long endTime = System.currentTimeMillis();
				System.out.println("\nMigration Completed !!");
				System.out.println(commonUtil.calculateTotalTime("Total Time Taken :", startTime, endTime));
				System.out.println(
						"***********************Migration completed at " + new Date() + " ************************\n");

				errorInfo.setStartTime(startTime);
				errorInfo.setEndTime(endTime);

			} else {
				System.out.println("Oops!!! Unable to Find \"config.properties\" File in the Current Directory");
				System.out.println(
						"*********************** Migration Aborted on " + new Date() + " ************************\n");
			}
		} catch (Exception e) {
			e.printStackTrace();
			errorInfo.errorList.add(e.toString());
		}    
    }
}
