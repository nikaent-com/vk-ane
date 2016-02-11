package com.gogames.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.vk.sdk.VKAccessToken;
import com.vk.sdk.VKAccessTokenTracker;
import com.vk.sdk.VKSdk;
import com.vk.sdk.util.VKUtil;

import android.content.Context;
import android.util.Log;

public class Init implements FREFunction {
	private static String TOKEN_INVALID = "TOKEN_INVALID";

	VKAccessTokenTracker vkAccessTokenTracker = new VKAccessTokenTracker() {
		@Override
		public void onVKAccessTokenChanged(VKAccessToken oldToken, VKAccessToken newToken) {
			if (newToken == null) {
				//NotificationExtensionContext.getContext().dispatchStatusEventAsync(TOKEN_INVALID, "");
				Log.i("ANE VK", "token invalid");
			}
		}
	};

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		Context toastContext = arg0.getActivity();

		vkAccessTokenTracker.startTracking(); 
		VKSdk.customInitialize(toastContext, 5282890, "5.21").withPayments();

		String[] fingerprints = VKUtil.getCertificateFingerprint(toastContext, toastContext.getPackageName());

		for (int j = 0; j < fingerprints.length; j++) {
			Log.i("fingerprint", fingerprints[j]);
		}
		Log.i("ANE VK", "VK init");

		return null;
	}

}
