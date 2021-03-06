package {
import com.nikaent.ane.vk.VK;
import com.nikaent.ane.vk.model.Scope;
import com.nikaent.ane.vk.model.UserParam;
import com.nikaent.ane.vk.model.VKEvent;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.TouchEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;

public class test_vk_ane extends Sprite {

    private const APP_ID:String = "5282890";

    var tf:TextField;

    public function test_vk_ane(sdf:int = 0) {
        Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

        var format1:TextFormat = new TextFormat();
        format1.font = "Arial";
        format1.size = 24;
        tf = new TextField();
        tf.background = true;
        tf.backgroundColor = 0xAAAAAA;
        tf.setTextFormat(format1);
        tf.x = 200;
        tf.height = tf.width = 500;
        addChild(tf);

        VK.addEventListener(VKEvent.AUTH_FAILED, function (e:VKEvent):void {
            tf.text = VKEvent.AUTH_FAILED;
        });
        VK.addEventListener(VKEvent.AUTH_SUCCESSFUL, function (e:VKEvent):void {
            tf.text = VKEvent.AUTH_SUCCESSFUL;
            VK.api("users.get", {"fields": "uid,first_name,last_name,photo_medium,photo_200,sex,bdate,online,country"}, callback, callback);
        });
        VK.addEventListener(VKEvent.TOKEN_INVALID, function (e:VKEvent):void {
            tf.text = VKEvent.TOKEN_INVALID;
        });

        var buttons:Vector.<ButtonVk> = new Vector.<ButtonVk>();
        buttons.push(new ButtonVk("init", function (e:Event):void {
            trace("login");
            VK.init(APP_ID, onLog, true);
        }));
        buttons.push(new ButtonVk("login", function (e:Event):void {
            trace("login");
            VK.login(Scope.NOTIFY,
                    Scope.FRIENDS,
                    Scope.WALL,
                    Scope.GROUPS,
                    Scope.EMAIL,
                    Scope.OFFLINE,
                    Scope.NOHTTPS
            );
            //VK.login(Scope.FRIENDS, Scope.NOTIFICATIONS, Scope.STATUS);
        }));
        buttons.push(new ButtonVk("logout", function (e:Event):void {
            VK.logout();
        }));
        buttons.push(new ButtonVk("isLoggedIn()", function (e:Event):void {
            tf.text = VK.isLoggedIn() ? "LoggenIn" : "LoggenOut";
        }));
        buttons.push(new ButtonVk("apiCall()", function (e:Event):void {
            VK.api("users.get", {fields: 'id,first_name,last_name,photo_200,sex,bdate,online,country'}, callback, callback);
            //VK.api("users.get",{"fields":"uid,first_name,last_name,photo_medium,photo_200,sex,bdate,online,country"}, callback, callback);
        }));
        buttons.push(new ButtonVk("method 3", function (e:Event):void {
            VK.api("friends.getAppUsers", {}, callback, callback);
//            VK.api("friends.get",{"fields":"id,first_name,last_name,sex,bdate,city"}, callback, callback);
        }));
        buttons.push(new ButtonVk("wall.post", function (e:Event):void {
            VK.api("wall.post", {"message": "messageтекст"}, callback, callback);
        }));
        buttons.push(new ButtonVk("testCaptcha", function (e:Event):void {
            VK.testCaptcha();
        }));
        buttons.push(new ButtonVk("sendRequest", function (e:Event):void {
            VK.api("apps.sendRequest", {
                "user_id": "12837791",
                "text": "Alexander, дарю тебе жизнь! Скорее заходи в игру и забери её!",
                "type": "request",
                "key": "requestKey",
                "separate": 0
            }, callback, callback);
        }));


        var aLast:TextField;
        for each(var button:ButtonVk in buttons) {
            aLast = setText(button.name, button.callback, 0, aLast ? (aLast.height + aLast.y + 10) : 0);
        }
    }

    private function callback(obj:*) {
        tf.text = JSON.stringify(obj);
    }

    private function onLog(...args):void {
        trace(args);
    }

    private function setText(name:String, onclick:Function = null, x:int = 0, y:int = 0):TextField {

        var format1:TextFormat = new TextFormat();
        format1.font = "Arial";
        format1.size = 24;

        var textfield:TextField = new TextField();
        textfield.text = name;
        textfield.background = true;
        textfield.backgroundColor = 0xAAAAAA;
        textfield.setTextFormat(format1);
        //textfield.addEventListener(MouseEvent.CLICK, onclick);
        textfield.addEventListener(TouchEvent.TOUCH_TAP, onclick);
        textfield.width = textfield.textWidth + 10;
        textfield.height = textfield.textHeight + 10;
        addChild(textfield);
        textfield.x = x;
        textfield.y = y;
        return textfield;
    }
}
}
