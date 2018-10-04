package AthenaSimba.AthenaSimbatest;


import java.util.ArrayList;

/**
 * @author deepakr
 *
 */
public class ErrorInfo {

	public String reportName;
	public String dateString;	
	public String reportSpreadSheetId;
	public Long startTime;
	public Long endTime;
	public ArrayList<String> errorList;
	public ArrayList<String> messageList;
	public boolean status;

	public ErrorInfo() {
		errorList = new ArrayList<String>();
		messageList = new ArrayList<String>();
	}

	public ArrayList<String> getMessageList() {
		return messageList;
	}

	public void setMessageList(ArrayList<String> messageList) {
		this.messageList = messageList;
	}

	public ArrayList<String> getErrorList() {
		return errorList;
	}

	public void setErrorList(ArrayList<String> errorList) {
		this.errorList = errorList;
	}

	public String getReportName() {
		return reportName;
	}

	public void setReportName(String reportName) {
		this.reportName = reportName;
	}

	public String getDateString() {
		return dateString;
	}

	public void setDateString(String dateString) {
		this.dateString = dateString;
	}

	public String getReportSpreadSheetId() {
		return reportSpreadSheetId;
	}

	public void setReportSpreadSheetId(String reportSpreadSheetId) {
		this.reportSpreadSheetId = reportSpreadSheetId;
	}

	public Long getStartTime() {
		return startTime;
	}

	public void setStartTime(Long startTime) {
		this.startTime = startTime;
	}

	public Long getEndTime() {
		return endTime;
	}

	public void setEndTime(Long endTime) {
		this.endTime = endTime;
	}

	public boolean isStatus() {
		return status;
	}

	public void setStatus(boolean status) {
		this.status = status;
	}
	
}
