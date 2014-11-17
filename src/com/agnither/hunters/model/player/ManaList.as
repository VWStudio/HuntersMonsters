/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.model.player.inventory.Item;
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
        clearList();

        addManaCounter(MagicTypeVO.fire.name);
        addManaCounter(MagicTypeVO.water.name);
//        addManaCounter(MagicTypeVO.nature.name);
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

    public function checkSpell($item: Item):Boolean {
        if(!$item.isSpell()) return false;

        var mana: Object = $item.mana;
        for (var key: * in mana) {
            var manaType: MagicTypeVO = MagicTypeVO.DICT[key];
            if (!checkMana(manaType.name, mana[key])) {
                return false;
            }
        }
        return true;
    }

    public function useSpell($item: Item):void {
        if(!$item.isSpell()) return;

        var mana: Object = $item.mana;
        for (var key: * in mana) {
            var manaType: MagicTypeVO = MagicTypeVO.DICT[key];
            releaseMana(manaType.name, mana[key]);
        }
    }

    public function clearList():void {
        while (_list.length > 0) {
            var mana: Mana = _list.shift();
            delete _dict[mana.type];
            mana.destroy();
        }
    }
}
}
