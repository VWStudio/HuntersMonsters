/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.outer.PlayerVO;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.personage.Progress;
import com.cemaprjl.core.coreAddListener;

import flash.net.SharedObject;

public class LocalPlayer extends Player {

    public static const ITEM_SELECTED: String = "LocalPlayer.ITEM_SELECTED";

    private static var version: int = 1;

    private var _data: SharedObject;

    private var _progress : Progress;

    public function LocalPlayer() {
        _data = SharedObject.getLocal("player");

        _progress = new Progress();

        if (!_data.data.version || _data.data.version < version) {
            createProgress(1);
        }

        super();

        init(_data.data);
        initInventory(_data.data.items, _data.data.inventory);
        initPets(_data.data.pets);


        coreAddListener(LocalPlayer.ITEM_SELECTED, selectItem);
    }


    override public function init(data : Object) : void {

        _progress.init(data.map);

        super.init(data);
    }

    private function createProgress(level: int):void {
        var player: PlayerVO = PlayerVO.DICT[level];
        _data.data.name = player.name;
        _data.data.level = player.level;
        _data.data.exp = player.exp;
        _data.data.hp = player.hp;
        _data.data.damage = player.damage;
        _data.data.defence = player.defence;

        _data.data.league = player.league;
        _data.data.rating = player.rating;

        _data.data.magic = 5;
        _data.data.gold = player.gold;

        _data.data.items = {"weapon.1": {id: 1, extension: {1: 15}},
                            "armor.2": {id: 4, extension: {2: 15}},
                            "spell.3": {id: 13, extension: {1: 10, 3: 4, 9: 1}}};
        _data.data.inventory = ["weapon.1", "armor.2", "spell.3"];

        /**
         * unlocked regions and pets
         */
        _data.data.map = {"regions": ["00"], monsters:["blue_bull"]};

        _data.data.pets = {"pet.1": {id: 1, name: "blue_bull", level: 2, hp: 150, damage: 10, defence: 10, magic: 6, tamed: 1},
                           "pet.2": {id: 2, name: "blue_bull", level: 3, hp: 250, damage: 20, defence: 20, magic: 6, tamed: 1},
                           "pet.3": {id: 3, name: "blue_bull", level: 1, hp: 100, damage: 5, defence: 5, magic: 5, tamed: 0}};


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

    public function get progress() : Progress {
        return _progress;
    }

    public function reset() : void {

    }
}
}
