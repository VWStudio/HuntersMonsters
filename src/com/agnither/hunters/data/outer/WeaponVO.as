/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import com.agnither.hunters.data.inner.ItemVO;

import flash.utils.Dictionary;

public class WeaponVO extends ItemVO {

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

    public var damage: int;
    public var drop_damage_range: String;
    public var damage_type: int;

    public function get randomDamage():int {
        var minMax: Array = drop_damage_range.split("..");
        var min: int = minMax[0];
        var max: int = minMax[1];
        return min + Math.random() * (max+1 - min);
    }
}
}
