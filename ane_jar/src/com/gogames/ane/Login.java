package com.gogames.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.gogames.ane.activity.AuthActivity;
import com.google.gson.Gson;

import android.content.Intent;
import android.util.Log;

public class Login implements FREFunction {
	static public String[] scope;
	static public FREContext context;
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		Log.i("ANE VK", "VK login");
		String ab = "";
		try {
			ab = arg1[0].getAsString();
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FRETypeMismatchException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FREInvalidObjectException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FREWrongThreadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Log.i("ANE VK", ab);
		scope = new Gson().fromJson(ab, String[].class);
		context = arg0;
		
		Intent intent = new Intent(arg0.getActivity(), AuthActivity.class);
		arg0.getActivity().startActivityForResult(intent, 1);

		return null;
	}

}
