/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data {
import flash.utils.Dictionary;

public class WeaponVO {

    public static const LIST: Vector.<WeaponVO> = new <WeaponVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: WeaponVO = new WeaponVO();
            object.id = row.id;
            object.name = row.name;
            object.picture = row.picture;
            object.damage = row.damage;
            object.drop_damage_range = row.dropdamagerange;
            object.damage_type = row.damagetype;

            LIST.push(object);
            DICT[object.id] = object;
        }
    }

    public var id: int;
    public var name: String;
    public var picture: String;
    public var damage: int;
    public var drop_damage_range: String;
    public var damage_type: int;
}
}
