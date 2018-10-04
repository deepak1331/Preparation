package AthenaSimba.AthenaSimbatest;

import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

public class RedShiftDBQueries {

	RedShiftDBManager redShiftDBManager = new RedShiftDBManager();
	CommonUtil commonUtil = new CommonUtil();
	ResultSet rs = null;
	int total;
	int noOfPrevDays = 0;
	String sql = null;

	public RedShiftDBQueries() {
		this.noOfPrevDays = Integer.parseInt(commonUtil.getPropertyByKey("noOfPrevDays"));
	}

	/**
	 * Get Redshift Date from DB
	 * 
	 * @return DB Date
	 * 
	 * 
	 */
	public Date getPreviousRSDBDate() {
		// Get Previous Day Date from Redshift DB
		Date dBDate = null;
		sql = "SELECT trunc(SYSDATE-" + noOfPrevDays + ");";
		rs = redShiftDBManager.getDBResultSet(sql);
		try {
			while (rs.next()) {
				dBDate = rs.getDate(1);
			}
		} catch (Exception e) {
			System.out.println(e);
			e.printStackTrace();
		}
		return dBDate;
	}

	/**
	 * Get Redshift previous month Date from DB
	 * 
	 * @return DB Date
	 * 
	 * 
	 */
	public Date getPreviousMonthRSDBDate() {
		Date dBDate = null;
		sql = "SELECT to_char({current_date} - INTERVAL '1 MONTH " + noOfPrevDays + " DAY ',  'YYYY-MM-DD');";
		rs = redShiftDBManager.getDBResultSet(sql);
		try {
			if (rs.next()) {
				dBDate = rs.getDate(1);
			}
		} catch (Exception e) {
			System.out.println(e);
			e.printStackTrace();
		}
		return dBDate;
	}

	public boolean dropViewOrTable(String entityName, String name) {
		sql = "DROP " + entityName + " IF EXISTS " + name + " CASCADE;";
		return redShiftDBManager.updateTable(sql);
	}

	

	public ArrayList<Integer> getNewDauByOs(Date date) {
		SimpleDateFormat pattern = new SimpleDateFormat("yyyy-MM-dd");
		ArrayList<Integer> result = new ArrayList<Integer>();
		String startDate = pattern.format(date);
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.add(Calendar.DATE, 1);
		String endDate = pattern.format(cal.getTime());
		String tableName = "Rprofile_opp_" + new SimpleDateFormat("yyyy_MM_dd").format(date);

		sql = "SELECT * FROM (SELECT COUNT(DISTINCT P.UserID) AS android_new FROM lucktastic.profile P JOIN lucktastic."
				+ tableName
				+ " R ON P.UserID = R.UserID WHERE deviceos LIKE 'Android%' AND R.isFulfilled = 1 AND P.CreateDate BETWEEN '"
				+ startDate + " 05:00:00' AND '" + endDate
				+ " 04:59:59' ) a JOIN (SELECT COUNT(DISTINCT P.UserID) AS iOS_new FROM lucktastic.profile P JOIN lucktastic."
				+ tableName
				+ " R ON P.UserID = R.UserID WHERE deviceos LIKE 'iOS%' AND R.isFulfilled = 1 AND P.CreateDate BETWEEN '"
				+ startDate + " 05:00:00' AND '" + endDate + " 04:59:59') b ON 1=1";
		rs = redShiftDBManager.getDBResultSet(sql);
		try {
			while (rs.next()) {
				result.add(rs.getInt(1));
				result.add(rs.getInt(2));
			}
		} catch (Exception e) {
			System.out.println(e);
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * Get Previous Month Day DailyReports table from RedShift DB using Report
	 * Types.
	 * 
	 * @return count
	 * @param ReportTypes
	 */
	
	/**
	 * Get Previous Day Impresions and Total Installs values form
	 * xcampaign_zmeta_history table from RedShift DB using Campaign Ids
	 * 
	 * @param campaignIds
	 * @return
	 */
	public ArrayList<Integer> getImpressionsAndTotalInstalls(String campaignIds) {

		// Get Previous Day DailyReports from Redshift DB using Report Types

		ArrayList<Integer> impressionsAndTotals = new ArrayList<Integer>();
		sql = "SELECT SUM(view) AS impressions,SUM(complete) AS installs FROM lucktastic.xcampaign_zmeta_history WHERE timestamp=to_char({current_date} - INTERVAL '"
				+ noOfPrevDays + " DAY'  ,'YYYY-MM-DD') AND campaign_id IN  (" + campaignIds + ");";
		rs = redShiftDBManager.getDBResultSet(sql);
		try {
			if (rs.next()) {
				impressionsAndTotals.add(rs.getInt("impressions"));
				impressionsAndTotals.add(rs.getInt("installs"));
			} else {
				impressionsAndTotals.add(0);
				impressionsAndTotals.add(0);
			}
		} catch (Exception e) {
			System.out.println(e);
			e.printStackTrace();
		}
		return impressionsAndTotals;
	}


	public Integer getTotalDau(Date dBDate) {
		total = 0;
		String tableName = "Rprofile_opp_" + new SimpleDateFormat("yyyy_MM_dd").format(dBDate);
		sql = "SELECT COUNT( DISTINCT ( R.UserID ) )  as total	FROM  lucktastic." + tableName
				+ " R INNER JOIN  lucktastic.profile P ON R.UserID = P.UserID WHERE R.isFulfilled = 1;";
		rs = redShiftDBManager.getDBResultSet(sql);
		try {
			if (rs.next()) {
				total = rs.getInt("total");
			}
		} catch (Exception e) {
			System.out.println(e);
			e.printStackTrace();
		}
		return total;
	}

	public boolean grantAccess(String tableName, String userName, String accesssType) {
		if (accesssType != null) {
			sql = "GRANT " + accesssType + " ON " + tableName + " TO " + userName;
		} else {
			sql = "GRANT SELECT ON " + tableName + " TO " + userName;
		}
		System.out.println(sql);
		return redShiftDBManager.executeQuery(sql);
	}
}
