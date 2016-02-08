package com.gogames.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

public class ShowToastFuntion implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		try {
            String message = arg1[0].getAsString();
            Context toastContext = arg0.getActivity();
            Toast toast = Toast.makeText(toastContext, message, Toast.LENGTH_SHORT);
            toast.show();
            
            Log.i("Notification Extension", "Toast OK");
            
		} catch (Exception e) {
            e.printStackTrace();
            Log.i("Notification Extension", "Toast Error");
		} 
    
		return null;
	}

}
