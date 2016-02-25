package com.nikaent.ane.vk;

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
		map.put("init", new Init());
		map.put("login", new Login());
		map.put("logout", new Logout());
		map.put("apiCall", new ApiCall());
		map.put("isLoggedIn", new IsLoggedIn());
		map.put("testCaptcha", new TestCaptcha());
		return map;
	}
}
