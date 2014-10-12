/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import com.agnither.hunters.model.modules.players.PersonageVO;

import flash.utils.Dictionary;

public class ItemSlotVO{

    public static const LIST: Vector.<ItemSlotVO> = new <ItemSlotVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public var id: int;
    public var name: String;
    public var max: String;

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: ItemSlotVO = new ItemSlotVO();
            object.id = row.id;
            object.name = row.name;
            object.max = row.max;

            LIST.push(object);
            DICT[object.id] = object;
        }
    }
}
}
