/**
 * Created by alekseykabanov on 10.02.16.
 */
package com.nikaent.ane.vk.model {
import flash.events.Event;

public class VKEvent extends Event {
    public static const ERROR           :String = "ERROR";
    public static const AUTH_SUCCESSFUL :String = "AUTH_SUCCESSFUL";
    public static const AUTH_FAILED     :String = "FAILED";
    public static const TOKEN_INVALID   :String = "TOKEN_INVALID";

    public var data : String = "";

    public function VKEvent(type:String, data:String = "") {
        super(type);
        this.data = data;
    }
}
}