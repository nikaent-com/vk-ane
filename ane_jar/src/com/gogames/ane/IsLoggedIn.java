package com.gogames.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.vk.sdk.VKSdk;

public class IsLoggedIn implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		FREObject result = null;
		try {
			result = FREObject.newObject(VKSdk.isLoggedIn());
		} catch (FREWrongThreadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}

}
