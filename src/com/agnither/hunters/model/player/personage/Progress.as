/**
 * Created by mor on 22.09.2014.
 */
package com.agnither.hunters.model.player.personage {
import com.agnither.hunters.data.outer.PlayerItemVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.modules.players.PlayerPetVO;
import com.agnither.hunters.model.modules.players.PlayerVO;
import com.cemaprjl.utils.Util;

import flash.net.SharedObject;

import starling.events.EventDispatcher;

public class Progress extends EventDispatcher {

    private var _data: SharedObject;
    private static var version: int = 2;
    public var id : String = "";
    public var name : String = "";
    public var picture : String = "";
    public var level : int = 0;
    public var exp : int = 0;
    public var hp : int = 0;
    public var damage : int = 0;
    public var defence : int = 0;
    public var league : int = 0;
    public var rating : int = 0;
    public var magic : int = 0;
    public var gold : int = 0;
    public var monstersResults : Object = {};
    public var unlockedMonsters : Array = [];
    public var items : Object = {};
    public var inventory : Array = [];
    public var pets : Object = {};


    public function Progress() {
        _data = SharedObject.getLocal("player");
//        version = -1;
        if (version == -1 || !_data.data.progress || _data.data.version == null || _data.data.version != version) {
//        if (version == -1 || _data.data.version == null || _data.data.version != version) {
            save(mockup());
        }
        load(JSON.parse(_data.data.progress));
    }

    public function reset() : void {
        _data.clear();
        _data.flush();
    }

    private function load($val : Object) : void {
        trace("------load------");
        trace(JSON.stringify($val));

        id = $val.id;
        name = $val.name;
        picture = $val.picture;
        level = $val.level;
        exp = $val.exp;
        hp = $val.hp;
        damage = $val.damage;
        defence = $val.defence;
        league = $val.league;
        rating = $val.rating;
        magic = $val.magic;
        gold = $val.gold;

        unlockedMonsters = $val.unlockedMonsters ? $val.unlockedMonsters : [];
        monstersResults = $val.monstersResults ? $val.monstersResults : {};

        items = $val.items ? $val.items : {};
        inventory = $val.inventory ? $val.inventory : [];

        pets = $val.pets ? $val.pets : {};
    }

    public function saveProgress() : void {
        save(this);
    }
    private function save($val : Object) : void {

        trace("------save------");
        trace(JSON.stringify($val));

        _data.data.version = version;
        _data.data.progress = JSON.stringify($val);
        _data.flush();
    }

    private function mockup():Object {
        var player: PlayerVO = PlayerVO.LIST[0];

        var obj : Object = {};
        obj.id = "local player";
//        obj.id = player.id;
        obj.name = player.name;
        obj.picture = player.picture;
        obj.level = player.level;
        obj.exp = player.exp;
        obj.hp = player.hp;
        obj.damage = player.damage;
        obj.defence = player.defence;
        obj.league = player.league;
        obj.rating = player.rating;
        obj.magic = player.magic;
        obj.gold = player.gold;

        obj.items = {};
        obj.inventory = [];
        var playerItems : Vector.<PlayerItemVO> = PlayerItemVO.LIST;
        var i : int = 0;
        for (i = 0; i < playerItems.length; i++)
        {
            var playerItem : PlayerItemVO = playerItems[i];
            var item : Object = Model.instance.items.getItem(playerItem.id);
            item.extension = playerItem.extension;
            var itmName : String = item.name + "."+i;
            obj.items[itmName] = item;
            if(playerItem.wield) {
                obj.inventory.push(itmName);
            }
        }

        obj.pets = {};
        var playerPets : Vector.<PlayerPetVO> = PlayerPetVO.LIST;
        for (i = 0; i < playerPets.length; i++)
        {
            var playerPet : PlayerPetVO = playerPets[i];
            var monster : Object = Util.toObj(Model.instance.monsters.getMonster(playerPet.id, playerPet.level, playerPet));
            var petID : String = Util.uniq(monster.name);
            obj.pets[petID] = monster;
        }

        obj.unlockedMonsters = ["blue_bull"];
        obj.monstersResults = {};

        return obj;
    }
}
}
