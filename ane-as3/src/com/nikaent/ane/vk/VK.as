/**
 * Created by alekseykabanov on 10.02.16.
 */
package com.nikaent.ane.vk {
import com.nikaent.ane.vk.model.ErrorMessage;
import com.nikaent.ane.vk.model.VKEvent;

import flash.events.EventDispatcher;
import flash.utils.Dictionary;

public class VK extends EventDispatcher {
    private static var _inst:VK = null;

    private var _ane:ANE = null;

    private var mapCallback:Dictionary = new Dictionary();

    //PUBLIC-------------

    public function VK() {
        if (_inst) throw new Error(ErrorMessage.SINGLETON);

        _inst = this;
        _ane = new ANE(onStatus);
    }

    public static function getInstance():VK {
        if (!_inst) new VK();
        return _inst;
    }

    public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
        getInstance().addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    public static function init(appIdVk:String):void {
        ane.init(appIdVk);
    }

    public static function api(method:String, params:String, callback:Function):void {
        var requestId:String = ane.call("apiCall", method, params) as String;
        trace("requestId:" + requestId);
        getInstance().mapCallback[requestId] = callback;
    }

    public static function login(...scopes):void {
        for each(var str:* in scopes) {
            if (!(str is String)) {
                throw new Error(ErrorMessage.SCOPES);
            }
        }
        ane.call("login", JSON.stringify(scopes));
    }

    public static function logout():void {
        ane.call("logout");
    }

    public static function isLoggedIn():Boolean {
        return ane.call("isLoggedIn");
    }

    public static function apiCall(method:int, params:String, callback:Function):void {
        var requestId:String = ane.call("apiCall", method, params) as String;
        trace("requestId:" + requestId);
        getInstance().mapCallback[requestId] = callback;
    }

    private static function get ane():ANE {
        return getInstance()._ane;
    }

    //PRIVATE-----------

    private function onStatus(code:String, data:String):void {
        trace("onStatus:" + code);
        if (code.substr(0, 8) == "response") {
            var responseId:String = "";
            if (code.substr(0, 13) == "responseError") {
                responseId = code.substr(13);
            } else if (code.substr(0, 14) == "responseFailed") {
                responseId = code.substr(14);
            } else {
                responseId = code.substr(8);
            }
            if (mapCallback[responseId]) {
                var callback:Function = mapCallback[responseId];
                delete mapCallback[responseId];
                callback(data);
            }
        } else {
            switch (code) {
                case VKEvent.AUTH_FAILED:
                case VKEvent.AUTH_SUCCESSFUL:
                case VKEvent.TOKEN_INVALID:
                    dispatchEvent(new VKEvent(code, data));
                    break;
            }
        }
    }
}
}
