package com.gogames.ane {
import flash.external.ExtensionContext;

public class ANE {
    private var context:ExtensionContext;

    public function ANE() {
    }

    public function init():void {
        if (!context) {
            context = ExtensionContext.createExtensionContext("com.gogames.ane", null);
            context.call("init");
        }
    }

    public function showToast(text:String):void {
        if (context)
            context.call("showToast", text);
    }

    public function showAlert(title:String, text:String):void {
        if (context)
            context.call("showAlert", title, text);
    }

    public function login(scope : Array):void {
        trace("ane login in");
        if (context) {
            trace("ane login send");
            context.call("login", JSON.stringify(scope));
            trace("ane login",scope);
            trace("ane login sended");
        }
    }

    public function logout():void {
        if (context)
            context.call("logout");
    }
}
}
