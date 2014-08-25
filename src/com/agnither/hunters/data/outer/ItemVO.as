/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.data.outer {
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
            object.slot = row.slot;
            object.extension = parseExtension(row.extension);
            object.extension_drop = parseExtension(row.extensiondrop);

            LIST.push(object);
            DICT[object.id] = object;
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

    private static function getValue(data: String):int {
        var value: Object = JSON.parse(data);
        if (value is Array) {
            var min: int = value[0];
            var max: int = value[1];
            return min + Math.random() * (max+1 - min);
        }
        return value as int;
    }

    public var id: int;
    public var name: String;
    public var picture: String;
    public var type: int;
    public var slot: int;
    public var extension : Object;
    public var extension_drop : Object;

    public function getDropExtensionValue(key: String):int {
        return extension_drop[key] ? getValue(extension_drop[key]) : getValue(extension[key]);
    }
}
}
