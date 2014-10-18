/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player.personage {
import com.agnither.hunters.model.modules.players.PersonageVO;
import com.agnither.hunters.data.outer.DamageTypeVO;

import starling.events.EventDispatcher;

public class Personage extends EventDispatcher {

    public static const UPDATE: String = "update_Personage";
    public static const HIT: String = "hit_Personage";
    public static const DEAD: String = "dead_Personage";

    public var name: String;
    public var id: String;
    public var exp : int = 0;
    public var league : int = 0;
    public var rating : int = 0;
    public var gold : int = 0;
    public var picture : String;
    public var level: int = 0;
    public var hp: int = 0;
    public var maxHP: int = 0;
    private var _damage: int = 0;
    private var _defence: int = 0;

    public function get isDead():Boolean {
        return hp <= 0;
    }

    private var _magic: int = 0;
    public function get magic():DamageTypeVO {
        return DamageTypeVO.DICT[_magic];
    }

    public function Personage() {
    }

    public function init(data: Object):void {
        name = data.name;
        id = data.id;
        level = data.level;
        maxHP = data.hp;
        hp = maxHP;
        _damage = data.damage;
        _defence = data.defence;
        _magic = data.magic;

        exp = data.exp;
        gold = data.gold;
        league = data.league;
        rating = data.rating;
        picture = data.picture;
    }

    public function hit(value: int, ignoreDefence: Boolean = false):void {
        if (!ignoreDefence) {
            value -= defence;
        }
        value = Math.max(0, value);

        hp -= value;
        hp = Math.max(0, hp);
        update();

        dispatchEventWith(HIT, false, value);

        if (isDead) {
            dispatchEventWith(DEAD);
        }
    }

    public function heal(value: int):void {
        hp += value;
        hp = Math.min(hp, maxHP);
        update();
    }

    public function update():void {
        dispatchEventWith(UPDATE);
    }

    public function get damage() : int {
        return _damage;
    }

    public function get defence() : int {
        return _defence;
    }
}
}
