package {

import com.gogames.ane.ANE;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

public class test_vk_ane extends Sprite {
    public function test_vk_ane() {
        var textField:TextField = new TextField();
        textField.text = "Hello, World";
        addChild(textField);
        ANE.init();




        var sprite:Sprite = new Sprite();
        sprite.graphics.lineStyle(1);
        sprite.graphics.beginFill(0);
        sprite.graphics.drawRect(10, 10, 100, 100);
        sprite.graphics.endFill();
        this.addChild(sprite);
        sprite.addEventListener(MouseEvent.CLICK, function(e:Event){
            ANE.showToast("ssss");
        });


        sprite.graphics.lineStyle(1);
        sprite.graphics.beginFill(0);
        sprite.graphics.drawRect(20, 200, 100, 100);
        sprite.graphics.endFill();
        this.addChild(sprite);
        sprite.addEventListener(MouseEvent.CLICK, function(e:Event){
            ANE.showAlert("Test Title", "Text........");
        });
    }
}
}
