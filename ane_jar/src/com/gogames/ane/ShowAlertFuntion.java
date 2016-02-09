package com.gogames.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.vk.sdk.VKSdk;
import com.vk.sdk.util.VKUtil;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.util.Log;

public class ShowAlertFuntion implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		 try {
			 String[] fingerprints = VKUtil.getCertificateFingerprint(arg0.getActivity(), arg0.getActivity().getPackageName());
			 Log.i("kabkasik", arg0.getActivity().getPackageName());
			 Log.i("kabkasik", fingerprints.toString());
			 
			 VKSdk.initialize(arg0.getActivity()).withPayments();
			 
             String alertTitle = arg1[0].getAsString();
             String alertText = arg1[1].getAsString();
             
             AlertDialog.Builder alertBuilder = new AlertDialog.Builder(arg0.getActivity());

             alertBuilder.setTitle(alertTitle);
             alertBuilder.setMessage(alertText);
             
             alertBuilder.setNeutralButton("OK", new DialogInterface.OnClickListener() {
                     public void onClick(DialogInterface dialog, int id) {
                             // close dialog
                     }
             });
             
             AlertDialog alertDialog = alertBuilder.create();
             alertDialog.show();
             
             Log.i("Notification Extension", "Alert OK");
             
		 } catch (Exception e) {
             e.printStackTrace();
             Log.i("Notification Extension", "Alert Error");
		 } 
		 return null;
	}

}
