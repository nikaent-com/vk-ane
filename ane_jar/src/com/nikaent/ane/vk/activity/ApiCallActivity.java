package com.nikaent.ane.vk.activity;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.nikaent.ane.vk.AneVk;
import com.vk.sdk.VKSdk;
import com.vk.sdk.api.VKError;
import com.vk.sdk.api.VKRequest;
import com.vk.sdk.api.VKRequest.VKRequestListener;
import com.vk.sdk.api.VKResponse;

public class ApiCallActivity extends Activity {

	private VKRequest myRequest;

	protected void onCreate(Bundle savedInstanceState) {
		Log.w("ANE VK", "onCreate ApiCallActivity");
		super.onCreate(savedInstanceState);
		processRequestIfRequired();
	}

	private void processRequestIfRequired() {
		VKRequest request = null;

		Log.i("ANE VK", "processRequestIfRequired");
		if (getIntent() != null && getIntent().getExtras() != null && getIntent().hasExtra("request")) {
			long requestId = getIntent().getExtras().getLong("request");
			request = VKRequest.getRegisteredRequest(requestId);
			if (request != null)
				request.unregisterObject();
		}

		if (request == null)
			return;
		myRequest = request;
		Log.i("ANE VK", "executeWithListener");
		request.executeWithListener(mRequestListener);
	}

	protected void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
		if (myRequest != null) {
			outState.putLong("request", myRequest.registerObject());
		}
	}

	protected void onRestoreInstanceState(Bundle savedInstanceState) {
		super.onRestoreInstanceState(savedInstanceState);

		long requestId = savedInstanceState.getLong("request");
		myRequest = VKRequest.getRegisteredRequest(requestId);
		if (myRequest != null) {
			myRequest.unregisterObject();
			myRequest.setRequestListener(mRequestListener);
		}
	}

	VKRequestListener mRequestListener = new VKRequestListener() {
		@Override
		public void onComplete(VKResponse response) {
			Log.i(AneVk.TAG, "onComplete");
			Log.i(AneVk.TAG, response.json.toString());
		}

		@Override
		public void onError(VKError error) {
			Log.i(AneVk.TAG, "onError");
			Log.i(AneVk.TAG, error.toString());
		}

		@Override
		public void onProgress(VKRequest.VKProgressType progressType, long bytesLoaded, long bytesTotal) {
			// you can show progress of the request if you want
		}

		@Override
		public void attemptFailed(VKRequest request, int attemptNumber, int totalAttempts) {
			Log.i(AneVk.TAG, "attemptFailed");
			Log.i(AneVk.TAG, String.format("Attempt %d/%d failed\n", attemptNumber, totalAttempts));
		}
	};

	protected void onResume() {
		super.onResume();
	}

	protected void onDestroy() {
		super.onDestroy();
		myRequest.cancel();
		Log.d(AneVk.TAG, "On destroy");
	}

	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();

		Log.i(AneVk.TAG, "onOptionsItemSelected " + id);
		/*
		 * if (id == android.R.id.home) { finish(); return true; }
		 */

		return super.onOptionsItemSelected(item);
	}

}
