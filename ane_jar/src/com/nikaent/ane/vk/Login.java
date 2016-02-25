package com.nikaent.ane.vk;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.google.gson.Gson;
import com.nikaent.ane.vk.activity.AuthActivity;

import android.app.Activity;
import android.content.Intent;

public class Login implements FREFunction {
	static public String[] scope;
	static public FREContext context;
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		String stringScopes = Utils.getString(arg1[0]);
		AneVk.log(stringScopes);
		scope = new Gson().fromJson(Utils.getString(arg1[0]), String[].class);
		context = arg0;
		
		Activity activity = arg0.getActivity();
		
		Intent intent = new Intent(activity, AuthActivity.class);
		activity.startActivityForResult(intent, 1);
		
		return null;
	}

}
