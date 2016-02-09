package com.gogames.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.vk.sdk.VKSdk;

public class Logout implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
        VKSdk.logout();
		return null;
	}

}
