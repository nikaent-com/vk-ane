package com.gogames.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.vk.sdk.VKCallback;
import com.vk.sdk.VKScope;
import com.vk.sdk.VKSdk;
import com.vk.sdk.api.VKError;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.widget.Toast;
import kabkasik.trac;

public class ShowToastFuntion implements FREFunction {
	private static final String[] sMyScope = new String[]{
            VKScope.FRIENDS,
            VKScope.WALL,
            VKScope.PHOTOS,
            VKScope.NOHTTPS,
            VKScope.MESSAGES,
            VKScope.DOCS
    };
	
	private Activity activity;
	
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		try {
            String message = arg1[0].getAsString();
            Context toastContext = arg0.getActivity();
            activity = arg0.getActivity();
            
            
            VKSdk.wakeUpSession(activity, new VKCallback<VKSdk.LoginState>() {
                @Override
                public void onResult(VKSdk.LoginState res) {
                	Log.i("onResult:", res.toString());
                        switch (res) {
                            case LoggedOut:
                            	VKSdk.login(activity, sMyScope);
                                break;
                            case LoggedIn:
                                //showLogout();
                                break;
                            case Pending:
                                break;
                            case Unknown:
                                break;
                        }
                }

                @Override
                public void onError(VKError error) {

                }
            });

			
			
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
