/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.inner.InventoryVO;
import com.agnither.hunters.data.inner.PersonageVO;
import com.agnither.hunters.data.outer.MagicVO;
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.hunters.model.player.inventory.Spell;
import com.agnither.hunters.model.player.personage.Hero;
import com.agnither.hunters.model.player.personage.Personage;

import starling.events.EventDispatcher;

public class Player extends EventDispatcher {

    private var _inventory: Inventory;
    public function get inventory():Inventory {
        return _inventory;
    }

    private var _hero: Hero;
    public function get hero():Hero {
        return _hero;
    }

    private var _manaList: ManaList;
    public function get manaList():ManaList {
        return _manaList;
    }

    public function Player() {
        _inventory = new Inventory();

        _hero = new Hero(_inventory);

        _manaList = new ManaList();
    }

    public function init(data: PersonageVO, magic: int):void {
        _hero.init(data, magic);

        _manaList.init();
        _manaList.addManaCounter(MagicVO.DICT[_hero.magic].name);
    }

    public function initInventory(data: InventoryVO):void {
        for (var i:int = 0; i < data.spells.length; i++) {
            _inventory.addItem(data.spells[i]);
        }
        if (data.weapon) {
            _inventory.addItem(data.weapon);
        }
        for (i = 0; i < data.armor.length; i++) {
            _inventory.addItem(data.armor[i]);
        }
        for (i = 0; i < data.items.length; i++) {
            _inventory.addItem(data.items[i]);
        }
    }

    public function checkSpell(name: String):Boolean {
        var spell: Spell = _inventory.getItem(name);
        return _manaList.checkSpell(spell);
    }

    public function useSpell(name: String, target: Personage):void {
        var spell: Spell = _inventory.getItem(name);
        spell.useSpell(target);
        _manaList.useSpell(spell);
    }
}
}
