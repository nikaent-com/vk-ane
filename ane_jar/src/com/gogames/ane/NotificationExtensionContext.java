package com.gogames.ane;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class NotificationExtensionContext extends FREContext {
	@Override
	public void dispose() {
		// TODO Auto-generated method stub

	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> map = new HashMap<String, FREFunction>();
		map.put("showToast", new ShowToastFuntion());
		map.put("showAlert", new ShowAlertFuntion());
		map.put("init", new Init());
		map.put("login", new Login());
		map.put("logout", new Logout());
		return map;
	}

}
