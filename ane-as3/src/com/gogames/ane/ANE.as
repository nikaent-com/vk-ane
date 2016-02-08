package com.gogames.ane {
import flash.external.ExtensionContext;

public class ANE {
    private static var context:ExtensionContext;

    public function ANE() {
    }

    public static function init():void {
        if (!context)
            context = ExtensionContext.createExtensionContext("com.gogames.ane", null);
    }

    public static function showToast(text:String):void {
        if (context)
            context.call("showToast", text);
    }

    public static function showAlert(title:String, text:String):void {
        if (context)
            context.call("showAlert", title, text);
    }
}
}
