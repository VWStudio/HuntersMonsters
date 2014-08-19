/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class ChipVO {

    public static const CHEST: String = "chest";
    public static const WEAPON: String = "weapon";
    public static const NATURE: String = "nature";
    public static const WATER: String = "water";
    public static const FIRE: String = "fire";
    public static const ADD1: String = "add1";
    public static const ADD2: String = "add2";
    public static const ADD3: String = "add3";

    public static const LIST: Vector.<ChipVO> = new <ChipVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: ChipVO = new ChipVO();
            object.id = row.id;
            object.name = row.name;
            object.picture = row.picture;

            LIST.push(object);
            DICT[object.name] = object;
        }
    }

    public var id: int;
    public var name: String;
    public var picture: String;
}
}