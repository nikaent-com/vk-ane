package com.gogames.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.vk.sdk.VKScope;
import com.vk.sdk.VKSdk;

import android.util.Log;

public class Login implements FREFunction {
	private static final String[] sMyScope = new String[] { 
			VKScope.FRIENDS, VKScope.WALL, VKScope.PHOTOS,
			VKScope.NOHTTPS, VKScope.MESSAGES, VKScope.DOCS };

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		VKSdk.login(arg0.getActivity(), sMyScope);

		Log.i("ANE VK", "VK login");

		return null;
	}

}
