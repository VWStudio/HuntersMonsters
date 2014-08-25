/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.outer.PlayerVO;
import com.agnither.hunters.model.player.inventory.Item;

import flash.net.SharedObject;

public class LocalPlayer extends Player {

    private var _data: SharedObject;

    public function LocalPlayer() {
        _data = SharedObject.getLocal("player");

        _data.clear();
        _data.flush();
        if (!_data.data.name) {
            createProgress(1);
        }

        super(_data.data);

        initInventory(_data.data.items, _data.data.stock, _data.data.inventory);
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
        _data.data.stock = ["weapon.1", "armor.2", "spell.3"];
        _data.data.inventory = ["weapon.1", "armor.2", "spell.3"];

        _data.data.gold = 0;

        save();
    }

    public function addGold(amount: int):void {
        _data.data.gold += amount;
        save();
    }

    public function addItem(item: Item):void {
        _inventory.addItem(item);
    }

    public function selectItem(item: Item):void {
//        _inventory.selectItem(item);
        _data.data.inventory = _inventory.inventoryItems;
        save();
    }

    public function save():void {
        _data.flush();
    }
}
}
