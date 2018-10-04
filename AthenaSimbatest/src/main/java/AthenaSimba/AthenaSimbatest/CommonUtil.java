package AthenaSimba.AthenaSimbatest;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Properties;

public class CommonUtil {


	private static final String APPLICATION_NAME = "Google Sheets API Jump Ramp Games";

	/** Directory to store user credentials for this application. */
	private static final java.io.File DATA_STORE_DIR = new java.io.File(System.getProperty("user.home"),
			".credentials/sheets.googleapis.com-java-quickstart.json");

	/** Global instance of the {@link FileDataStoreFactory}. */
//	private static FileDataStoreFactory DATA_STORE_FACTORY;
//
//	/** Global instance of the JSON factory. */
//	private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
//
//	/** Global instance of the HTTP transport. */
//	private static HttpTransport HTTP_TRANSPORT;
//
//	private static final List<String> SCOPES = Arrays.asList(SheetsScopes.SPREADSHEETS);
//
	Properties props;
//	public static ValueRange response;
//	public static UpdateValuesResponse request;
//	ArrayList<File> filesInResource = new ArrayList<File>();
//	static {
//		try {
//			HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
//			DATA_STORE_FACTORY = new FileDataStoreFactory(DATA_STORE_DIR);
//		} catch (Throwable t) {
//			t.printStackTrace();
//			System.exit(1);
//		}
//	}

	public CommonUtil() {
		loadPropertyFile();
	}

	public Hashtable<Object, Object> loadPropertyFile() {

		String path = System.getProperty("user.dir") + File.separator + "config.properties";
		props = new Properties();
		try {
			InputStream inputStream = new FileInputStream(path);
			props.load(inputStream);
		} catch (Exception exception) {
			return null;
		}
		return props;

	}

	public static void waitFor(int seconds) {
		try {
			Thread.sleep(1000 * seconds);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

	ArrayList<File> filesInResource = new ArrayList<File>();

	public HashMap<String, String> getAllSqlQueries(String path) {
		System.out.println("Loading SQL Files from Repository : ");
		CommonUtil commonUtil = new CommonUtil();
		HashMap<String, String> mapping = new HashMap<String, String>();
		try {
			listAllFiles(path);
			if (filesInResource != null && filesInResource.size() > 0) {
				System.out.println(
						"Total files found in the " + path + " resource Directory = " + filesInResource.size());
				String query = "";

				for (File file : filesInResource) {
					if (file != null) {
						query = commonUtil.ReadFileLineByLine(file.getAbsolutePath());
						if (!query.isEmpty()) {
							// System.out.println("Loading : " +
							// file.getName().toUpperCase());
							mapping.put(file.getName(), query);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mapping;
	}

	public int fetchValueFromResultSet(ResultSet rs, String columnName) {
		int result = 0;
		String fieldName = "count";
		if (columnName != null) {
			if (columnName.trim().length() > 0) {
				fieldName = columnName;
			}
		}
		if (rs != null) {
			try {
				while (rs.next()) {
					result = rs.getInt(fieldName);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return result;
	}

	public String ReadFileLineByLine(String path) {
		StringBuilder result = new StringBuilder();
		BufferedReader br = null;
		FileInputStream fstream = null;
		String str = "";
		try {
			fstream = new FileInputStream(path);
			br = new BufferedReader(new InputStreamReader(fstream));
			while ((str = br.readLine()) != null) {
				if (!str.trim().startsWith("--")) {
					result.append(str + " ");
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (br != null)
					br.close();
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
		return result.toString();
	}

	public ArrayList<File> listAllFiles(String directoryName) {
		File directory = new File(directoryName);
		ArrayList<File> files = new ArrayList<File>();
		File[] fileList = directory.listFiles();
		for (File file : fileList) {
			if (file.isFile()) {
				if (file != null) {
					files.add(file);
				}
			} else if (file.isDirectory()) {
				listAllFiles(file.getAbsolutePath());
			}
		}
		if (files.size() > 0)
			filesInResource.addAll(files);

		return files;
	}

	public String getPropertyByKey(String Key) {
		return props.getProperty(Key);
	}

	public String calculateTotalTime(String msg, Long startTime, Long endTime) {
		String timeTaken = (endTime - startTime) / 60000 + " mins " + ((endTime - startTime) % 60000) / 1000 + " secs";
		if (msg != null) {
			if (msg.length() > 0) {
				timeTaken = msg + " " + timeTaken;
			}
		}
		return timeTaken;
	}

}
