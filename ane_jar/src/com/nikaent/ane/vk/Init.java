package com.nikaent.ane.vk;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.vk.sdk.VKAccessToken;
import com.vk.sdk.VKAccessTokenTracker;
import com.vk.sdk.VKSdk;
import com.vk.sdk.util.VKUtil;

import android.content.Context;

public class Init implements FREFunction {
	VKAccessTokenTracker vkAccessTokenTracker = new VKAccessTokenTracker() {
		@Override
		public void onVKAccessTokenChanged(VKAccessToken oldToken, VKAccessToken newToken) {
			if (newToken == null) {
				//NotificationExtensionContext.getContext().dispatchStatusEventAsync(TOKEN_INVALID, "");
				AneVk.log("token invalid");
			}
		}
	};

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		Context toastContext = arg0.getActivity();

		String appVkIdStr = Utils.getString(arg1[0]);
		int appVkId = Integer.parseInt(appVkIdStr);
		AneVk.log("appVkId: "+appVkId);
		
		vkAccessTokenTracker.startTracking(); 
		VKSdk.customInitialize(toastContext, appVkId, "5.21").withPayments();

		String[] fingerprints = VKUtil.getCertificateFingerprint(toastContext, toastContext.getPackageName());

		AneVk.log("packageName: "+toastContext.getPackageName());
		
		for (int j = 0; j < fingerprints.length; j++) {
			AneVk.log("fingerprint"+fingerprints[j]);
		}

		return null;
	}

}
