package com.gogames.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

import android.util.Log;

public class AneVk implements FREExtension{

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

}
