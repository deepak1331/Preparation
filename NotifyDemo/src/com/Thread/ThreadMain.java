package com.Thread;

public class ThreadMain {

	private static boolean fileDownloaded = false;

	public static void main(String[] args) {
		new DownloadFile().start();
		new ProcessFile().start();
	}
	

	public static class DownloadFile extends Thread {
		public void run() {
			System.out.println("Initiate File download...");
			for (int i = 0; i < 10; i++) {
				try {
					Thread.sleep(500);
					System.out.println("Download in Progress...");
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
			fileDownloaded = true;
			System.out.println("Download Completed.");
		}
	}

	public static class ProcessFile extends Thread {
		public void run() {
			while (!fileDownloaded) {
				try {
					Thread.sleep(1000);
					System.out.println("Checking download status..");
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
			System.out.println("File Downloaded Successfully ! Initiate file processing...");
		}
	}


}
