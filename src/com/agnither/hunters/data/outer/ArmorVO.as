/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class ArmorVO {

    public static const LIST: Vector.<ArmorVO> = new <ArmorVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: ArmorVO = new ArmorVO();
            object.id = row.id;
            object.name = row.name;
            object.picture = row.picture;
            object.armor = row.armor;
            object.drop_armor_range = row.droparmorrange;
            object.type = row.type;

            LIST.push(object);
            DICT[object.id] = object;
        }
    }

    public var id: int;
    public var name: String;
    public var picture: String;
    public var armor: int;
    public var drop_armor_range: String;
    public var type: int;
}
}