/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import com.agnither.hunters.data.inner.PersonageVO;

import flash.utils.Dictionary;

public dynamic class MonsterVO extends PersonageVO {

    public static const LIST: Vector.<MonsterVO> = new <MonsterVO>[];
    public static const DICT: Dictionary = new Dictionary();
    public var radius : Number;

    public static function fill($target : MonsterVO, $source : Object) : MonsterVO {
        $target.id = $source.id;
        $target.name = $source.name;
        $target.picture = $source.picture;

        $target.level = $source.level;
        $target.hp = $source.hp;
        $target.damage = $source.damage;
        $target.defence = $source.defence;

        $target.area = $source.area;
        $target.unlock = $source.unlock;

        $target.magic = $source.magic;

        $target.difficulty = $source.difficulty;
        $target.drop = $source.drop;

        $target.weapon = $source.weapon;
        $target.armor = $source.armor;
        $target.items = $source.items;
        $target.spells = $source.spells;

        return $target;
    }

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {

            var source: Object = data[i];
            source.armor = source.armor ? source.armor.split(",") : [];
            source.items = source.items ? source.items.split(",") : [];
            source.spells = source.spells ? source.spells.split(",") : [];

            var object: MonsterVO = new MonsterVO();
            object = fill(object, source);

            LIST.push(object);
            DICT[object.id] = object;
        }
    }



    public var id: String;
    public var picture: String;
    public var area : String;
    public var unlock : String;

    public var magic: int;

    public var difficulty: int;
    public var drop: int;

    public var weapon: int;
    public var armor: Array;
    public var items: Array;
    public var spells: Array;

    public function clone() : MonsterVO {
        return fill(new MonsterVO(), this);
    }
}
}
