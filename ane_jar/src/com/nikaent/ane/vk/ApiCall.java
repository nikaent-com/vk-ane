package com.nikaent.ane.vk;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.vk.sdk.api.VKApiConst;
import com.vk.sdk.api.VKError;
import com.vk.sdk.api.VKParameters;
import com.vk.sdk.api.VKRequest;
import com.vk.sdk.api.VKRequest.VKRequestListener;
import com.vk.sdk.api.VKResponse;

public class ApiCall implements FREFunction {

	private FREContext _context = null;

	private VKRequestListener _requestListener = new VKRequestListener() {
		@Override
		public void onComplete(VKResponse response) {
			long requestId = response.request.registerObject();
			String requestData = response.json.toString();

			AneVk.log("onComplete");
			AneVk.log("request in: " + requestId);
			AneVk.log(requestData);

			getContext().dispatchStatusEventAsync("response" + requestId, requestData);
		}

		@Override
		public void onError(VKError error) {
			long requestId = error.request.registerObject();

			AneVk.log("onError");
			AneVk.log("request in: " + requestId);
			AneVk.log(error.errorMessage);

			getContext().dispatchStatusEventAsync("responseError" + requestId, error.errorMessage);
		}

		@Override
		public void onProgress(VKRequest.VKProgressType progressType, long bytesLoaded, long bytesTotal) {
			// you can show progress of the request if you want
		}

		@Override
		public void attemptFailed(VKRequest request, int attemptNumber, int totalAttempts) {
			long requestId = request.registerObject();

			AneVk.log("attemptFailed");
			AneVk.log("request in: " + requestId);

			getContext().dispatchStatusEventAsync("responseFailed" + requestId,
					String.format("Attempt %d/%d failed\n", attemptNumber, totalAttempts));
		}
	};

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		AneVk.log("ApiCall");

		_context = arg0;

		FREObject result = null;

		String method = Utils.getString(arg1[0]);
		String params = Utils.getString(arg1[1]);
		AneVk.log("call: " + method);
		
		VKRequest request = null;
		if(params.length()>1){
			request = new VKRequest(method, VKParameters.from(VKApiConst.FIELDS, params), null);
		}else{
			request = new VKRequest(method, null, null);
		}
		request.secure = false;
		request.useSystemLanguage = false;
		
		result = doRequest(request);

		return result;
	}

	private FREObject doRequest(VKRequest request) {
		request.executeWithListener(_requestListener);
		AneVk.log("request out: " + request.registerObject());
		try {
			return FREObject.newObject("" + request.registerObject());
		} catch (FREWrongThreadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	private FREContext getContext() {
		return _context;
	}
}
