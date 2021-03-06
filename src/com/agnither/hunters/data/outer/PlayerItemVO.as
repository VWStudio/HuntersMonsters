/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.data.outer {
import com.agnither.hunters.model.modules.items.ItemVO;

import flash.utils.Dictionary;

public class PlayerItemVO {

    public static const LIST: Vector.<PlayerItemVO> = new <PlayerItemVO>[];
//    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {

        //trace(JSON.stringify(data));

        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: PlayerItemVO = new PlayerItemVO();
            object.id = row.id;
            object.ext = ItemVO.parseExtension(row.ext);
            object.wield = row.wield;

            LIST.push(object);
//            DICT[object.id] = object;
        }
    }

    private static function parseExtension(string: String):Object {
        if (!string) {
            return null;
        }

        var object: Object = {};
        var array: Array = string.split(",");
        for (var i:int = 0; i < array.length; i++) {
            while (array[i].indexOf("[") >= 0 && array[i].indexOf("]") < 0) {
                array[i] += "," + array[i+1];
                array.splice(i+1, 1);
            }

            var row: Array = array[i].split(":");
            var id: String = row[0];
            var value: String = row[1];
            object[id] = value;
        }
        return object;
    }

    public var id: String;
    public var ext : Object;
    public var wield : Boolean = false;

}
}
