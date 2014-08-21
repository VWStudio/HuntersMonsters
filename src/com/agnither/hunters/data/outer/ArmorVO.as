/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import com.agnither.hunters.data.inner.ItemVO;

import flash.utils.Dictionary;

public class ArmorVO extends ItemVO {

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

    public var armor: int;
    public var drop_armor_range: String;
    public var type: int;

    public function get randomDefence():int {
        var minMax: Array = drop_armor_range.split("..");
        var min: int = minMax[0];
        var max: int = minMax[1];
        return min + Math.random() * (max - min);
    }
}
}