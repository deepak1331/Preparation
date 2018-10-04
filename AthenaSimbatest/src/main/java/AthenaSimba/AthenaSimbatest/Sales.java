package AthenaSimba.AthenaSimbatest;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.simba.athena.shaded.apache.http.ParseException;

public class Sales {
	Date startDate = null, endDate = null;
	SimpleDateFormat datePattern = new SimpleDateFormat("MMM dd,yyyy");
	SalesEtlUtil salesEtlUtil;
	
	public Sales(){}
	
	public Sales(String dateString1, String dateString2) throws ParseException, java.text.ParseException{
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		startDate = dateFormat.parse(dateString1);
		endDate = dateFormat.parse(dateString2);
	}

	public ErrorInfo automate() {
		ErrorInfo errorInfo = new ErrorInfo();
		startDate = new RedShiftDBQueries().getPreviousRSDBDate();
		System.out.println("Initiating Sales ETL for " + datePattern.format(startDate));
		errorInfo.setDateString(datePattern.format(startDate));
		errorInfo.setReportName("Sales ETL");
		salesEtlUtil = new SalesEtlUtil();
		errorInfo = salesEtlUtil.updateSalesTable();
		String msg = "Sales ETL Completed Successfully : " + errorInfo.status;
		CommonUtil.waitFor(5);
		if (errorInfo.status)
			errorInfo.messageList.add(msg);
		else
			errorInfo.errorList.add(msg);

		System.out.println(msg);
		return errorInfo;
	}

	public ErrorInfo automateRange() throws ParseException {
		ErrorInfo errorInfo = new ErrorInfo();
		Calendar cal = Calendar.getInstance();
		cal.setTime(startDate);
		while (cal.getTime().compareTo(endDate) <= 0) {
			System.out.println("Initiating Sales ETL for " + datePattern.format(cal.getTime()));
			errorInfo.setDateString(datePattern.format(cal.getTime()));
			errorInfo.setReportName("Sales ETL");
			salesEtlUtil = new SalesEtlUtil(cal.getTime());
			errorInfo = salesEtlUtil.updateSalesTable();
			String msg = "Sales ETL Completed Successfully : " + errorInfo.status;
			if (errorInfo.status)
				errorInfo.messageList.add(msg);
			else
				errorInfo.errorList.add(msg);
			System.out.println(msg);
			
			cal.add(Calendar.DATE, 1);
		}
		return errorInfo;
	}
}
