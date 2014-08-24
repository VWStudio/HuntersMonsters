/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class ExtensionVO {

    public static const LIST : Vector.<ExtensionVO> = new <ExtensionVO>[];
    public static const DICT : Dictionary = new Dictionary();

    public var id : int;
    public var type : String;

    public static function parseData(data : Object) : void {
        for (var i : int = 0; i < data.length; i++)
        {
            var row : Object = data[i];

            var object : ExtensionVO = new ExtensionVO();
            object.id = row.id;
            object.type = row.type;

            LIST.push(object);
            DICT[object.id] = object;
        }
    }
}
}
