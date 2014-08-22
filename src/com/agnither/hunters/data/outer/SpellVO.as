/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class SpellVO {

    public static const FIREBALL :String = "fireball";
    public static const BLAZE :String = "blaze";

    public static const LIST: Vector.<SpellVO> = new <SpellVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: SpellVO = new SpellVO();
            object.id = row.id;
            object.name = row.name;
            object.picture = row.picture;
            object.damage = row.damage;
            object.mana = row.mana ? row.mana.split(",") : [];

            LIST.push(object);
            DICT[object.id] = object;
            DICT[object.name] = object;
        }
    }

    public var id: int;
    public var name: String;
    public var picture: String;
    public var damage: int;
    public var mana: Array;
}
}