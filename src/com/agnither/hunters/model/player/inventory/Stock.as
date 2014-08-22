/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.inner.ItemVO;
import com.agnither.hunters.data.outer.ArmorVO;
import com.agnither.hunters.data.outer.MagicItemVO;
import com.agnither.hunters.data.outer.SpellVO;
import com.agnither.hunters.data.outer.WeaponVO;

import flash.utils.Dictionary;

import starling.events.EventDispatcher;

public class Stock extends EventDispatcher {

    private var _weaponsObject: Object;
    private var _weapons: Vector.<Item>;
    public function get weapons():Vector.<Item> {
        return _weapons;
    }
    public function getWeapon(id: int):Weapon {
        return _weapons[id-1] as Weapon;
    }

    private var _armorsObject: Object;
    private var _armors: Vector.<Item>;
    public function get armors():Vector.<Item> {
        return _armors;
    }
    public function getArmor(id: int):Armor {
        return _armors[id-1] as Armor;
    }

    private var _itemsObject: Object;
    private var _items: Vector.<Item>;
    public function get items():Vector.<Item> {
        return _items;
    }
    public function getMagicItem(id: int):MagicItem {
        return _items[id-1] as MagicItem;
    }

    private var _spellsObject: Object;
    private var _spells: Vector.<Item>;
    public function get spells():Vector.<Item> {
        return _spells;
    }
    public function getSpell(id: int):Spell {
        return _spells[id-1] as Spell;
    }

    public function Stock() {
        _weapons = new <Item>[];
        _armors = new <Item>[];
        _items = new <Item>[];
        _spells = new <Item>[];
    }

    public function parse(data: Object):void {
        _weaponsObject = data.weapons;
        parseObjects(_weaponsObject, WeaponVO.DICT, _weapons, Weapon, "damage");

        _armorsObject = data.armors;
        parseObjects(_armorsObject, ArmorVO.DICT, _armors, Armor, "defence");

        _itemsObject = data.items;
        parseObjects(_itemsObject, MagicItemVO.DICT, _items, MagicItem);

        _spellsObject = data.spells;
        parseObjects(_spellsObject, SpellVO.DICT, _spells, Spell);
    }

    private function parseObjects(dict: Object, objectDict: Dictionary, list: Vector.<Item>, ItemClass: Class, param: String = null):void {
        for (var i: int = 1; i <= 100; i++) {
            var data: Object = dict[i];
            if (data) {
                var item: ItemVO = objectDict[data.id];
                var newItem: Item = param ? new ItemClass(item, data[param]) : new ItemClass(item);
                newItem.inventoryId = i;
                list.push(newItem);
            }
        }
    }

    public function addItem(item: Item):void {
        if (item is Weapon) {
            var weapon: Weapon = item as Weapon;
            _weapons.push(weapon);
            weapon.inventoryId = _weapons.length;
            _weaponsObject[weapon.inventoryId] = {id: weapon.id, damage: weapon.damage};
        } else if (item is Armor) {
            var armor: Armor = item as Armor;
            _armors.push(armor);
            armor.inventoryId = _armors.length;
            _armorsObject[armor.inventoryId] = {id: armor.id, defence: armor.defence};
        } else if (item is MagicItem) {
            var magicItem: MagicItem = item as MagicItem;
            _items.push(magicItem);
            magicItem.inventoryId = _items.length;
            _itemsObject[magicItem.inventoryId] = {id: magicItem.id};
        } else if (item is Spell) {
            var spell: Spell = item as Spell;
            _spells.push(spell);
            spell.inventoryId = _spells.length;
            _spellsObject[spell.inventoryId] = {id: spell.id};
        }
    }
}
}
