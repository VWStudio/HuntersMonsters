/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data {
import flash.utils.Dictionary;

public class MonsterVO {

    public static const LIST: Vector.<MonsterVO> = new <MonsterVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: MonsterVO = new MonsterVO();
            object.id = row.id;
            object.name = row.name;
            object.picture = row.picture;
            object.level = row.level;
            object.hp = row.hp;
            object.damage = row.damage;
            object.defence = row.defence;
            object.magic = row.magic;
            object.difficulty = row.difficulty;
            object.drop = row.drop;
            object.weapon = row.weapon;
            object.armor = row.armor ? row.armor.split(",") : [];
            object.item = row.item ? row.item.split(",") : [];
            object.spells = row.spells ? row.spells.split(",") : [];

            LIST.push(object);
            DICT[object.id] = object;
        }
    }

    public var id: int;
    public var name: String;
    public var picture: String;
    public var level: int;
    public var hp: int;
    public var damage: int;
    public var defence: int;
    public var magic: int;
    public var difficulty: int;
    public var drop: int;
    public var weapon: int;
    public var armor: Array;
    public var item: Array;
    public var spells: Array;
}
}
