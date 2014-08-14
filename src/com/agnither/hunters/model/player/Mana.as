/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.MagicVO;

import starling.events.EventDispatcher;

public class Mana extends EventDispatcher {

    public static const UPDATE: String = "update_Mana";

    private var _magic: MagicVO;
    public function get type():String {
        return _magic.name;
    }

    public function get icon():String {
        return _magic.picture;
    }

    private var _value: int;
    public function get value():int {
        return _value;
    }

    public function Mana(type: String) {
        _magic = MagicVO.DICT[type];
        _value = 0;
    }

    public function addMana(value: int):void {
        _value += value;
        update();
    }

    public function releaseMana(value: int):Boolean {
        if (_value < value) {
            return false;
        }

        _value -= value;
        _value = Math.max(0, _value);
        update();

        return true;
    }

    public function emptyMana():void {
        _value = 0;
        update();
    }

    private function update():void {
        dispatchEventWith(UPDATE);
    }

    public function destroy():void {
        _magic = null;
        _value = 0;
    }
}
}
