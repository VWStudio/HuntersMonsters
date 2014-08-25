/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class GoldDropVO {

    public static const LIST: Vector.<GoldDropVO> = new <GoldDropVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: GoldDropVO = new GoldDropVO();
            object.id = row.id;
            object.value = JSON.parse(row.value) as Array;

            LIST.push(object);
            DICT[object.id] = object;
        }
    }

    public var id: int;
    public var value: Array;

    public function get random():int {
        var min: int = value[0];
        var max: int = value[1];
        return min + Math.random()*(max+1-min);
    }
}
}