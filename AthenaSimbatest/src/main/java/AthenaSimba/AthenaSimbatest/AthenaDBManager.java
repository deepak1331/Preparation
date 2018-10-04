package AthenaSimba.AthenaSimbatest;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import java.util.Properties;



public class AthenaDBManager {

	private static final String USER_HOME = System.getProperty("user.home");
	public static Connection conn = null;
	static short count = 1;

	public Connection getDBConnection() {
		CommonUtil commonUtil = new CommonUtil();
//		System.out.println("Creating Athena Connection no. : " + count++);
//		try {
//			Class.forName("com.amazonaws.athena.jdbc.AthenaDriver");
		System.out.println("Creating Athena 2.0.2 Connection no. : " + count++);
		try {
			Class.forName("com.simba.athena.jdbc.Driver");
			Properties info = new Properties();
			String accessKey = commonUtil.getPropertyByKey("athenaAccessKey");
			String secretKey = commonUtil.getPropertyByKey("athenaSecretKey");
			String s3StagingDirectory = commonUtil.getPropertyByKey("s3StagingDir");
			String athenaUrl = commonUtil.getPropertyByKey("athenaUrl");
			info.put("user", accessKey);
			info.put("password", secretKey);
			info.put("s3_staging_dir", s3StagingDirectory);
			info.put("log_path", new java.io.File(USER_HOME, ".athena/athenajdbc.log"));
			info.put("log_level", "INFO");
			if (conn == null) {
				conn = (Connection) DriverManager.getConnection(athenaUrl, info);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return conn;
	}

	public ResultSet getDBResultSetNew(String sqlQuery) throws SQLException {
		Statement stmt = null;
		ResultSet resultSet = null;
		if (conn == null) {
			conn = getDBConnection();
		}
		stmt = conn.createStatement();
		resultSet = stmt.executeQuery(sqlQuery);
		return resultSet;
	}
}
