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
    private var mapError:Dictionary = new Dictionary();

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

    public static function api(method:String, params:Object, onResponse:Function = null, onError:Function = null):void {
        var requestId:String = ane.call("apiCall", method, JSON.stringify(params)) as String;
        trace("requestId:" + requestId);
        if(requestId) {
            trace("register callback:"+requestId);
            getInstance().mapCallback[requestId] = onResponse;
            getInstance().mapError[requestId] = onError;
        }
    }

    public static function login(...scopes):void {
        for each(var str:* in scopes) {
            if (!(str is String)) {
                throw new Error(ErrorMessage.SCOPES);
            }
        }
        ane.call("login", '["'+scopes.join('","')+'"]');
    }

    public static function logout():void {
        ane.call("logout");
    }

    public static function testCaptcha():void {
        ane.call("testCaptcha");
    }

    public static function isLoggedIn():Boolean {
        return ane.call("isLoggedIn");
    }

    private static function get ane():ANE {
        return getInstance()._ane;
    }

    //PRIVATE-----------

    private function callFunction(map:Dictionary, responseId:String, data:Object):void {
        if (map[responseId]) {
            var callback:Function = map[responseId];
            callback(data);
        }
        delete mapError[responseId];
        delete mapCallback[responseId];
    }

    private function onStatus(code:String, data:String):void {
        trace("onStatus:" + code);
        var responseData:Object = null;
        try{
            responseData = JSON.parse(data);
        }catch (err:Error){
            responseData = data;
        }
        if (code.substr(0, 8) == "response") {
            var responseId:String = code.substr(8);
            var map:Dictionary = mapCallback;
            if (code.length >= 8 && code.substr(0, 13) == "responseError") {
                responseId = code.substr(13);
                map = mapError;
                responseData["errorCode"]=VKEvent.VK_API_RETURNED_ERROR;
            } else if (code.length >= 14 && code.substr(0, 14) == "responseFailed") {
                responseId = code.substr(14);
                map = mapError;
                responseData["errorCode"]=VKEvent.VK_API_RETURNED_ERROR;
            }
            callFunction(map, responseId, responseData);
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
