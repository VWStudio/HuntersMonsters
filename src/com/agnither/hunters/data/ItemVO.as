/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data {
import flash.utils.Dictionary;

public class ItemVO {

    public static const LIST: Vector.<ItemVO> = new <ItemVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: ItemVO = new ItemVO();
            object.id = row.id;
            object.name = row.name;
            object.picture = row.picture;
            object.type = row.type;
            object.action = row.action;

            LIST.push(object);
            DICT[object.id] = object;
        }
    }

    public var id: int;
    public var name: String;
    public var picture: String;
    public var type: int;
    public var action: String;
}
}