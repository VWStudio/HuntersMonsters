/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.MagicVO;

import starling.events.EventDispatcher;

public class Personage extends EventDispatcher {

    public static const UPDATE: String = "update_Personage";
    public static const HIT: String = "hit_Personage";

    public function get name():String {
        return "No name";
    }

    public function get level():int {
        return 1;
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

    private var _armor: int;
    public function get armor():int {
        return _armor;
    }

    private var _damage: int;
    public function get damage():int {
        return _damage;
    }

    private var _magic: int;
    public function get magic():MagicVO {
        return MagicVO.DICT[_magic];
    }

    public function Personage() {
    }

    public function init(data: Object):void {
        _maxHP = data.hp;
        _hp = _maxHP;
        _armor = data.armor;
        _damage = data.damage;
        _magic = data.magic;
    }

    public function hit(value: int, ignoreArmor: Boolean = false):void {
        if (!ignoreArmor) {
            value -= _armor;
        }

        _hp -= value;
        _hp = Math.max(0, _hp);
        update();

        dispatchEventWith(HIT, false, value);
    }

    public function heal(value: int):void {
        _hp += value;
        _hp = Math.min(_hp, _maxHP);
        update();
    }

    public function update():void {
        dispatchEventWith(UPDATE);
    }
}
}
