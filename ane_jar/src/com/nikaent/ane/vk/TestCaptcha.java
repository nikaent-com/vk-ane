package com.nikaent.ane.vk;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.vk.sdk.api.VKRequest;
import com.vk.sdk.api.methods.VKApiCaptcha;

public class TestCaptcha implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		AneVk.log("TestCaptcha");
		doRequest(new VKApiCaptcha().force());
		return null;
	}

	private FREObject doRequest(VKRequest request) {
		request.executeWithListener(null);
		return null;
	}
}
