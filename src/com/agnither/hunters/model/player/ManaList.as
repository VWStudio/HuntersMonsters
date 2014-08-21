/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.outer.MagicVO;
import com.agnither.hunters.model.player.inventory.Spell;

import flash.utils.Dictionary;

import starling.events.EventDispatcher;

public class ManaList extends EventDispatcher {

    private var _list: Vector.<Mana>;
    public function get list():Vector.<Mana> {
        return _list;
    }

    private var _dict: Dictionary;
    public function getMana(type: String):Mana {
        return _dict[type];
    }

    public function ManaList() {
        _list = new <Mana>[];
        _dict = new Dictionary();
    }

    public function init():void {
        addManaCounter(MagicVO.NATURE);
        addManaCounter(MagicVO.WATER);
        addManaCounter(MagicVO.FIRE);
    }

    public function addManaCounter(type: String):void {
        var mana: Mana = new Mana(type);
        _list.push(mana);
        _dict[type] = mana;
    }

    public function addMana(type: String, value: int):void {
        var mana: Mana = _dict[type];
        if (mana) {
            mana.addMana(value);
        }
    }

    public function releaseMana(type: String, value: int):Boolean {
        var mana: Mana = _dict[type];
        return mana && mana.releaseMana(value);
    }

    public function emptyMana(type: String):void {
        var mana: Mana = _dict[type];
        if (mana) {
            mana.emptyMana();
        }
    }

    public function checkMana(type: String, value: int):Boolean {
        var mana: Mana = _dict[type];
        return mana && mana.value >= value;
    }

    public function checkSpell(spell: Spell):Boolean {
        var mana: Array = spell.mana;
        for (var i:int = 0; i < mana.length; i++) {
            var manaData: Array = mana[i].split(":");
            var manaType: MagicVO = MagicVO.DICT[manaData[0]];
            if (!checkMana(manaType.name, manaData[1])) {
                return false;
            }
        }
        return true;
    }

    public function useSpell(spell: Spell):void {
        var mana: Array = spell.mana;
        for (var i:int = 0; i < mana.length; i++) {
            var manaData: Array = mana[i].split(":");
            var manaType: MagicVO = MagicVO.DICT[manaData[0]];
            releaseMana(manaType.name, manaData[1]);
        }
    }

    public function clearList():void {
        while (_list.length > 0) {
            var mana: Mana = _list.shift();
            mana.destroy();
            delete _dict[mana.type];
        }
    }
}
}
