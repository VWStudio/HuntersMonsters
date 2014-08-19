/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.inner.PersonageVO;
import com.agnither.hunters.data.outer.MagicVO;

import starling.events.EventDispatcher;

public class Personage extends EventDispatcher {

    public static const UPDATE: String = "update_Personage";
    public static const HIT: String = "hit_Personage";

    private var _data: PersonageVO;
    public function get data():PersonageVO {
        return _data;
    }

    public function get name():String {
        return _data.name;
    }

    public function get level():int {
        return _data.level;
    }

    private var _hp: int;
    public function get hp():int {
        return _hp;
    }

    public function get maxHP():int {
        return _data.hp;
    }

    public function get dead():Boolean {
        return _hp <= 0;
    }

    public function get armor():int {
        return _data.defence;
    }

    public function get damage():int {
        return _data.damage;
    }

    public function get magic():MagicVO {
        return MagicVO.DICT[_data.magic];
    }

    public function get spells():Array {
        return _data.spells;
    }

    public function Personage() {
    }

    public function init(data: PersonageVO):void {
        _data = data;
        _hp = maxHP;
    }

    public function hit(value: int, ignoreArmor: Boolean = false):void {
        if (!ignoreArmor) {
            value -= armor;
        }

        _hp -= value;
        _hp = Math.max(0, _hp);
        update();

        dispatchEventWith(HIT, false, value);
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
