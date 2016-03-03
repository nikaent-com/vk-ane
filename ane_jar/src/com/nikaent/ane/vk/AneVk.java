package com.nikaent.ane.vk;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

import android.util.Log;

public class AneVk implements FREExtension{

	public static String TAG = "ANE VK";
	public static boolean _isDebug = false;
	
	
	@Override
	public FREContext createContext(String arg0) {
		return new NotificationExtensionContext();
	}

	@Override
	public void dispose() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void initialize() {
		Log.i("Notification Extension", "Toast OK");
		// TODO Auto-generated method stub
		
	}
	
	public static void log(String message){
		if(_isDebug)
			Log.i(AneVk.TAG, message);
	}
	public static void log(String message, FREContext context){
		context.dispatchStatusEventAsync("log", message);
		log(message);
	}

}
