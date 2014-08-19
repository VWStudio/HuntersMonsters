/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.outer.MagicVO;
import com.agnither.hunters.data.outer.SpellVO;

import starling.events.EventDispatcher;

public class Spell extends EventDispatcher {

    private var _spell: SpellVO;

    public function get name():String {
        return _spell.name;
    }

    public function get damage():int {
        return _spell.damage;
    }

    public function get picture():String {
        return _spell.picture;
    }

    public function get mana():Array {
        return _spell.mana;
    }

    private var _selected: Boolean;
    public function get selected():Boolean {
        return _selected;
    }

    public function Spell(name: String) {
        _spell = SpellVO.DICT[name];
    }

    public function select(value: Boolean):void {
        _selected = value;
    }

    public function useSpell(target: Personage):void {
        target.hit(damage, true);
    }

    public function destroy():void {
        _spell = null;
    }
}
}
