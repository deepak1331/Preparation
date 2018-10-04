package AthenaSimba.AthenaSimbatest;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class RedShiftDBManager {


	/**
	 * Connect to RedShift DB using Configuration property file.
	 * 
	 * @return Connection
	 */
	public static Connection connection = null;
	public short count = 1;

	public Connection getDBConnection() {
		Connection conn = null;
		try {
			CommonUtil commonUtil = new CommonUtil();

			Class.forName("com.amazon.redshift.jdbc4.Driver");
			conn = DriverManager.getConnection(commonUtil.getPropertyByKey("dbURL"),
					commonUtil.getPropertyByKey("MasterUsername"), commonUtil.getPropertyByKey("MasterUserPassword"));
			// System.out.println("Creating RedShift connection no. : " +
			// count++);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return conn;
	}

	/**
	 * Connect to RedShift DB using Configuration property file.
	 * 
	 * @return ResultSet
	 * @param sqlQuery
	 *            String
	 */

	public ResultSet getDBResultSet(String sqlQuery) {
		Statement stmt = null;
		ResultSet resultSet = null;
		try {
			if (connection == null)
				connection = getDBConnection();
			stmt = connection.createStatement();
			resultSet = stmt.executeQuery(sqlQuery);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return resultSet;
	}

	public boolean updateTable(String query) {
		Connection conn = null;
		Statement stmt = null;
		boolean isUpdated = true;
		try {
			if (conn == null) {
				conn = getDBConnection();
			}
			stmt = conn.createStatement();
			stmt.execute(query);
		} catch (Exception ex) {
			ex.printStackTrace();
			isUpdated = false;
		}
		return isUpdated;
	}

	public boolean executeQuery(String query) {
		Connection conn = null;
		Statement stmt = null;
		boolean isUpdated = true;
		try {
			if (conn == null) {
				conn = getDBConnection();
			}
			stmt = conn.createStatement();
			stmt.execute(query);
		} catch (Exception ex) {
			ex.printStackTrace();
			isUpdated = false;
		}
		return isUpdated;
	}

	public ResultSet getDBResultSetNew(String sqlQuery) throws SQLException {
		Statement stmt = null;
		ResultSet resultSet = null;

		if (connection == null)
			connection = getDBConnection();
		stmt = connection.createStatement();
		resultSet = stmt.executeQuery(sqlQuery);

		return resultSet;
	}

	public boolean updateTableNew(String query) throws SQLException {
		Connection conn = null;
		Statement stmt = null;
		boolean isUpdated = true;
		if (conn == null) {
			conn = getDBConnection();
		}
		stmt = conn.createStatement();
		stmt.execute(query);

		return isUpdated;
	}
}