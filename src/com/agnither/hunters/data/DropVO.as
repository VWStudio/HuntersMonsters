/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data {
import flash.utils.Dictionary;

public class DropVO {

    public static const LIST: Vector.<DropVO> = new <DropVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: DropVO = new DropVO();
            object.id = row.id;
            object.item_set = row.itemset;
            object.item_type = row.itemtype;
            object.item_id = row.itemid;
            object.probability = row.probability;

            LIST.push(object);
            DICT[object.item_set] = object;
        }
    }

    public var id: int;
    public var item_set: int;
    public var item_type: int;
    public var item_id: int;
    public var probability: int;
}
}