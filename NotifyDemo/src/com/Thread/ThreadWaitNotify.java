package com.Thread;

public class ThreadWaitNotify {

	private static Object monitor = new Object();
	private static boolean fileDownloaded = false;

	public static void main(String[] args) {
		new DownloadFile().start();
		new ProcessFile().start();
	}

	public static class  ProcessFile extends Thread {
		public void run() {
			while (!fileDownloaded) {
				synchronized (monitor) {
					try {
						monitor.wait();
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
				System.out.println("File Downloaded Successfully ! Initiate file processing...");
			}
		}
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
			System.out.println("Download completed");
			synchronized (monitor) {
				monitor.notifyAll();
			}
		}
	}
}
