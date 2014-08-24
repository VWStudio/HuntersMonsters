/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import com.agnither.hunters.data.inner.PersonageVO;

import flash.utils.Dictionary;

public class ItemTypeVO{

    public static const LIST: Vector.<ItemTypeVO> = new <ItemTypeVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public var id: int;
    public var name: String;

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: ItemTypeVO = new ItemTypeVO();
            object.id = row.id;
            object.name = row.name;

            LIST.push(object);
            DICT[object.id] = object;
        }
    }
}
}
