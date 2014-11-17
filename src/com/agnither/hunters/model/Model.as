/**
 * Created by mor on 08.10.2014.
 */
package com.agnither.hunters.model {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.TrapVO;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.modules.items.Items;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.modules.monsters.Monsters;
import com.agnither.hunters.model.modules.players.SettingsVO;
import com.agnither.hunters.model.player.AIPlayer;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.Territory;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.model.player.personage.Progress;
import com.agnither.hunters.view.ui.popups.monsters.CatchedPetsView;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.hunters.view.ui.screens.map.HousePoint;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.hunters.view.ui.screens.map.MonsterPoint;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.utils.Util;
import com.cemaprjl.viewmanage.ShowScreenCmd;

import flash.utils.Dictionary;

public class Model {

    public static const MONSTER_CATCHED : String = "Model.MONSTER_CATCHED";

    private static var _instance : Model;
    public var state : String;
    public var movesAmount : int = 0;
    public var currentMonsterPoint : MonsterPoint;
    public static const UPDATE_HOUSE : String = "Model.UPDATE_HOUSE";
    public var currentTrap : TrapVO;
    public var territoryTraps : Object = {};
    public var chestAreas : Object = {};
    public static function get instance() : Model {
        if (!_instance)
        {
            _instance = new Model();
        }
        return _instance;
    }

    private var _territoryPoints : Dictionary = new Dictionary();
    private var _territoryTimeouts : Dictionary = new Dictionary();

    public var houses : Object = {};
    public var match3mode : String;
    public var currentHousePoint : HousePoint;

    public var monsters : Monsters;
    public var items : Items;
    public var territories : Dictionary = new Dictionary();
    public var player : LocalPlayer;
    public var monster : MonsterVO;
    public var drop : int;
    public var enemy : AIPlayer;
    public var progress : Progress;
    public var traps : Traps;
    public var shop : Shop;

    public function Model() {

        monsters = new Monsters();
        items = new Items();
        traps = new Traps();
        shop = new Shop();



        coreAddListener(Model.MONSTER_CATCHED, onMonsterCatched);

        coreAddListener(Match3Game.START_GAME, onStartGame);


    }

    private function fillTerritories() : void
    {

        for (var i : int = 0; i < MonsterAreaVO.LIST.length; i++)
        {
            var ma : MonsterAreaVO = MonsterAreaVO.LIST[i];
            var territory : Territory = new Territory(ma.clone());
            territories[ma.area] = territory; // if you get area by monster id or house
            territories[ma.id] = territory; // if you get area by clouds
            trace(i, ma.id, progress.unlockedLocations.indexOf(ma.id));
            territory.isUnlocked = progress.unlockedLocations.indexOf(ma.id) >= 0;
        }

    }

    public function init() : void {
        progress = new Progress();

        player = new LocalPlayer();
        player.init(progress);

        fillTerritories();

        App.instance.tick.addTickCallback(monsterGenerate);
    }

    private function onMonsterCatched() : void {
        var stars : int = 0;
        if(movesAmount < monster.stars[0]) {
            stars = 3;
        } else if(movesAmount < monster.stars[1]) {
            stars = 2;
        } else if(movesAmount < monster.stars[2]) {
            stars = 1;
        } else {
            stars = 0;
        }

        var isJustBeaten : Boolean = progress.unlockPointsGiven[monster.id] == null;

        trace("onMonsterCatched", isJustBeaten, Model.instance.progress.unlockPoints);

        progress.monstersResults[monster.id] = progress.monstersResults[monster.id] < stars ? stars : progress.monstersResults[monster.id];

        coreDispatch(MonsterPoint.STARS_UPDATE);

        if(isJustBeaten) {
            Model.instance.progress.unlockPoints += 1;

            coreDispatch(Territory.CAN_UNLOCK);
        }

//        var territory : Territory = Model.instance.territories[monster.id];

//        var monsterToUnlock : MonsterAreaVO = Model.instance.monsters.getNextArea(monster.id);
//        if (progress.unlockedLocations.indexOf(monsterToUnlock.id) == -1)
//        {
//            progress.unlockedLocations.push(monsterToUnlock.id);
//            progress.addExp(MonsterAreaVO.DICT[monsterToUnlock.id].expearned);
//        }

        var pet : Pet = new Pet(monster, monster);
//        pet.tame(false);
        pet.uniqueId = Util.uniq(pet.id);
        player.pets.addPet(pet);
//        progress.petsList[pet.uniqueId] = monsters.getMonster(monster.id, monster.level, monster);

        progress.saveProgress();
    }

    private function onStartGame($monster : MonsterVO) : void {

        player.resetToBattle();
        monster = $monster;
        drop = monster.drop;
        enemy = new AIPlayer(monster);

        coreExecute(ShowScreenCmd, BattleScreen.NAME);
    }






    public function addPlayerItem($item : Item) : void {
        player.addItem($item);
    }
    private function monsterGenerate($delta : Number) : void {


        for (var i : int = 0; i < progress.unlockedLocations.length; i++)
        {
            var territory : Territory = territories[progress.unlockedLocations[i]];
            territory.tick($delta);

        }


//        for (var monsterID : String in _territoryTimeouts)
//        {
//            var territory : MonsterAreaVO = monsters.getMonsterArea(monsterID);
//            var points : Vector.<MonsterPoint> = _territoryPoints[monsterID];
//            if(points.length < territory.area_max) {
//                _territoryTimeouts[monsterID] = _territoryTimeouts[monsterID] < 0 ? 0 : _territoryTimeouts[monsterID] - $delta;
//
//                if(state != MapScreen.NAME) continue;
//
//                if(_territoryTimeouts[monsterID] <= 0) {
//                    createPoint(monsterID);
//                    _territoryTimeouts[monsterID] = territory.respawn;
//                }
//            } else {
//
//            }
//        }
    }

//    public function deletePoint($point : MonsterPoint) : void {
//        if(currentMonsterPoint) return;
//        if(Model.instance.state != MapScreen.NAME) return;
//
//        var points : Vector.<MonsterPoint> = _territoryPoints[$point.monsterType.id];
//        var index : int = points.indexOf($point);
//        if(index > -1) {
//            points.splice(index, 1);
//        }
//        coreDispatch(MapScreen.DELETE_POINT, $point);
//
//
//        updatePoints();
//    }
//    private function createPoint($monsterID : String) : void {
//        if(Model.instance.state != MapScreen.NAME) return;
//
//        var mp : MonsterPoint = new MonsterPoint();
//        mp.monsterType = Model.instance.monsters.getRandomAreaMonster($monsterID);
//        var points : Vector.<MonsterPoint> = _territoryPoints[$monsterID];
//        points.push(mp);
//
//        coreDispatch(MapScreen.ADD_POINT, mp);
//
//    }
//    public function updatePoints() : void {
//
//        if(state != MapScreen.NAME) return;
//
//        for (var i : int = 0; i < progress.unlockedLocations.length; i++)
//        {
////            var monsterID : String = progress.unlockedLocations[i];
////            var territory : MonsterAreaVO = monsters.getMonsterArea(monsterID);
////            if(!_territoryPoints[monsterID]) {
////                _territoryPoints[monsterID]  = new <MonsterPoint>[];
////                _territoryTimeouts[monsterID]  = territory.respawn * 1000;
////            }
//            var points : Vector.<MonsterPoint> = _territoryPoints[monsterID];
//            if(points.length < territory.area_min) {
//                var monstersAmount : int = (territory.area_min + (territory.area_max - territory.area_min + 1) * Math.random()) - points.length;
//                for (var j : int = 0; j < monstersAmount; j++)
//                {
//                    createPoint(monsterID);
//                }
//            }
//        }
//    }


    public function createHouse($name : String) : void {
        var obj : Object = {};
        houses[$name] = obj;
        obj.owner = progress.houses.indexOf($name) >= 0 ? player.id : "";
//        obj.nextRandomItem = Model.instance.items.getRandomThing();
        // TODO get items according set
        obj.unlockItems = [Model.instance.items.getRandomThing(), Model.instance.items.getRandomThing(), Model.instance.items.getRandomThing()];
//        obj.timeLeft = (Math.random() * 20) * 1000;
        generateNewHouseItem($name);
//        obj.timeLeft = (Math.random() * 600) * 1000;



    }

    public function checkHouses() : void {
        for (var key : String in houses)
        {
            var house : Object = houses[key];
            if(house.owner == player.id && house.timeLeft > 0) {
                App.instance.tick.addTickCallback(housesTick);
            }
        }
    }

    private function housesTick($delta : int) : void {
        var changedHouses : int = 0;
        for (var key : String in houses)
        {
            var house : Object = houses[key];
            if(house.owner == player.id && house.timeLeft > 0) {
                house.timeLeft -= $delta;
                changedHouses++;
                if(house.timeLeft <= 0) {
                    house.timeLeft = 0;
                }
                coreDispatch(Model.UPDATE_HOUSE);
            }
        }

        if(changedHouses == 0) {
            App.instance.tick.removeTickCallback(housesTick);
        }
    }

    public function generateNewHouseItem($name : String) : void {

        var obj : Object = houses[$name];
        obj.nextRandomItem = Model.instance.items.getRandomThing();
        obj.timeLeft = (Math.random() * 500) * 1000;

    }

    public function getPrice($val : Number) : Number
    {
        return int($val * SettingsVO.DICT["pointValue"] + ( (SettingsVO.DICT["pointPercent"] + 100) / 100) * $val) ;
    }

    public function deleteCurrentPoint() : void
    {
        if(currentMonsterPoint != null) {
            var terr : Territory = territories[currentMonsterPoint.monsterType.id];
            terr.deletePoint(currentMonsterPoint);
        }
    }

    public function isMap() : Boolean
    {
        return state == MapScreen.NAME;
    }
}
}
