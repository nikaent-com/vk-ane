/**
 * Created by alekseykabanov on 10.02.16.
 */
package com.nikaent.ane.vk {

import com.nikaent.ane.vk.model.ErrorMessage;
import com.nikaent.ane.vk.model.VKEvent;

import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.system.Capabilities;
import flash.utils.Dictionary;

public class VK extends EventDispatcher {
    private static const RESPONSE:String = 'response';
    private static const ERROR:String = 'Error';
    private static const FAIL:String = 'Failed';

    private static var _inst:VK;

    private static var _context:ExtensionContext;

    private static var mapCallback:Dictionary = new Dictionary();
    private static var mapError:Dictionary = new Dictionary();
    private static var _log:Function = null;

    private static var _isDebug:Boolean = false;

    public function VK() {
        _inst ||= this;
    }

    public static function getInstance():VK {
        return _inst ||= new VK();
    }

    public static function get isSupported():Boolean {
        return _context && (Capabilities.manufacturer.search("Android") > -1 || Capabilities.manufacturer.search("iOS") > -1);
    }

    public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
        getInstance().addEventListener(type, listener, useCapture, priority, useWeakReference);
    }


    public static function init(appIdVk:String, log:Function = null, isDebug:Boolean = false):void {
        _log = log;
        _isDebug = isDebug;
        VK.log("manufacturer: ", Capabilities.manufacturer);

        if (!_context) {
            _context = ExtensionContext.createExtensionContext("com.nikaent.ane.vk", null);
            if (isSupported) {
                _context.addEventListener(StatusEvent.STATUS, onStatus);
                _context.call('init', appIdVk, isDebug);
            }
            if (!_context) {
                throw new Error('Context Not Created');
            }
        }
    }


    public static function api(method:String,
                               params:Object,
                               onResponse:Function = null,
                               onError:Function = null):void {
        var requestId:String = String(callContext('apiCall', method, JSON.stringify(params)));
        log("Get requestId:", requestId);
        if (requestId) {
            mapCallback[requestId] = onResponse;
            mapError[requestId] = onError;
        }
    }

    public static function login(...scopes):void {
        for each(var str:* in scopes) {
            if (!(str is String)) {
                throw new Error(ErrorMessage.SCOPES);
            }
        }
        callContext('login', '["' + scopes.join('","') + '"]');
    }

    public static function logout():void {
        callContext('logout');
    }

    public static function testCaptcha():void {
        callContext('testCaptcha');
    }

    public static function isLoggedIn():Boolean {
        return callContext('isLoggedIn');
    }

    private static function callFunction(responseId:String, data:Object, isError:Boolean):void {
        var callback:Function;
        if (isError) {
            callback = mapError[responseId];
        }
        else {
            callback = mapCallback[responseId];
        }
        delete mapError[responseId];
        delete mapCallback[responseId];

        if (callback is Function) {
            callback(data);
        }
    }

    private static function onStatus(event:StatusEvent):void {
        log('Status Event', event);

        var code:String = event.code;
        var responseData:Object;

        try {
            responseData = JSON.parse(event.level);
        }
        catch (err:Error) {
            responseData = null;
        }

        if (!responseData || typeof responseData != 'object') {
            if (typeof event.level == 'object') {
                responseData = event.level;
            }
            else {
                responseData = {data: event.level};
            }
        }

        if (code && code.indexOf(RESPONSE) == 0) {
            var isError:Boolean;

            var prefixLength:int = RESPONSE.length;
            if (code.indexOf(RESPONSE + ERROR) == 0) {
                prefixLength = (RESPONSE + ERROR).length;
                responseData.errorCode = "VKError";
                isError = true;
            }
            else if (code.indexOf(RESPONSE + FAIL) == 0) {
                prefixLength = (RESPONSE + FAIL).length;
                responseData.errorCode = "VKFail";
                isError = true;
            }

            callFunction(code.substr(prefixLength), responseData, isError);
        }
        else {
            switch (code) {
                case VKEvent.AUTH_FAILED:
                case VKEvent.AUTH_SUCCESSFUL:
                case VKEvent.TOKEN_INVALID:
                    getInstance().dispatchEvent(new VKEvent(code, responseData));
                    break;
                case VKEvent.LOG:
                    log(code, responseData);
                    break;
            }
        }
    }

    private static function callContext(...args):Object {
        if (_context) {
            log("Send to ANE", args);
            return _context.call.apply(_context, args);
        }
        else {
            log('Error Call Method No Context Available', args[0]);
        }

        return null;
    }

    private static function log(...args):void {
        if (_isDebug) {
            trace(args);
        }
        if (_log) {
            try {
                _log.apply(null, args);
            }
            catch (error:Error) {
                trace('Error Call External Log', error.message, error.getStackTrace());
            }
        }
    }
}
}
