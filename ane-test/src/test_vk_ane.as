package {


import com.gogames.vk.VK;
import com.gogames.vk.model.Scope;
import com.gogames.vk.model.UserParam;
import com.gogames.vk.model.VKEvent;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;

public class test_vk_ane extends Sprite {
    public function test_vk_ane() {
        Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

        var format1:TextFormat = new TextFormat();
        format1.font = "Arial";
        format1.size = 24;
        var tf:TextField = new TextField();
        tf.background = true;
        tf.backgroundColor = 0xAAAAAA;
        tf.setTextFormat(format1);
        tf.x = 200;
        tf.height = tf.width = 500;
        addChild(tf);

        new VK("5282890");

        VK.getInstance().addEventListener(VKEvent.AUTH_FAILED, function (e:VKEvent):void {
            tf.text = VKEvent.AUTH_FAILED;
        });
        VK.getInstance().addEventListener(VKEvent.AUTH_SUCCESSFUL, function (e:VKEvent):void {
            tf.text = VKEvent.AUTH_SUCCESSFUL;
        });
        VK.getInstance().addEventListener(VKEvent.TOKEN_INVALID, function (e:VKEvent):void {
            tf.text = VKEvent.TOKEN_INVALID;
        });

        var buttons:Vector.<ButtonVk> = new Vector.<ButtonVk>();
        buttons.push(new ButtonVk("login", function (e:Event):void {
            trace("login");
            VK.login(Scope.FRIENDS, Scope.NOTIFICATIONS, Scope.STATUS, Scope.GROUPS, Scope.WALL, Scope.AUDIO, Scope.PHOTOS, Scope.NOHTTPS, Scope.EMAIL, Scope.MESSAGES);
            //VK.login(Scope.FRIENDS, Scope.NOTIFICATIONS, Scope.STATUS);
        }));
        buttons.push(new ButtonVk("logout", function (e:Event):void {
            VK.logout();
        }));
        buttons.push(new ButtonVk("isLoggedIn()", function (e:Event):void {
            tf.text = VK.isLoggedIn()?"LoggenIn":"LoggenOut";
        }));
        buttons.push(new ButtonVk("apiCall()", function (e:Event):void {
            VK.apiCall(2,UserParam.all, function(str:String):void{
                tf.text = str;
            });
        }));
        buttons.push(new ButtonVk("method 3", function (e:Event):void {
            VK.apiCall(3,"id,first_name,last_name,sex,bdate,city", function(str:String):void{
                tf.text = str;
            });
        }));
        buttons.push(new ButtonVk("method 4", function (e:Event):void {
            VK.apiCall(4,"", function(str:String):void{
                tf.text = str;
            });
        }));
        buttons.push(new ButtonVk("method 5", function (e:Event):void {
            VK.apiCall(5,"", function(str:String):void{
                tf.text = str;
            });
        }));
        buttons.push(new ButtonVk("method 6", function (e:Event):void {
            VK.apiCall(6,"", function(str:String):void{
                tf.text = str;
            });
        }));

        var aLast:TextField;
        for each(var button:ButtonVk in buttons) {
            aLast = setText(button.name, button.callback, 0, aLast ? (aLast.height + aLast.y + 10) : 0);
        }
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
        textfield.addEventListener(TouchEvent.TOUCH_TAP, onclick)
        textfield.width = textfield.textWidth + 10;
        textfield.height = textfield.textHeight + 10;
        addChild(textfield);
        textfield.x = x;
        textfield.y = y;
        return textfield;
    }
}
}
