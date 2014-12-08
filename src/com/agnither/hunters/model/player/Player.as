/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player
{
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.extensions.SpellDefenceExt;
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.model.player.inventory.PetsInventory;
import com.agnither.hunters.model.player.personage.Hero;
import com.agnither.hunters.model.player.personage.Monster;
import com.agnither.hunters.model.player.personage.Personage;

import starling.events.EventDispatcher;

public class Player extends EventDispatcher
{

//    public static const UPDATE: String = "update_Player";

    public var id : String = "0";

    protected var _inventory : Inventory;
    public function get inventory() : Inventory
    {
        return _inventory;
    }

    protected var _pets : PetsInventory;
    public function get pets() : PetsInventory
    {
        return _pets;
    }

    protected var _hero : Hero;
    public function get hero() : Hero
    {
        return _hero;
    }

    protected var _pet : Monster;
    public function get pet() : Monster
    {
        return _pet;
    }

    protected var _manaList : ManaList;
    private var _isCurrent : Boolean = false;

    public function get manaList() : ManaList
    {
        return _manaList;
    }

    public function Player()
    {
        _inventory = new Inventory();

        _pets = new PetsInventory();

        _hero = new Hero(_inventory);

        _pet = new Monster();

        _manaList = new ManaList();
    }

    public function init(data : Object) : void
    {
        _hero.init(data);

        resetMana();
    }

    public function resetMana() : void
    {
        _manaList.init();
        _manaList.addManaCounter(_hero.magic.name);
        addSkillMana();

    }

    private function addSkillMana() : void
    {
        for (var i : int = 0; i < _manaList.list.length; i++)
        {
            var mana : Mana = _manaList.list[i];
            switch (mana.type)
            {
                case MagicTypeVO.FIRE:
                    mana.addMana(Model.instance.progress.getSkillInc("5"));
                    break;
                case MagicTypeVO.WATER:
                    mana.addMana(Model.instance.progress.getSkillInc("6"));
                    break;
                case MagicTypeVO.NATURE:
                    mana.addMana(Model.instance.progress.getSkillInc("7"));
                    break;
                case MagicTypeVO.DARK:
                    mana.addMana(Model.instance.progress.getSkillInc("11"));
                    break;
                case MagicTypeVO.STONE:
                    mana.addMana(Model.instance.progress.getSkillInc("13"));
                    break;
            }

            /*
             nature
             water
             fire
             dark
             stone
             */


        }
    }

    public function initInventory(items : Object, inventory : Array) : void
    {
        _inventory.init();
        _inventory.parse(items);
        _inventory.setInventoryItems(inventory);
    }

    public function initPets(pets : Object) : void
    {
        _pets.init();
        _pets.parse(pets);
    }

    public function startMove() : void
    {

    }

    public function handleSummonPet(pet : Pet) : void
    {
        _pet.summon(pet);
    }

    public function checkSpell(id : String) : Boolean
    {
        var item : Item = _inventory.getItem(id);
        return (item && item.isSpell()) ? _manaList.checkSpell(item) : false;
    }

    public function useSpell(id : String, target : Personage) : void
    {
        var spell : Item = _inventory.getItem(id);
        if (!spell.isSpell())
        {
            return;
        }
        var dmg : Number = spell.getDamage();
        if (this == Model.instance.player)
        {
            dmg = dmg * Model.instance.progress.getSkillMultiplier("8");
        }
        else
        {
            if (Model.instance.spellsDefence.length > 0)
            {
                for (var i : int = 0; i < Model.instance.spellsDefence.length; i++)
                {
                    var sd : SpellDefenceExt = Model.instance.spellsDefence[i] as SpellDefenceExt;
                    if (sd && sd.getType() == spell.type)
                    {
                        dmg -= sd.getAmount();
                    }
                }
            }
        }
        target.hit(int(dmg), true);
//        target.hit(spell.getDamage(), true);
//        spell.useSpell(target);
        _manaList.useSpell(spell);
    }

    public function set isCurrent($val : Boolean) : void
    {
        _isCurrent = $val;
        _hero.current = _isCurrent;
        _hero.update();
    }

    public function get damageType() : String
    {
        return _hero.damageType;
    }
}
}
