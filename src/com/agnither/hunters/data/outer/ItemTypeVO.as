/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class ItemTypeVO{

    public static var weapon: int;
    public static var armor: int;
    public static var magic: int;
    public static var spell: int;
    public static var gold: int;

    public static const LIST: Vector.<ItemTypeVO> = new <ItemTypeVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public var id: int;
    public var name: String;
    public var picture: String;
    public var tabMin : int = 0;
    public var tabMax : int = 0;

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: ItemTypeVO = new ItemTypeVO();
            object.id = row.id;
            object.name = row.name;
            object.picture = row.picture;
            var minmax : Array = row.shoptabminmax ? row.shoptabminmax.split(",") : [0,0];
            object.tabMin = minmax[0];
            object.tabMax = minmax[1];

            LIST.push(object);
            DICT[object.id] = object;
            ItemTypeVO[object.name] = object.id;
            trace(object.name, object.id, ItemTypeVO[object.name]);
        }
    }
}
}
