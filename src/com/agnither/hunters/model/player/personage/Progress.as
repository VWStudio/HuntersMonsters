/**
 * Created by mor on 22.09.2014.
 */
package com.agnither.hunters.model.player.personage {
import com.agnither.hunters.data.outer.LevelVO;
import com.agnither.hunters.data.outer.PlayerItemVO;
import com.agnither.hunters.data.outer.SkillVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.players.PlayerPetVO;
import com.agnither.hunters.model.modules.players.SettingsVO;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.utils.Util;
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
    public var areaStars : Object = {};
    public var unlockPointsGiven : Array = [];

    public var unlockedLocations : Array = [];
    public var tamedMonsters : Array = [];
    public var maxSummon : int = 1;
    public var skillPoints : int = 0;
    public var skills : Object = {};
    public static const SKILL_PREFIX : String = "skill.";
//    public var traps : Array = [];
    public var sets : Array = [];
    public var houses : Array = [];

    private var _pets : Object = {};
    private var _items : Object = {};
    private var _inventory : Array = [];
    public var unlockPoints : int = 0;
    public var fullExp : int = 0;
    public var campPosition : Object;
    public static const SETS_UPDATED : String = "Progress.SETS_UPDATED";

    public function Progress() {
        _data = SharedObject.getLocal("player");
//        version = -1;
//        _data.clear();
//        reset();

        if (version == -1 || !_data.data.progress || _data.data.version == null || _data.data.version != version)
        {
            trace("LOAD MOCKUP",version, _data.data.version != null, _data.data.progress != null);
//        if (version == -1 || _data.data.version == null || _data.data.version != version) {
            save(mockup());
        }

//        var obj : Object = JSON.parse(_data.data.progress);

//        trace("------load------");
//        trace(JSON.stringify(obj));

//        obj.items = _data.data.items ? JSON.parse(_data.data.items) : {};
        load();

        /**
         * CORRECT AND SAVE
         */
//        saveProgress();


    }

    public function reset() : void {
        _data.clear();
        _data.flush();
    }

    private function load() : void {

        var dataObj : Object = _data.data;
        var progressObj : Object = JSON.parse(dataObj.progress);

        trace(dataObj.progress);

        id = progressObj.id;
        name = progressObj.name;
        picture = progressObj.picture;
        level = progressObj.level;
        exp = progressObj.exp;
        fullExp = progressObj.fullExp;
        damage = 0;
//        damage = progressObj.damage;
        defence = 0;
//        defence = progressObj.defence;
        league = progressObj.league;
        rating = progressObj.rating;
        magic = progressObj.magic;
        gold = progressObj.gold;
        maxSummon = progressObj.maxSummon;
        skillPoints = progressObj.skillPoints;
        skills = progressObj.skills ? progressObj.skills : {};
        sets = progressObj.sets ? progressObj.sets : [];
        houses = progressObj.houses ? progressObj.houses : [];

        campPosition = progressObj.campPosition ? progressObj.campPosition : null;

        unlockPoints = progressObj.unlockPoints;

        unlockPointsGiven = progressObj.unlockPointsGiven ? progressObj.unlockPointsGiven : [];

        unlockedLocations = progressObj.unlockedLocations ? progressObj.unlockedLocations : [];
        areaStars = progressObj.areaStars ? progressObj.areaStars : {};

//        traps = progressObj.traps ? progressObj.traps : [];
        tamedMonsters = progressObj.tamedMonsters ? progressObj.tamedMonsters : [];
//        inventory = progressObj.inventory ? progressObj.inventory : [];

        _items = dataObj.items ? JSON.parse(dataObj.items) : {};
        trace(JSON.stringify(_items));
        _inventory = dataObj.inventory ? JSON.parse(dataObj.inventory) as Array : [];
        _pets = dataObj.pets ? JSON.parse(dataObj.pets) : {};

        recalculateHP();
    }

    public function recalculateHP() : int {
        if(level < 1) return 1;
        var baseHP : int = LevelVO.DICT[level.toString()].basehp;
        hp = baseHP * getSkillMultiplier("1");
        return baseHP;
    }

    public function saveProgress() : void {
        save(prepareData());
    }

    private function prepareData() : Object
    {
        var obj : Object = {};
        var str : String = JSON.stringify(this);
        trace(str);
        obj.progress = JSON.parse(str);
        obj.items = JSON.parse(JSON.stringify(Model.instance.player.inventory.items));
        obj.inventory = JSON.parse(JSON.stringify(Model.instance.player.inventory.inventoryItems));
        obj.pets = JSON.parse(JSON.stringify(Model.instance.player.pets.pets));

        return obj;
    }

    private function save($val : Object) : void {

        _data.data.version = version;

//        trace("------save------");
        for (var key : String in $val)
        {
            _data.data[key] = JSON.stringify($val[key]);
//            trace(key,"----------------------");
//            trace(_data.data[key]);
        }

        _data.flush();

        coreDispatch(UPDATED);
    }

    private function mockup() : Object {
        var saveObject : Object = {};

        var settings : Object = SettingsVO.DICT;

        var obj : Object = {};
        obj.id = "local player";
        obj.name = settings.playerInitialName;
//        obj.level = 20;
        obj.level = settings.playerInitialLevel;
        obj.exp = settings.playerInitialExp;
        obj.hp = settings.playerInitialHp;
        obj.damage = 0;
//        obj.damage = settings.playerInitialDmg;
        obj.defence = 0;
        obj.fullExp = 0;
//        obj.defence = settings.playerInitialDef;
        obj.league = settings.playerInitialLeague;
        obj.rating = settings.playerInitialRating;
        obj.magic = settings.playerInitialMagic;
        obj.gold = settings.playerInitialGold;
        obj.maxSummon = settings.playerInitialSummonMax;
//        obj.skillPoints = 10;
        obj.skillPoints = settings.playerInitialSkillPoints;
        obj.unlockPoints = settings.unlockPoints;
        obj.unlockPointsGiven = [];
        obj.skills = {};

//        obj.traps = [];
        obj.houses = [];
        obj.unlockedLocations = settings.unlockedLocations;
        obj.campPosition = null;
        obj.tamedMonsters = ["blue_bull"];
        obj.areaStars = {};
        obj.sets = ["default"];


        saveObject.items = {};
        saveObject.inventory = [];

        var playerItems : Vector.<PlayerItemVO> = PlayerItemVO.LIST;
        var i : int = 0;
        for (i = 0; i < playerItems.length; i++)
        {
            var playerItem : PlayerItemVO = playerItems[i];
            var item : ItemVO = Model.instance.items.getItemVO(playerItem.id);
//            trace(item.name, JSON.stringify(playerItem.ext));
//            trace(JSON.stringify(item));
            if(playerItem.ext) {
                item.ext = playerItem.ext;
            }
            trace("*",i,JSON.stringify(item));
            var itmName : String = Util.uniq(item.name);
            saveObject.items[itmName] = item;
            if (playerItem.wield)
            {
                saveObject.inventory.push(itmName);
            }
        }

        trace(JSON.stringify(saveObject.items));
        trace(JSON.stringify(saveObject.inventory));

        saveObject.pets = {};

        var playerPets : Vector.<PlayerPetVO> = PlayerPetVO.LIST;
        for (i = 0; i < playerPets.length; i++)
        {
            var playerPet : PlayerPetVO = playerPets[i];
            var monster : Object = Util.toObj(Model.instance.monsters.getMonster(playerPet.id, playerPet.level, playerPet));
            var petID : String = Util.uniq(monster.name);
            saveObject.pets[petID] = monster;
        }

        saveObject.progress = obj;

        return saveObject;
    }

    public function addExp($val : int) : void {


//        exp += $val;
        fullExp += $val;
        var lv : LevelVO = LevelVO.DICT[level];
//        if (exp >= lv.exp)
        if (fullExp >= lv.exp)
        {
            level++;
//            exp = exp - lv.exp;
//            if(exp < 0) {
//                exp = 0;
//            }
            skillPoints += 1;
            if (level % 5 == 0)
            {
                skillPoints += 1;
            }
            recalculateHP();
            Model.instance.player.hero.init(this);
        }


    }

    public function incSkill($id : String) : void {

        if(skillPoints == 0) return;

        var skill : SkillVO = SkillVO.DICT[$id];

        if(getSkillValue($id)) {
            skills[SKILL_PREFIX+$id] = Math.min(getSkillValue($id) + 1, skill.points);
        } else {
            skills[SKILL_PREFIX+$id] = 1;
        }

        skillPoints--;

        if($id == "10") {
            magic = 6;
        }
        if($id == "12") {
            magic = 7;
        }

        Model.instance.player.hero.init(this);
        Model.instance.player.resetMana();

        updateAfterSkill();
        recalculateHP();
        saveProgress();

    }

    private function updateAfterSkill() : void
    {




    }

    public function getSkillMultiplier($id : String) : Number {

        var skillVal : Number = getSkillValue($id);
        var returnVal : Number = 1;
        if(skillVal > 0)
        {
            returnVal = (1 + skillVal * SkillVO.DICT[$id].changevalue / 100);
        }
        return returnVal;
    }

    public function getSkillInc($id : String) : Number {

        var skillVal : Number = getSkillValue($id);
        var returnVal : Number = 0;
        if(skillVal > 0)
        {
            returnVal = skillVal * SkillVO.DICT[$id].changevalue;
        }
        return returnVal;
    }


    public function getSkillValue($id : String) : Number {
//        if(skills[SKILL_PREFIX+$id]) {
//            trace(SKILL_PREFIX+$id, skills[SKILL_PREFIX+$id]);
//        }
        return skills[SKILL_PREFIX+$id] != null ? skills[SKILL_PREFIX+$id] : 0;
    }

    public function getItems() : Object
    {
        return _items;
    }

    public function getInventory() : Array
    {
        return _inventory;
    }

    public function getPets() : Object
    {
        return _pets;
    }

//    public function getUnlockPoint() : void
//    {
//        unlockPoints = unlockPoints - 1 < 0 ? 0 : unlockPoints - 1;
//        saveProgress();
//    }

    public function unlockLocation($id : String) : void
    {
        if(unlockedLocations.indexOf($id) < 0) {
            unlockedLocations.push($id);
        }
//        trace("unlockedLocations", unlockedLocations);
        unlockPoints--;
        if(unlockPoints < 0) {
            unlockPoints = 0;
        }
        saveProgress();

    }

}
}
