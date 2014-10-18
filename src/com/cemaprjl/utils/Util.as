/**
 * Created by mor on 16.10.2014.
 */
package com.cemaprjl.utils {
public class Util {

    public static function toObj($val : Object) : Object {
        return JSON.parse(JSON.stringify($val));
    }

    public static function uniq($id : String) : String {
        return $id + "." + (new Date()).time;

    }
}
}
