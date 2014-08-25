/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.outer.PlayerVO;
import com.agnither.hunters.model.player.inventory.Item;

import flash.net.SharedObject;

public class LocalPlayer extends Player {

    private static var version: int = 1;

    private var _data: SharedObject;

    public function LocalPlayer() {
        _data = SharedObject.getLocal("player");

        if (!_data.data.version || _data.data.version < version) {
            createProgress(1);
        }

        super();

        init(_data.data);
        initInventory(_data.data.items, _data.data.inventory);
        initPets(_data.data.pets);
    }

    private function createProgress(level: int):void {
        var player: PlayerVO = PlayerVO.DICT[level];
        _data.data.name = "Player";
        _data.data.level = player.level;
        _data.data.hp = player.hp;
        _data.data.damage = player.damage;
        _data.data.defence = player.defence;

        _data.data.magic = 5;

        _data.data.items = {"weapon.1": {id: 1, extension: {1: 15}},
                            "armor.2": {id: 4, extension: {2: 15}},
                            "spell.3": {id: 13, extension: {1: 10, 3: 4, 9: 1}}};
        _data.data.inventory = ["weapon.1", "armor.2", "spell.3"];

        _data.data.pets = {"pet.1": {id: 1, name: "bluebull", level: 2, hp: 150, damage: 10, defence: 10, magic: 6, tamed: 1},
                           "pet.2": {id: 2, name: "bluebull", level: 3, hp: 250, damage: 20, defence: 20, magic: 6, tamed: 1},
                           "pet.3": {id: 3, name: "bluebull", level: 1, hp: 100, damage: 5, defence: 5, magic: 5, tamed: 0}};

        _data.data.gold = 0;

        save();
    }

    public function addGold(amount: int):void {
        _data.data.gold += amount;
    }

    public function addItem(item: Item):void {
        _inventory.addItem(item);
    }

    public function selectItem(item: Item):void {
        if (item.isWearing) {
            _inventory.unwearItem(item);
        } else {
            _inventory.wearItem(item);
        }
        _data.data.inventory = _inventory.inventoryItems;
    }

    public function save():void {
        _data.flush();
    }
}
}
