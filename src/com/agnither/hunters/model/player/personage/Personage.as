/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player.personage {
import com.agnither.hunters.data.inner.PersonageVO;
import com.agnither.hunters.data.outer.DamageTypeVO;

import starling.events.EventDispatcher;

public class Personage extends EventDispatcher {

    public static const UPDATE: String = "update_Personage";
    public static const HIT: String = "hit_Personage";
    public static const DEAD: String = "dead_Personage";

    private var _name: String;
    public function get name():String {
        return _name;
    }

    public function get picture():String {
        return null;
    }

    private var _level: int;
    public function get level():int {
        return _level;
    }

    private var _hp: int;
    public function get hp():int {
        return _hp;
    }

    private var _maxHP: int;
    public function get maxHP():int {
        return _maxHP;
    }

    public function get dead():Boolean {
        return _hp <= 0;
    }

    private var _damage: int;
    public function get damage():int {
        return _damage;
    }

    private var _defence: int;
    public function get defence():int {
        return _defence;
    }

    private var _magic: int;
    public function get magic():DamageTypeVO {
        return DamageTypeVO.DICT[_magic];
    }

    public function Personage() {
    }

    public function init(data: Object):void {
        _name = data.name;
        _level = data.level;
        _maxHP = data.hp;
        _hp = _maxHP;
        _damage = data.damage;
        _defence = data.defence;
        _magic = data.magic;
    }

    public function hit(value: int, ignoreDefence: Boolean = false):void {
        if (!ignoreDefence) {
            value -= defence;
        }
        value = Math.max(0, value);

        _hp -= value;
        _hp = Math.max(0, _hp);
        update();

        dispatchEventWith(HIT, false, value);

        if (dead) {
            dispatchEventWith(DEAD);
        }
    }

    public function heal(value: int):void {
        _hp += value;
        _hp = Math.min(_hp, maxHP);
        update();
    }

    public function update():void {
        dispatchEventWith(UPDATE);
    }
}
}
