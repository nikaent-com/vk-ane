package {


import com.gogames.vk.VK;
import com.gogames.vk.model.Scope;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

public class test_vk_ane extends Sprite {
    public function test_vk_ane() {
        var buttons:Vector.<ButtonVk> = new Vector.<ButtonVk>();
        buttons.push(new ButtonVk("login", function (e:Event):void {
            VK.login(Scope.FRIENDS, Scope.NOTIFICATIONS, Scope.STATUS);
        }));
        buttons.push(new ButtonVk("logout", function (e:Event):void {
            VK.logout();
        }));

        var aLast:TextField;
        for each(var button:ButtonVk in buttons) {
            aLast = setText(button.name, button.callback, 0, aLast ? (aLast.height + aLast.y + 10) : 0);
        }

    }

    private function setText(name:String, onclick:Function = null, x:int = 0, y:int = 0):TextField {

        var format1:TextFormat = new TextFormat();
        format1.font="Arial";
        format1.size=24;

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
