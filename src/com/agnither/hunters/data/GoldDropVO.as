/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data {
import flash.utils.Dictionary;

public class GoldDropVO {

    public static const LIST: Vector.<GoldDropVO> = new <GoldDropVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: GoldDropVO = new GoldDropVO();
            object.id = row.id;
            object.value = row.value;

            LIST.push(object);
            DICT[object.id] = object;
        }
    }

    public var id: int;
    public var value: String;
}
}