package {


import com.gogames.vk.VK;
import com.gogames.vk.model.Scope;
import com.gogames.vk.model.VKEvent;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

public class test_vk_ane extends Sprite {
    public function test_vk_ane() {
        var format1:TextFormat = new TextFormat();
        format1.font = "Arial";
        format1.size = 24;
        var tf:TextField = new TextField();
        tf.background = true;
        tf.backgroundColor = 0xAAAAAA;
        tf.setTextFormat(format1);
        tf.x = 200;
        addChild(tf);

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
            VK.login(Scope.FRIENDS, Scope.NOTIFICATIONS, Scope.STATUS, Scope.ADS, Scope.AUDIO, Scope.DOCS, Scope.EMAIL, Scope.GROUPS, Scope.MESSAGES, Scope.NOHTTPS, Scope.NOTES, Scope.OFFERS, Scope.OFFLINE, Scope.PAGES, Scope.PHOTOS, Scope.QUESTIONS, Scope.STATS, Scope.STATUS, Scope.VIDEO, Scope.WALL);
        }));
        buttons.push(new ButtonVk("logout", function (e:Event):void {
            VK.logout();
        }));
        buttons.push(new ButtonVk("users.get()", function (e:Event):void {
            VK.usersGet();
        }));
        buttons.push(new ButtonVk("isLoggedIn()", function (e:Event):void {
            tf.text = VK.isLoggedIn()?"LoggenIn":"LoggenOut";
        }));
        buttons.push(new ButtonVk("apiCall()", function (e:Event):void {
            VK.apiCall(2,"ss");
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
        textfield.addEventListener(MouseEvent.CLICK, onclick);
        textfield.width = textfield.textWidth + 10;
        textfield.height = textfield.textHeight + 10;
        addChild(textfield);
        textfield.x = x;
        textfield.y = y;
        return textfield;
    }
}
}
