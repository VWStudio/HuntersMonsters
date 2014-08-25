/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.hunters.model.player.personage.Hero;

import starling.events.EventDispatcher;

public class Player extends EventDispatcher {

    public static const UPDATE: String = "update_Player";

    protected var _inventory: Inventory;
    public function get inventory():Inventory {
        return _inventory;
    }

    protected var _hero: Hero;
    public function get hero():Hero {
        return _hero;
    }

    protected var _manaList: ManaList;
    public function get manaList():ManaList {
        return _manaList;
    }

    public function Player(data: Object) {
        _inventory = new Inventory();

        _hero = new Hero(_inventory);
        _hero.init(data);

        _manaList = new ManaList();
        _manaList.init();
        _manaList.addManaCounter(_hero.magic.name);
    }

    public function initInventory(items: Object, stock: Array, inventory: Array):void {
        _inventory.init();
        _inventory.parse(items);
        _inventory.setInventoryItems(inventory);
    }

    public function startMove():void {

    }

//    public function checkSpell(name: String):Boolean {
//        var spell: Spell = _inventory.getItem(name) as Spell;
//        return spell ? _manaList.checkSpell(spell) : false;
//    }
//
//    public function useSpell(name: String, target: Personage):void {
//        var spell: Spell = _inventory.getItem(name) as Spell;
//        spell.useSpell(target);
//        _manaList.useSpell(spell);
//    }

    public function update():void {
        dispatchEventWith(UPDATE);
    }
}
}
