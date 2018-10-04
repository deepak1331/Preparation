package AthenaSimba.AthenaSimbatest;

import java.io.File;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;


public class SalesEtlUtil {

	private static final String FILE_PATH = System.getProperty("user.dir") + File.separator + "JRGResource"
			+ File.separator + "SalesEtl" + File.separator;
	public final String tableName = "lucktastic.sales";
	private String sql;
	HashMap<String, String> queryMapping = null;
	RedShiftDBManager redShiftDBManager = null;
	AthenaDBManager athenaDBManager = null;
	SimpleDateFormat datePattern = null;
	Date date;
	ResultSet rs = null;
	boolean result = false;
	Calendar cal = Calendar.getInstance();
	String startDate, endDate, startDay, startYear, startMonth, endYear, endMonth, endDay;

	public SalesEtlUtil() {	
		redShiftDBManager = new RedShiftDBManager();
		athenaDBManager = new AthenaDBManager();
		datePattern = new SimpleDateFormat("yyyy-MM-dd");
		date = new RedShiftDBQueries().getPreviousRSDBDate();
		cal.setTime(date);
		cal.add(Calendar.DATE, 7);
		startDate = datePattern.format(date);
		endDate = datePattern.format(cal.getTime());
		queryMapping = new CommonUtil().getAllSqlQueries(FILE_PATH);
	}

	public SalesEtlUtil(Date dateArg) {
		queryMapping = new CommonUtil().getAllSqlQueries(FILE_PATH);
		redShiftDBManager = new RedShiftDBManager();
		athenaDBManager = new AthenaDBManager();
		datePattern = new SimpleDateFormat("yyyy-MM-dd");
		this.date = dateArg;
		cal.setTime(date);
		cal.add(Calendar.DATE, 7);
		startDate = datePattern.format(date);
		endDate = datePattern.format(cal.getTime());
	}

	public ErrorInfo updateSalesTable() {
		ErrorInfo errorInfo = new ErrorInfo();
		rs = null;
		startDay = startDate.split("-")[2];
		startMonth = startDate.split("-")[1];
		startYear = startDate.split("-")[0];
		endDay = endDate.split("-")[2];
		endMonth = endDate.split("-")[1];
		endYear = endDate.split("-")[0];

		if (queryMapping.containsKey("SalesQuery.sql")) {
			sql = queryMapping.get("SalesQuery.sql").replace("startDate", startDate).replace("endDate", endDate)
					.replace("startDay", startDay).replace("startMonth", startMonth).replace("startYear", startYear)
					.replace("endDay", endDay).replace("endMonth", endMonth).replace("endYear", endYear);
		}

		StringBuilder redshiftQuery = new StringBuilder("INSERT INTO " + tableName
				+ " (lucktastic_day,platform,revenue_source,impressions,impressions_d0,clicks,installs,installs_d0,revenue) VALUES ");
		String rSQL = null;
		result = false;
		try {
			rs = athenaDBManager.getDBResultSetNew(sql);
			if (rs != null) {
				while (rs.next()) {
					redshiftQuery.append("('" + rs.getString("date") + "', '" + rs.getString("platform")
							+ "', '" + rs.getString("revenue_source") + "', " + rs.getString("impressions") + ", "
							+ rs.getString("impressions_d0") + ", " + rs.getDouble("clicks") + ", "
							+ rs.getDouble("installs") + ", " + rs.getDouble("installs_d0") + ", "
							+ rs.getDouble("revenue") + "), ");
				}
			}

			rSQL = redshiftQuery.toString().substring(0, redshiftQuery.length() - 2) + ";";

			int recordCount = getRecordCount(startDate);
			if (recordCount > 0) {
				System.out.println("Deleted Successfully: " + deleteDataIfExistsByDate(startDate));
			}
			result = redShiftDBManager.updateTable(rSQL);
		} catch (SQLException e) {
			e.printStackTrace();
			errorInfo.errorList.add(e.getMessage());
		}
		errorInfo.setStatus(result);
		return errorInfo;
	}

	public int getRecordCount(String dateString) {
		rs = null;
		rs = redShiftDBManager
				.getDBResultSet("SELECT COUNT(*) FROM " + tableName + " WHERE lucktastic_day ='" + dateString + "'");

		return new CommonUtil().fetchValueFromResultSet(rs, "count");
	}

	public boolean deleteDataIfExistsByDate(String dateString) {
		System.out.println("Deleting exisiting records for date : " + dateString);
		result = redShiftDBManager
				.updateTable("DELETE FROM " + tableName + " WHERE lucktastic_day='" + dateString + "'");
		return result;
	}
}
