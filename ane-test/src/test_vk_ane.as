package {

import com.gogames.ane.ANE;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextField;

public class test_vk_ane extends Sprite {
    public function test_vk_ane() {
        ANE.init();

        var buttons:Vector.<ButtonVk> = new Vector.<ButtonVk>();
        buttons.push(new ButtonVk("showToast", function (e:Event) {
            ANE.showToast("text toast");
        }));
        buttons.push(new ButtonVk("showAlert", function (e:Event) {
            ANE.showAlert("Title alert", "Text alert");
        }));
        buttons.push(new ButtonVk("login", function (e:Event) {
            ANE.login();
        }));
        buttons.push(new ButtonVk("logout", function (e:Event) {
            ANE.logout()
        }));

        var aLast:TextField;
        for each(var button:ButtonVk in buttons) {
            var aLast:TextField = setText(button.name, button.callback, 0, aLast ? (aLast.height + aLast.y + 10) : 0);
        }

    }

    private function setText(name:String, onclick:Function = null, x:int = 0, y:int = 0):TextField {
        var textfield:TextField = new TextField();
        textfield.text = name;
        textfield.background = true;
        textfield.backgroundColor = 0xAAAAAA;
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
