package com.gogames.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.google.gson.Gson;
import com.vk.sdk.VKSdk;

import android.util.Log;

public class Login implements FREFunction {
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
		String[] scope = new Gson().fromJson(ab, String[].class);
		VKSdk.login(arg0.getActivity(), scope);

		return null;
	}

}
