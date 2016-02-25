package com.nikaent.ane.vk.activity;

import android.app.Activity;
import android.os.Bundle;
import android.view.MenuItem;

import com.nikaent.ane.vk.AneVk;
import com.vk.sdk.api.VKError;
import com.vk.sdk.api.VKRequest;
import com.vk.sdk.api.VKRequest.VKRequestListener;
import com.vk.sdk.api.VKResponse;

public class ApiCallActivity extends Activity {

	private VKRequest myRequest;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		processRequestIfRequired();
	}

	private void processRequestIfRequired() {
		VKRequest request = null;
		if (getIntent() != null && getIntent().getExtras() != null && getIntent().hasExtra("request")) {
			long requestId = getIntent().getExtras().getLong("request");
			request = VKRequest.getRegisteredRequest(requestId);
			if (request != null)
				request.unregisterObject();
		}

		if (request == null)
			return;
		myRequest = request;
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
			AneVk.log("onComplete");
			AneVk.log(response.json.toString());
		}

		@Override
		public void onError(VKError error) {
			AneVk.log("onError");
			AneVk.log(error.toString());
		}

		@Override
		public void onProgress(VKRequest.VKProgressType progressType, long bytesLoaded, long bytesTotal) {
			// you can show progress of the request if you want
		}

		@Override
		public void attemptFailed(VKRequest request, int attemptNumber, int totalAttempts) {
			AneVk.log("attemptFailed");
			AneVk.log(String.format("Attempt %d/%d failed\n", attemptNumber, totalAttempts));
		}
	};

	protected void onResume() {
		super.onResume();
	}

	protected void onDestroy() {
		super.onDestroy();
		myRequest.cancel();
		AneVk.log("On destroy");
	}

	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();

		AneVk.log("onOptionsItemSelected " + id);
		/*
		 * if (id == android.R.id.home) { finish(); return true; }
		 */

		return super.onOptionsItemSelected(item);
	}

}
