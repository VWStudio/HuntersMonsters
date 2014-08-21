/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import flash.utils.Dictionary;

import starling.events.EventDispatcher;

public class Inventory extends EventDispatcher {

    private var _items: Vector.<Item>;
    public function get items():Vector.<Item> {
        return _items;
    }

    private var _dict: Dictionary;
    public function getItem(name: String):Spell {
        return _dict[name];
    }

    private var _damage: int = -1;
    public function get damage():int {
        if (_damage < 0) {
            _damage = 0;
            for (var i:int = 0; i < _items.length; i++) {
                var weapon: Weapon = _items[i] as Weapon;
                if (weapon) {
                    _damage += weapon.damage;
                }
            }
        }
        return _damage;
    }

    private var _defence: int = -1;
    public function get defence():int {
        if (_defence < 0) {
            _defence = 0;
            for (var i:int = 0; i < _items.length; i++) {
                var armor: Armor = _items[i] as Armor;
                if (armor) {
                    _defence += armor.defence;
                }
            }
        }
        return _defence;
    }

    public function Inventory() {
        _items = new <Item>[];
        _dict = new Dictionary();
    }

    public function addItem(item: Item):void {
        _items.push(item);
        _dict[item.name] = item;
    }

    public function clearList():void {
        while (_items.length > 0) {
            var item: Item = _items.shift();
            item.destroy();
            delete _dict[item.name];
        }
    }
}
}
