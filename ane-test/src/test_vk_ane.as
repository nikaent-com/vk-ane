package {

import com.gogames.ane.ANE;

import flash.display.Sprite;
import flash.text.TextField;

public class test_vk_ane extends Sprite {
    public function test_vk_ane() {
        var textField:TextField = new TextField();
        textField.text = "Hello, World";
        addChild(textField);
        ANE.init();
        ANE.showAlert("Test Title", "Text........")
    }
}
}
