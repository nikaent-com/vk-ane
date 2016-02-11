/**
 * Created by alekseykabanov on 10.02.16.
 */
package com.gogames.vk {
import com.gogames.ane.ANE;
import com.gogames.vk.model.ErrorMessage;
import com.gogames.vk.model.VKEvent;

import flash.events.EventDispatcher;

public class VK extends EventDispatcher {
    private static var _inst:VK = null;

    private var _ane:ANE = null;

    public function VK() {
        if (_inst) throw new Error(ErrorMessage.SINGLETON);

        _inst = this;
        _ane = new ANE(onStatus);
        _ane.init();
    }

    private function onStatus(code:String, data:String):void {
        switch (code) {
            case VKEvent.AUTH_FAILED:
            case VKEvent.AUTH_SUCCESSFUL:
            case VKEvent.TOKEN_INVALID:
                this.dispatchEvent(new VKEvent(code));
                break;
        }
    }

    public static function getInstance():VK {
        if (!_inst) new VK();
        return _inst;
    }

    public static function login(...scopes):void {
        for each(var str:* in scopes) {
            if (!(str is String)) {
                throw new Error(ErrorMessage.SCOPES);
            }
        }
        trace("vk login");
        getInstance()._ane.login(scopes);
    }

    public static function logout():void {
        getInstance()._ane.logout();
    }

    public static function usersGet():void {
        getInstance()._ane.usersGet();
    }

    public static function isLoggedIn():Boolean {
        return getInstance()._ane.isLoggedIn();
    }

    public static function apiCall(method:int, params:String):void {
        return getInstance()._ane.apiCall(method, params);
    }

}
}
