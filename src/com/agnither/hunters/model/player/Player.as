/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.model.player.inventory.PetsInventory;
import com.agnither.hunters.model.player.inventory.Spell;
import com.agnither.hunters.model.player.personage.Hero;
import com.agnither.hunters.model.player.personage.Monster;
import com.agnither.hunters.model.player.personage.Personage;

import starling.events.EventDispatcher;

public class Player extends EventDispatcher {

//    public static const UPDATE: String = "update_Player";

    public var id : String = "0";

    protected var _inventory: Inventory;
    public function get inventory():Inventory {
        return _inventory;
    }

    protected var _pets: PetsInventory;
    public function get pets():PetsInventory {
        return _pets;
    }

    protected var _hero: Hero;
    public function get hero():Hero {
        return _hero;
    }

    protected var _pet: Monster;
    public function get pet():Monster {
        return _pet;
    }

    protected var _manaList: ManaList;
    public function get manaList():ManaList {
        return _manaList;
    }

    public function Player() {
        _inventory = new Inventory();

        _pets = new PetsInventory();

        _hero = new Hero(_inventory);
        _pet = new Monster();

        _manaList = new ManaList();
    }

    public function init(data: Object):void {
        _hero.init(data);

        resetMana();
    }
    public function resetMana():void {
        _manaList.init();
        _manaList.addManaCounter(_hero.magic.name);
    }

    public function initInventory(items: Object, inventory: Array):void {
        _inventory.init();
        _inventory.parse(items);
        _inventory.setInventoryItems(inventory);
    }

    public function initPets(pets: Object):void {
        _pets.init();
        _pets.parse(pets);
    }

    public function startMove():void {

    }

    public function summonPet(pet: Pet):void {
        _pet.summon(pet);
    }

    public function checkSpell(id: String):Boolean {
        var spell: Spell = _inventory.getItem(id) as Spell;
        return spell ? _manaList.checkSpell(spell) : false;
    }

    public function useSpell(id: String, target: Personage):void {
        var spell: Spell = _inventory.getItem(id) as Spell;
        spell.useSpell(target);
        _manaList.useSpell(spell);
    }
}
}
