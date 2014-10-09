/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import com.agnither.hunters.data.inner.PersonageVO;

import flash.utils.Dictionary;

public dynamic class PlayerPetVO {

    public static const LIST: Vector.<PlayerPetVO> = new <PlayerPetVO>[];
    public static const DICT: Dictionary = new Dictionary();
    public var radius : Number;

    public static function fill($target : PlayerPetVO, $source : Object) : PlayerPetVO {
        $target.id = $source.id;
        $target.name = $source.name;
        $target.level = $source.level;
        $target.hp = $source.hp;
        $target.damage = $source.damage;
        $target.defence = $source.defence;
        $target.magic = $source.magic;
        $target.tamed = $source.tamed;

        /*
         "id": "pikachu",
         "name": "Коник",
         "level": 3,
         "hp": 200,
         "damage": 20,
         "defence": 5,
         "magic": 5,
         "tamed": 0
         */



        return $target;
    }

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {

            var source: Object = data[i];

            var object: PlayerPetVO = new PlayerPetVO();
            object = fill(object, source);

            LIST.push(object);
            DICT[object.id] = object;
        }
    }



    public var id: String;
    public var name: String = "";
    public var level: int = 0;
    public var hp: int = 0;
    public var damage: int = 0;
    public var defence: int = 0;
    public var magic: int;
    public var tamed: int;

    public function clone() : PlayerPetVO {
        return fill(new PlayerPetVO(), this);
    }
}
}
