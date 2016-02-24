package com.nikaent.ane.vk {
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.system.Capabilities;

public class ANE {
    private var _context:ExtensionContext;
    private var _onStatus:Function;

    public function ANE(onStatus:Function) {
        _onStatus = onStatus;
    }

    private function get isWork():Boolean {
        return _context && (Capabilities.manufacturer.search("Android") > -1 || Capabilities.manufacturer.search("iOS") > -1);
    }

    public function init(appIdVk:String):void {
        if (!_context) {
            _context = ExtensionContext.createExtensionContext("com.nikaent.ane.vk", null);
            if (isWork) {
                _context.addEventListener(StatusEvent.STATUS, extensionStatusHandler, false, 0, true);
                _context.call("init", appIdVk);
            }
            if (!_context) throw new Error(" Cannot create context.");
        }
    }

    private function extensionStatusHandler(event:StatusEvent):void {
        if (_onStatus) {
            _onStatus(event.code, event.level);
        }
        trace(event.code + "::" + event.level);
    }

    public function call(functionName:String, ...params):Object {
        if (!isWork) return null;
        if (params.length == 0) {
            return _context.call(functionName);
        } else if (params.length == 1) {
            return _context.call(functionName, params[0]);
        } else if (params.length == 2) {
            return _context.call(functionName, params[0], params[1]);
        }
        return null;
    }
}
}
