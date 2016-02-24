package com.nikaent.ane.vk;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.json.JSONArray;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.nikaent.ane.vk.activity.ApiCallActivity;
import com.nikaent.ane.vk.activity.AuthActivity;
import com.vk.sdk.api.VKApi;
import com.vk.sdk.api.VKApiConst;
import com.vk.sdk.api.VKBatchRequest;
import com.vk.sdk.api.VKBatchRequest.VKBatchRequestListener;
import com.vk.sdk.api.VKError;
import com.vk.sdk.api.VKParameters;
import com.vk.sdk.api.VKRequest;
import com.vk.sdk.api.VKRequest.VKRequestListener;
import com.vk.sdk.api.VKResponse;
import com.vk.sdk.api.methods.VKApiCaptcha;
import com.vk.sdk.api.model.VKApiPhoto;
import com.vk.sdk.api.model.VKApiUser;
import com.vk.sdk.api.model.VKAttachments;
import com.vk.sdk.api.model.VKPhotoArray;
import com.vk.sdk.api.model.VKWallPostResult;
import com.vk.sdk.api.photo.VKImageParameters;
import com.vk.sdk.api.photo.VKUploadImage;
import com.vk.sdk.dialogs.VKShareDialog;
import com.vk.sdk.dialogs.VKShareDialogBuilder;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.support.annotation.Nullable;
import android.util.Log;

public class ApiCall implements FREFunction {

	public static final int MAKE_REQUEST = 1;
	public static final int USERS_GET = 2;
	public static final int FRIENDS_GET = 3;
	public static final int MESSAGES_GET = 4;
	public static final int DIALOGS_GET = 5;
	public static final int CAPTCHA_FORCE = 6;
	public static final int UPLOAD_PHOTO = 7;
	public static final int WALL_POST = 8;
	public static final int WALL_GETBYID = 9;
	public static final int TEST_VALIDATION = 10;
	public static final int TEST_SHARE = 11;
	public static final int UPLOAD_PHOTO_TO_WALL = 12;
	public static final int UPLOAD_DOC = 13;
	public static final int UPLOAD_SEVERAL_PHOTOS_TO_WALL = 14;

	public static final int TARGET_GROUP = 60479154;
	public static final int TARGET_ALBUM = 181808365;

	private Activity _activity = null;
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
		Log.i("ANE VK", "ApiCall");

		_context = arg0;
		_activity = arg0.getActivity();

		FREObject result = null;

		int method = 0;
		String params = "";
		try {
			method = arg1[0].getAsInt();
			params = arg1[1].getAsString();
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FRETypeMismatchException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FREInvalidObjectException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FREWrongThreadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		AneVk.log("call: " + method);
		switch (method) {
		case MAKE_REQUEST: {
			makeRequest();
		}
			break;
		case USERS_GET: {
			VKRequest request = VKApi.users().get(VKParameters.from(VKApiConst.FIELDS, params));
			request.secure = false;
			request.useSystemLanguage = false;
			
			result = doRequest(request);
		}
			break;
		case FRIENDS_GET:
			result = doRequest(VKApi.friends()
					.get(VKParameters.from(VKApiConst.FIELDS, params)));
			//params: "id,first_name,last_name,sex,bdate,city"
			break;
		case MESSAGES_GET:
			result = doRequest(VKApi.messages().get());
			break;
		case DIALOGS_GET:
			result = doRequest(VKApi.messages().getDialogs());
			break;
		case CAPTCHA_FORCE:
			result = doRequest(new VKApiCaptcha().force());
			break;
		case UPLOAD_PHOTO: {
			final Bitmap photo = getPhoto();
			VKRequest request = VKApi.uploadAlbumPhotoRequest(new VKUploadImage(photo, VKImageParameters.pngImage()),
					TARGET_ALBUM, TARGET_GROUP);
			request.executeWithListener(new VKRequestListener() {
				@Override
				public void onComplete(VKResponse response) {
					recycleBitmap(photo);
					VKPhotoArray photoArray = (VKPhotoArray) response.parsedModel;
					Intent i = new Intent(Intent.ACTION_VIEW,
							Uri.parse(String.format("https://vk.com/photo-%d_%s", TARGET_GROUP, photoArray.get(0).id)));
					getActivity().startActivityForResult(i, 1);
				}

				@Override
				public void onError(VKError error) {
					showError(error);
				}
			});
		}
			break;
		case WALL_POST:
			makePost(null, "Hello, friends!");
			break;
		case WALL_GETBYID:
			result = doRequest(VKApi.wall().getById(VKParameters.from(VKApiConst.POSTS, "1_45558")));
			break;
		case TEST_VALIDATION:
			result = doRequest(new VKRequest("account.testValidation"));
			break;
		case TEST_SHARE: {

		}
			break;
		case UPLOAD_PHOTO_TO_WALL: {
			final Bitmap photo = getPhoto();
			VKRequest request = VKApi.uploadWallPhotoRequest(new VKUploadImage(photo, VKImageParameters.jpgImage(0.9f)),
					0, TARGET_GROUP);
			request.executeWithListener(new VKRequestListener() {
				@Override
				public void onComplete(VKResponse response) {
					recycleBitmap(photo);
					VKApiPhoto photoModel = ((VKPhotoArray) response.parsedModel).get(0);
					makePost(new VKAttachments(photoModel));
				}

				@Override
				public void onError(VKError error) {
					showError(error);
				}
			});
		}
			break;
		case UPLOAD_DOC:
			result = doRequest(VKApi.docs().uploadDocRequest(getFile()));
			break;
		case UPLOAD_SEVERAL_PHOTOS_TO_WALL: {
			final Bitmap photo = getPhoto();
			VKRequest request1 = VKApi.uploadWallPhotoRequest(
					new VKUploadImage(photo, VKImageParameters.jpgImage(0.9f)), 0, TARGET_GROUP);
			VKRequest request2 = VKApi.uploadWallPhotoRequest(
					new VKUploadImage(photo, VKImageParameters.jpgImage(0.5f)), 0, TARGET_GROUP);
			VKRequest request3 = VKApi.uploadWallPhotoRequest(
					new VKUploadImage(photo, VKImageParameters.jpgImage(0.1f)), 0, TARGET_GROUP);
			VKRequest request4 = VKApi.uploadWallPhotoRequest(new VKUploadImage(photo, VKImageParameters.pngImage()), 0,
					TARGET_GROUP);

			VKBatchRequest batch = new VKBatchRequest(request1, request2, request3, request4);
			batch.executeWithListener(new VKBatchRequestListener() {
				@Override
				public void onComplete(VKResponse[] responses) {
					super.onComplete(responses);
					recycleBitmap(photo);
					VKAttachments attachments = new VKAttachments();
					for (VKResponse response : responses) {
						VKApiPhoto photoModel = ((VKPhotoArray) response.parsedModel).get(0);
						attachments.add(photoModel);
					}
					makePost(attachments);
				}

				@Override
				public void onError(VKError error) {
					showError(error);
				}
			});
		}
			break;
		}

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

	private void startApiCall(VKRequest request) {
		Log.w("ANE VK", "startApiCall");

		Intent i = new Intent(getActivity(), ApiCallActivity.class);
		i.putExtra("request", request.registerObject());
		getActivity().startActivityForResult(i, 1);
		Log.w("ANE VK", "startActivityForResult");
	}

	private void showError(VKError error) {
		new AlertDialog.Builder(getActivity()).setMessage(error.toString()).setPositiveButton("OK", null).show();
		if (error.httpError != null) {
			Log.w("Test", "Error in request or upload", error.httpError);
		}
	}

	private Bitmap getPhoto() {
		try {
			return BitmapFactory.decodeStream(getActivity().getAssets().open("android.jpg"));
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}

	private Activity getActivity() {
		return _activity;
	}

	private FREContext getContext() {
		return _context;
	}

	private static void recycleBitmap(@Nullable final Bitmap bitmap) {
		if (bitmap != null) {
			bitmap.recycle();
		}
	}

	private File getFile() {
		try {
			InputStream inputStream = getActivity().getAssets().open("android.jpg");
			File file = new File(getActivity().getCacheDir(), "android.jpg");
			OutputStream output = new FileOutputStream(file);
			byte[] buffer = new byte[4 * 1024]; // or other buffer size
			int read;

			while ((read = inputStream.read(buffer)) != -1) {
				output.write(buffer, 0, read);
			}
			output.flush();
			output.close();
			return file;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	private void makePost(VKAttachments attachments) {
		makePost(attachments, null);
	}

	private void makePost(VKAttachments attachments, String message) {
		/*
		 * VKRequest post =
		 * VKApi.wall().post(VKParameters.from(VKApiConst.OWNER_ID, "-" +
		 * TARGET_GROUP, VKApiConst.ATTACHMENTS, attachments,
		 * VKApiConst.MESSAGE, message));
		 * post.setModelClass(VKWallPostResult.class);
		 * post.executeWithListener(new VKRequestListener() {
		 * 
		 * @Override public void onComplete(VKResponse response) { if
		 * (isAdded()) { VKWallPostResult result = (VKWallPostResult)
		 * response.parsedModel; Intent i = new Intent(Intent.ACTION_VIEW,
		 * Uri.parse(String.format("https://vk.com/wall-%d_%s", TARGET_GROUP,
		 * result.post_id))); startActivity(i); } }
		 * 
		 * @Override public void onError(VKError error) {
		 * showError(error.apiError != null ? error.apiError : error); } });
		 */
	}

	private void makeRequest() {

		/*
		VKRequest request = new VKRequest("apps.getFriendsList", VKParameters.from("extended", 1, "type", "request"));
		request.executeWithListener(new VKRequestListener() {

			@Override
			public void onComplete(VKResponse response) {
				FREContext context = getContext();
				if (context == null || !isAdded()) {
					return;
				}
				try {
					JSONArray jsonArray = response.json.getJSONObject("response").getJSONArray("items");
					int length = jsonArray.length();
					final VKApiUser[] vkApiUsers = new VKApiUser[length];
					CharSequence[] vkApiUsersNames = new CharSequence[length];
					for (int i = 0; i < length; i++) {
						VKApiUser user = new VKApiUser(jsonArray.getJSONObject(i));
						vkApiUsers[i] = user;
						vkApiUsersNames[i] = user.first_name + " " + user.last_name;
					}
					new AlertDialog.Builder(context).setTitle(R.string.send_request_title)
							.setItems(vkApiUsersNames, new DialogInterface.OnClickListener() {

						@Override
						public void onClick(DialogInterface dialog, int which) {
							startApiCall(new VKRequest("apps.sendRequest",
									VKParameters.from("user_id", vkApiUsers[which].id, "type", "request")));
						}
					}).create().show();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
		*/

	}
}
