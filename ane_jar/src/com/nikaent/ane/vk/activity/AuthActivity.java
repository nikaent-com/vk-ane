package com.nikaent.ane.vk.activity;

import com.nikaent.ane.vk.AneVk;
import com.nikaent.ane.vk.Login;
import com.vk.sdk.VKAccessToken;
import com.vk.sdk.VKCallback;
import com.vk.sdk.VKSdk;
import com.vk.sdk.api.VKError;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;


public class AuthActivity extends Activity {
	
	private static String AUTH_SUCCESSFUL 	= "AUTH_SUCCESSFUL";
	private static String AUTH_FAILED 		= "FAILED";
	
	protected void onCreate(Bundle savedInstanceState) {
		AneVk.log("onCreate ApiCallActivity");
		super.onCreate(savedInstanceState);
		Activity activity = this;
		VKSdk.login(activity, Login.scope);
	}

	protected void onResume() {
		super.onResume();
	}

	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (!VKSdk.onActivityResult(requestCode, resultCode, data, new VKCallback<VKAccessToken>() {
			@Override
			public void onResult(VKAccessToken res) {
				Login.context.dispatchStatusEventAsync(AUTH_SUCCESSFUL, "");
				AneVk.log("authorization successful");
				
			}

			@Override
			public void onError(VKError error) {
				Login.context.dispatchStatusEventAsync(AUTH_FAILED, "");
				AneVk.log("authorization failed");
			}
		})) {
			super.onActivityResult(requestCode, resultCode, data);
		}

		Intent returnIntent = new Intent();
		setResult(-1, returnIntent);
		finish();
	}

	protected void onDestroy() {
		super.onDestroy();
	}
}
