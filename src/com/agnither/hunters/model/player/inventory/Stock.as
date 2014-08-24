/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.ItemVO;

import flash.utils.Dictionary;

import starling.events.EventDispatcher;

public class Stock extends EventDispatcher {

    private var _itemsDict: Dictionary;

    public function Stock() {
    }

    public function parse(data : Object) : void {
        _itemsDict = new Dictionary();
        for (var key: * in data) {
            var itemData: Object = data[key];
            var item : ItemVO = ItemVO.DICT[itemData.id];
            var newItem : Item = new Item(item, itemData);
            newItem.uniqueId = key;
//            list.push(newItem);
        }
    }

    public function addItem(item : Item) : void {
//        if (item is Weapon)
//        {
//            var weapon : Weapon = item as Weapon;
//            _weapons.push(weapon);
//            weapon.inventoryId = _weapons.length;
//            _weaponsObject[weapon.inventoryId] = {id: weapon.id, damage: weapon.damage};
//        }
//        else if (item is Armor)
//        {
//            var armor : Armor = item as Armor;
//            _armors.push(armor);
//            armor.inventoryId = _armors.length;
//            _armorsObject[armor.inventoryId] = {id: armor.id, defence: armor.defence};
//        }
//        else if (item is MagicItem)
//        {
//            var magicItem : MagicItem = item as MagicItem;
//            _items.push(magicItem);
//            magicItem.inventoryId = _items.length;
//            _itemsObject[magicItem.inventoryId] = {id: magicItem.id};
//        }
//        else if (item is Spell)
//        {
//            var spell : Spell = item as Spell;
//            _spells.push(spell);
//            spell.inventoryId = _spells.length;
//            _spellsObject[spell.inventoryId] = {id: spell.id};
//        }
    }
}
}
