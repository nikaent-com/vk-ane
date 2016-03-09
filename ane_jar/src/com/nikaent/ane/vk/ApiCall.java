package com.nikaent.ane.vk;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class ApiCall implements FREFunction {
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		Api api = new Api();
		return api.call(arg0, arg1);
	}
}
