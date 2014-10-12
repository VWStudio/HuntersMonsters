/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.data.outer.PlayerItemVO;
import com.agnither.hunters.model.modules.players.PlayerPetVO;
import com.agnither.hunters.model.modules.players.PlayerVO;
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

        id = "player user";

        _progress = new Progress();

        if (_data.data.version == null || _data.data.version != version) {
            createProgress();
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

    private function createProgress():void {
        var player: PlayerVO = PlayerVO.LIST[0].clone();
        var playerItems : Vector.<PlayerItemVO> = PlayerItemVO.LIST;
        var playerPets : Vector.<PlayerPetVO> = PlayerPetVO.LIST;
//        var player: PlayerVO = PlayerVO.DICT[level];
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

        _data.data.items = {};
        _data.data.inventory = [];
        for (var i : int = 0; i < playerItems.length; i++)
        {
            var playerItemVO : PlayerItemVO = playerItems[i];
            var itemVO : ItemVO = Model.instance.items.getItem(playerItemVO.id);
            itemVO.extension = playerItemVO.extension;
            var itmName : String = itemVO.name + "."+i;
            _data.data.items[itmName] = itemVO;
            _data.data.inventory.push(itmName);
        }

        trace(JSON.stringify(_data.data.items));
        trace(_data.data.inventory);

        _data.data.version = 1;

        _data.data.unlockedMonsters = ["blue_bull"];


        _data.data.pets = {};
        for (var j : int = 0; j < playerPets.length; j++)
        {
            var playerPetVO : PlayerPetVO = playerPets[j].clone();
            var monsterVO : MonsterVO = Model.instance.monsters.getMonster(playerPetVO.id, playerPetVO);
            var itmName2 : String = monsterVO.name + "."+j;
            _data.data.pets[itmName2] = monsterVO;
        }

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
//        _data.data.version = ++version;
        _data.flush();
    }

    public function get progress() : Progress {
        return _progress;
    }

    public function reset() : void {
        _data.clear();
        _data.flush();
    }

    public function set unlockedMonsters(arr : Array) : void {
           _data.data.unlockedMonsters = arr;
    }
    public function get unlockedMonsters() : Array {
           return _data.data.unlockedMonsters;
    }

    public function resetToBattle() : void {
        hero.healMax();
        pet.unsummon();
    }
}
}
