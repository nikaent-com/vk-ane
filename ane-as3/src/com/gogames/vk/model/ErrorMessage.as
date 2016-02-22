/**
 * Created by alekseykabanov on 10.02.16.
 */
package com.gogames.vk.model {
public class ErrorMessage {
    public static const SINGLETON:String = "Error, singleton must have one instance of the class.";
    public static const SCOPES:String = "Error, scopes must be type of String.";
    public static var VK_INIT:String = "Error, before you start you need to call the constructor 'new VK(<appVkId>)'";
}
}
