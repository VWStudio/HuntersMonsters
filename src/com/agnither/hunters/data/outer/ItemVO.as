/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class ItemVO {

    public var id: int;
    public var name: String;
    public var picture: String;
    public var type: int;
    public var slot: int;
    public var extension : Object;
    public var extension_drop : Object;


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
            object.slot = row.slot;
            object.extension = JSON.parse(row.extension);
            object.extension_drop = JSON.parse(row.extension_drop);

            LIST.push(object);
            DICT[object.id] = object;
        }
    }

}
}
