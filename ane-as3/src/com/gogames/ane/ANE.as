package com.gogames.ane {
import flash.events.StatusEvent;
import flash.external.ExtensionContext;

public class ANE {
    private var _context:ExtensionContext;
    private var _onStatus:Function;

    public function ANE(onStatus:Function) {
        _onStatus = onStatus;
    }

    public function init(appIdVk : String):void {
        if (!_context) {
            _context = ExtensionContext.createExtensionContext("com.gogames.ane", null);
            _context.call("init", appIdVk);
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

    public function call(functionName : String, ...params):Object{
        if(params.length==0){
            return _context.call(functionName);
        }else if(params.length==1){
            return _context.call(functionName, params[0]);
        }else if(params.length==2){
            return _context.call(functionName, params[0], params[1]);
        }
        return null;
    }
}
}
