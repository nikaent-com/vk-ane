package com.gogames.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.vk.sdk.VKSdk;
import com.vk.sdk.util.VKUtil;

import android.content.Context;
import android.util.Log;

public class Init implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		 Context toastContext = arg0.getActivity();
		 
		 VKSdk.customInitialize(toastContext, 5282890, "5.21");
		 
		 String[] fingerprints = VKUtil.getCertificateFingerprint(toastContext, toastContext.getPackageName());
		 
		 for (int j = 0; j < fingerprints.length; j++) {
		 	Log.i("fingerprint", fingerprints[j]);
		 }
		 
		 Log.i("ANE VK", "VK init");

		return null;
	}

}
