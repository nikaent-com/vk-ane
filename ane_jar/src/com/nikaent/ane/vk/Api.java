package com.nikaent.ane.vk;

import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.vk.sdk.api.VKError;
import com.vk.sdk.api.VKParameters;
import com.vk.sdk.api.VKRequest;
import com.vk.sdk.api.VKResponse;
import com.vk.sdk.api.VKRequest.VKRequestListener;

public class Api {
	private FREContext _context = null;
	private int requestId = 0;
	static private int counterId = 0;

	private VKRequestListener _requestListener = new VKRequestListener() {
		@Override
		public void onComplete(VKResponse response) {
			String requestData = response.responseString;

			AneVk.log("onComplete");
			AneVk.log("request in: " + requestId, getContext());
			AneVk.log(requestData);

			getContext().dispatchStatusEventAsync("response" + requestId, requestData);
			response.request.unregisterObject();
		}

		@Override
		public void onError(VKError error) {
			AneVk.log("onError");
			AneVk.log("request in: " + requestId);
			AneVk.log(error.toString());
			
			error.request.unregisterObject();
			
			int errorCode = 0;
			String errorMessage = "";
			try {
				errorCode = error.apiError.errorCode;
			} catch(Error e){
				errorCode = -1;
			}
			try {
				errorMessage = error.apiError.errorMessage;
			} catch(Error e){
				errorMessage = "error";
			}
			
			try {
			getContext().dispatchStatusEventAsync("responseError" + requestId, 
					String.format("{\"vkErrorCode\":%d, \"message\":\"%s\"}", errorCode, errorMessage));
			} catch(Error e){
				AneVk.log("error getContext()");
			}
		}

		@Override
		public void onProgress(VKRequest.VKProgressType progressType, long bytesLoaded, long bytesTotal) {
			// you can show progress of the request if you want
		}

		@Override
		public void attemptFailed(VKRequest request, int attemptNumber, int totalAttempts) {
			AneVk.log("attemptFailed");
			AneVk.log("request in: " + requestId);

			getContext().dispatchStatusEventAsync("responseFailed" + requestId,
					String.format("Attempt %d/%d failed\n", attemptNumber, totalAttempts));
			request.unregisterObject();
		}
	};

	public FREObject call(FREContext arg0, FREObject[] arg1) {
		_context = arg0;

		FREObject result = null;

		String method = Utils.getString(arg1[0]);
		String params = Utils.getString(arg1[1]);
		
		VKRequest request = null;
		if(params.length()>1){
			Map<String, Object> map = new Gson().fromJson(params, new TypeToken<Map<String, Object>>(){}.getType());
			request = new VKRequest(method, new VKParameters(map), null);
		}else{
			request = new VKRequest(method, null, null);
		}
		request.secure = false;
		request.useSystemLanguage = false;
		
		requestId = counterId++;
		
		result = doRequest(request);

		return result;
	}

	private FREObject doRequest(VKRequest request) {
		request.executeWithListener(_requestListener);
		try {
			request.registerObject();
			AneVk.log("send request id: " + requestId);
			return FREObject.newObject("" + requestId);
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
