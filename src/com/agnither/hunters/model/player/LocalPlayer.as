/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.inner.InventoryVO;
import com.agnither.hunters.data.outer.PlayerVO;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.inventory.Stock;

import flash.net.SharedObject;

public class LocalPlayer extends Player {

    private var _data: SharedObject;

    private var _stock: Stock;
    public function get stock():Stock {
        return _stock;
    }

    private var _inventoryData: InventoryVO;

    public function LocalPlayer() {
        _data = SharedObject.getLocal("player");
//
//        _data.clear();
//        _data.flush();
        if (!_data.data.id) {
            createProgress(1);
        }

        super(_data.data);

        _stock = new Stock();
        _stock.parse(_data.data.stock);

        loadInventory();
    }

    private function loadInventory():void {
//        _inventoryData = new InventoryVO();
//        for (var i:int = 0; i < _data.data.inventory.spells.length; i++) {
//            _inventoryData.spells.push(_stock.getSpell(_data.data.inventory.spells[i]));
//        }
//        if (_data.data.inventory.weapon > 0) {
//            _inventoryData.weapon = _stock.getWeapon(_data.data.inventory.weapon);
//        }
//        for (i = 0; i < _data.data.inventory.armor.length; i++) {
//            _inventoryData.armor.push(_stock.getArmor(_data.data.inventory.armor[i]));
//        }
//        initInventory(_inventoryData);
    }

    private function createProgress(level: int):void {
        _data.data.gold = 0;
        _data.data.stock = {};
        _data.data.stock.weapons = {};
        _data.data.stock.armors = {};
        _data.data.stock.items = {};
        _data.data.stock.spells = {};

        var player: PlayerVO = PlayerVO.DICT[level];
        _data.data.name = "Player";
        _data.data.level = player.level;
        _data.data.hp = player.hp;
        _data.data.damage = player.damage;
        _data.data.defence = player.defence;

        _data.data.magic = 5;

        _data.data.inventory = [];
        _data.data.inventory.weapon = 0;
        _data.data.inventory.armor = [];
        _data.data.inventory.items = [];
        _data.data.inventory.spells = [];

        _data.flush();
    }

    public function addGold(amount: int):void {
        _data.data.gold += amount;
    }

    public function addItem(item: Item):void {
        _stock.addItem(item);
    }

    public function selectItem(item: Item):void {
//        if (item is Weapon) {
//            _data.data.weapon = item.inventoryId;
//        } else if (item is Armor) {
//            _data.data.armor.push(item.inventoryId);
//        } else if (item is MagicItem) {
//            _data.data.items.push(item.inventoryId);
//        } else if (item is Spell) {
//            _data.data.spells.push(item.inventoryId);
//        }
//        _inventory.addItem(item);
    }

    public function save():void {
        _data.flush();
    }
}
}
