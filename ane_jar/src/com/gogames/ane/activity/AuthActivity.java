package com.gogames.ane.activity;

import com.gogames.ane.Login;
import com.vk.sdk.VKAccessToken;
import com.vk.sdk.VKCallback;
import com.vk.sdk.VKSdk;
import com.vk.sdk.api.VKError;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

public class AuthActivity extends Activity {
	
	private static String AUTH_SUCCESSFUL 	= "AUTH_SUCCESSFUL";
	private static String AUTH_FAILED 		= "FAILED";
	
	protected void onCreate(Bundle savedInstanceState) {
		Log.w("ANE VK", "onCreate ApiCallActivity");
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
				Log.i("ANE VK", "authorization successful");
				
			}

			@Override
			public void onError(VKError error) {
				Login.context.dispatchStatusEventAsync(AUTH_FAILED, "");
				Log.i("ANE VK", "authorization failed");
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