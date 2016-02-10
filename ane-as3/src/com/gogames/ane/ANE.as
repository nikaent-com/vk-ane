package com.gogames.ane {
import flash.events.StatusEvent;
import flash.external.ExtensionContext;

public class ANE {
    private var _context:ExtensionContext;
    private var _onStatus:Function;

    public function ANE(onStatus:Function) {
        _onStatus = onStatus;
    }

    public function init():void {
        if (!_context) {
            _context = ExtensionContext.createExtensionContext("com.gogames.ane", null);
            _context.call("init");
            _context.addEventListener(StatusEvent.STATUS, extensionStatusHandler, false, 0, true);
        }
    }

    private function extensionStatusHandler(event:StatusEvent):void {
        if (_onStatus) {
            _onStatus(event.code, event.level);
        }
        trace(event.code + "::" + event.level);
    }

    public function showToast(text:String):void {
        if (_context)
            _context.call("showToast", text);
    }

    public function showAlert(title:String, text:String):void {
        if (_context)
            _context.call("showAlert", title, text);
    }

    public function login(scope:Array):void {
        trace("ane login in");
        if (_context) {
            trace("ane login send");
            _context.call("login", JSON.stringify(scope));
            trace("ane login", scope);
            trace("ane login sended");
        }
    }

    public function logout():void {
        if (_context)
            _context.call("logout");
    }
}
}
