/**
 * Created by mor on 22.09.2014.
 */
package com.agnither.hunters.model.player.personage {
import com.agnither.hunters.data.outer.LevelVO;
import com.agnither.hunters.data.outer.PlayerItemVO;
import com.agnither.hunters.data.outer.SkillVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.players.PlayerPetVO;
import com.agnither.hunters.model.modules.players.SettingsVO;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.utils.Util;

import flash.net.SharedObject;
import flash.utils.Dictionary;

import starling.events.EventDispatcher;

public class Progress extends EventDispatcher {

    public static const UPDATED : String = "Progress.UPDATED";

    private var _data : SharedObject;
    private static var version : int = 2;
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
    public var tamedMonsters : Array = [];
    public var items : Object = {};
    public var inventory : Array = [];
    public var pets : Object = {};
    public var maxSummon : int = 1;
    public var skillPoints : int = 0;
    public var skills : Object = {};
    public static const SKILL_PREFIX : String = "skill.";


    public function Progress() {
        _data = SharedObject.getLocal("player");
//        version = -1;
//        _data.clear();
        if (version == -1 || !_data.data.progress || _data.data.version == null || _data.data.version != version)
        {
//        if (version == -1 || _data.data.version == null || _data.data.version != version) {
            save(mockup());
        }

        var obj : Object = JSON.parse(_data.data.progress);

        trace("------load------");
        trace(JSON.stringify(obj));

        obj.items = _data.data.items ? JSON.parse(_data.data.items) : {};
        load(obj);

        /**
         * CORRECT AND SAVE
         */
//        saveProgress();

    }

    public function reset() : void {
        _data.clear();
        _data.flush();
    }

    private function load($val : Object) : void {


        id = $val.id;
        name = $val.name;
        picture = $val.picture;
        level = $val.level;
        exp = $val.exp;
        damage = $val.damage;
        defence = $val.defence;
        league = $val.league;
        rating = $val.rating;
        magic = $val.magic;
        gold = $val.gold;
        maxSummon = $val.maxSummon;
        skillPoints = $val.skillPoints;
//        skills = {};
        skills = $val.skills ? $val.skills : {};

        unlockedMonsters = $val.unlockedMonsters ? $val.unlockedMonsters : [];
        tamedMonsters = $val.tamedMonsters ? $val.tamedMonsters : [];
        monstersResults = $val.monstersResults ? $val.monstersResults : {};

        items = $val.items ? $val.items : {};
        inventory = $val.inventory ? $val.inventory : [];

        pets = $val.pets ? $val.pets : {};

        recalculateHP();
    }

    public function recalculateHP() : int {
        if(level < 1) return 1;
        var baseHP : int = LevelVO.DICT[level.toString()].basehp;
        if(getSkillValue("1")) {
            var amount : int = getSkillValue("1");
            for (var i : int = 0; i < amount; i++)
            {
                baseHP *= 1.1;
            }
        }

        hp = baseHP;
        trace("recalc HP", hp, " - ", level, LevelVO.DICT[level].basehp);
        return baseHP;
    }

    public function saveProgress() : void {
        save(this);
    }

    private function save($val : Object) : void {

        _data.data.version = version;

        trace("------save------");
        var obj : Object = JSON.parse(JSON.stringify($val));


        // move items to another SO branch to lightweight output
        _data.data.items = JSON.stringify(obj.items);
        delete obj.items;

        trace(JSON.stringify(obj));
        _data.data.progress = JSON.stringify(obj);

        _data.flush();

        coreDispatch(UPDATED);
    }

    private function mockup() : Object {
        trace("--- mockup ---");

        var settings : Object = SettingsVO.DICT;

        var obj : Object = {};
        obj.id = "local player";
        obj.name = settings.playerInitialName;
        obj.level = settings.playerInitialLevel;
        obj.exp = settings.playerInitialExp;
        obj.hp = settings.playerInitialHp;
        obj.damage = settings.playerInitialDmg;
        obj.defence = settings.playerInitialDef;
        obj.league = settings.playerInitialLeague;
        obj.rating = settings.playerInitialRating;
        obj.magic = settings.playerInitialMagic;
        obj.gold = settings.playerInitialGold;
        obj.maxSummon = settings.playerInitialSummonMax;
        obj.skillPoints = settings.playerInitialSkillPoints;
        obj.skills = {};

        obj.items = {};
        obj.inventory = [];

        trace("settings: ",JSON.stringify(settings));
        trace("mock: ",JSON.stringify(obj));

        var playerItems : Vector.<PlayerItemVO> = PlayerItemVO.LIST;
        var i : int = 0;
        for (i = 0; i < playerItems.length; i++)
        {
            var playerItem : PlayerItemVO = playerItems[i];
            var item : Object = Model.instance.items.getItem(playerItem.id);
            item.extension = playerItem.extension;
            var itmName : String = item.name + "." + i;
            obj.items[itmName] = item;
            if (playerItem.wield)
            {
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

    public function addExp($val : int) : void {


        exp += $val;
        var lv : LevelVO = LevelVO.DICT[level];
        if (exp >= lv.exp)
        {
            level++;

            exp = exp - lv.exp;
            skillPoints += 1;
            if (level % 5 == 0)
            {
                skillPoints += 1;
            }
            recalculateHP();
        }


    }

    public function incSkill($id : String) : void {

        var skill : SkillVO = SkillVO.DICT[$id];

        if(getSkillValue($id)) {
            skills[SKILL_PREFIX+$id] = Math.min(getSkillValue($id) + 1, skill.points);
        } else {
            skills[SKILL_PREFIX+$id] = 1;
        }

        skillPoints--;

        recalculateHP();
        saveProgress();

    }

    public function getSkillValue($id : String) : Number {
        return skills[SKILL_PREFIX+$id] != null ? skills[SKILL_PREFIX+$id] : 0;
    }
}
}
