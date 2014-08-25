/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class DropVO {

    public static const LIST: Vector.<DropVO> = new <DropVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function getRandomDrop(itemSet: int):DropVO {
        var rand: int = Math.random() * 100;
        var list: Vector.<DropVO> = DICT[itemSet];
        for (var i:int = 0; i < list.length; i++) {
            if (list[i].probability > rand) {
                return list[i];
            }
            rand -= list[i].probability;
        }
        return null;
    }

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: DropVO = new DropVO();
            object.id = row.id;
            object.item_set = row.itemset;
            object.type = row.type;
            object.item_id = row.itemid;
            object.probability = row.probability;

            LIST.push(object);
            if (!DICT[object.item_set]) {
                DICT[object.item_set] = new <DropVO>[];
            }
            DICT[object.item_set].push(object);
        }
    }

    public var id: int;
    public var item_set: int;
    public var type: int;
    public var item_id: int;
    public var probability: int;
}
}