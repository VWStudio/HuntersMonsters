/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class MagicVO {

    public static const NATURE: String = "nature";
    public static const WATER: String = "water";
    public static const FIRE: String = "fire";

    public static const LIST: Vector.<MagicVO> = new <MagicVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: MagicVO = new MagicVO();
            object.id = row.id;
            object.name = row.name;
            object.picture = row.picture;

            LIST.push(object);
            DICT[object.id] = object;
            DICT[object.name] = object;
        }
    }

    public var id: int;
    public var name: String;
    public var picture: String;
}
}