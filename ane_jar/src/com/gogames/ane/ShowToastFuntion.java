package com.gogames.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.vk.sdk.VKScope;
import com.vk.sdk.VKSdk;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

public class ShowToastFuntion implements FREFunction {
	 private static final String[] sMyScope = new String[]{
	            VKScope.FRIENDS,
	            VKScope.WALL,
	            VKScope.PHOTOS,
	            VKScope.NOHTTPS,
	            VKScope.MESSAGES,
	            VKScope.DOCS
	    };
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		try {
			VKSdk.initialize(arg0.getActivity());
			VKSdk.login(arg0.getActivity(), sMyScope);
			
            String message = arg1[0].getAsString();
            Context toastContext = arg0.getActivity();
            Toast toast = Toast.makeText(toastContext, message, Toast.LENGTH_SHORT);
            toast.show();
            
            Log.i("Notification Extension", "Toast OK");
            
		} catch (Exception e) {
            e.printStackTrace();
            Log.i("Notification Extension", "Toast Error");
		} 
    
		return null;
	}

}
