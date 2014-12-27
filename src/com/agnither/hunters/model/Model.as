/**
 * Created by mor on 08.10.2014.
 */
package com.agnither.hunters.model
{
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.TrapVO;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.modules.extensions.DoubleDropExt;
import com.agnither.hunters.model.modules.extensions.ManaAddExt;
import com.agnither.hunters.model.modules.extensions.MirrorDamageExt;
import com.agnither.hunters.model.modules.extensions.ResurrectPetExt;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.items.Items;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.modules.monsters.Monsters;
import com.agnither.hunters.model.modules.players.SettingsVO;
import com.agnither.hunters.model.player.AIPlayer;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.Territory;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.model.player.personage.Monster;
import com.agnither.hunters.model.player.personage.Progress;
import com.agnither.hunters.view.ui.common.GoldView;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.hunters.view.ui.screens.map.MonsterPoint;
import com.agnither.ui.Popup;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.utils.Util;
import com.cemaprjl.viewmanage.ShowScreenCmd;

import flash.utils.Dictionary;

public class Model
{

    public static const MONSTER_CATCHED : String = "Model.MONSTER_CATCHED";

    private static var _instance : Model;
    public var state : String;
    public var movesAmount : int = 0;
    public var currentMonsterPoint : MonsterPoint;
    public static const UPDATE_HOUSE : String = "Model.UPDATE_HOUSE";
//    public var currentTrap : TrapVO;
//    public var territoryTraps : Object = {};
    public var chestAreas : Object = {};
    public var doubleDrop : DoubleDropExt;
    public var mirrorDamage : MirrorDamageExt;
    public var manaAdd : ManaAddExt;
    public var spellsDefence : Array = [];
    public var resurrectPet : ResurrectPetExt;
    public var summonTimes : int = 0;
    public var flashvars : Object;
    public var screenMoved : Boolean;
    public static const RESET_GAME : String = "Model.RESET_GAME";
    public var itemsTooltip : GoldView;
    public var currentPopup : Popup;
    public var currentPopupName : String;

    public static function get instance() : Model
    {
        if (!_instance)
        {
            _instance = new Model();
        }
        return _instance;
    }

//    private var _territoryPoints : Dictionary = new Dictionary();
//    private var _territoryTimeouts : Dictionary = new Dictionary();

//    public var houses : Object = {};
    public var match3mode : String;
    public var currentHouseTerritory : Territory;

    public var monsters : Monsters;
    public var items : Items;
    public var territories : Dictionary = new Dictionary();
    public var player : LocalPlayer;
    public var monster : MonsterVO;
    public var drop : int;
    public var enemy : AIPlayer;
    public var progress : Progress;
//    public var traps : Traps;
    public var shop : Shop;
    public var deliverTime : Number = -1;

    public function Model()
    {

        monsters = new Monsters();
        items = new Items();

//        traps = new Traps();
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
            territory.isUnlocked = progress.unlockedLocations.indexOf(ma.area) >= 0;
        }


    }

    public function init() : void
    {
        progress = new Progress();

        player = new LocalPlayer();
        player.init(progress);

        fillTerritories();

        items.updateItems();

        MonsterAreaVO.NAMES_LIST = MonsterAreaVO.NAMES_LIST.sort(sortNames);

        App.instance.tick.addTickCallback(territoriesTick);
    }

    private static function sortNames($a : String, $b : String) : Number
    {
        var monsterA : MonsterVO = MonsterVO.DICT_BY_TYPE[$a][0];
        var monsterB : MonsterVO = MonsterVO.DICT_BY_TYPE[$b][0];
        if(monsterA.order < monsterB.order) return -1;
        if(monsterA.order > monsterB.order) return 1;
        return 0;


    }

    private function onMonsterCatched() : void
    {

        var territory : Territory = territories[monster.id];
        territory.handleMonsterWin(calcStars());

        var isJustBeaten : Boolean = progress.unlockPointsGiven.indexOf(monster.id) < 0;
        progress.areaStars[territory.area.area] = territory.getStars();
//        Model.instance.progress.saveProgress();

        if (isJustBeaten)
        {


            if(territory.area.unlockhouse) {
                (Model.instance.territories[territory.area.unlockhouse] as Territory).unlock();
            }


            Model.instance.progress.unlockPointsGiven.push(monster.id);
            Model.instance.progress.unlockPoints += 1;
            Model.instance.progress.saveProgress();

            coreDispatch(Territory.CAN_UNLOCK);
        }



        var petItem : Item = Item.create(ItemVO.createPetItemVO(monster));

        player.inventory.addItem(petItem);

//        var pet : Pet = new Pet(monster, monster);
//        pet.uniqueId = Util.uniq(pet.id);
//        player.pets.addPet(pet);

        progress.saveProgress();

        monster = null;
        movesAmount = 0;
    }

    private function onStartGame($monster : MonsterVO) : void
    {

        player.resetToBattle();
        monster = $monster;
        drop = monster.drop;
        enemy = new AIPlayer(monster);
        summonTimes = 0;
        coreExecute(ShowScreenCmd, BattleScreen.NAME);
    }


    public function addPlayerItem($item : Item) : void
    {
        player.addItem($item);
    }

    private function territoriesTick($delta : Number) : void
    {
        for (var i : int = 0; i < progress.unlockedLocations.length; i++)
        {
            var territory : Territory = territories[progress.unlockedLocations[i]];
            territory.tick($delta);
        }

        updateDeliver($delta);
    }

    private function updateDeliver($delta : Number) : void
    {
        deliverTime -= $delta;
        if(deliverTime <= 0) {
            deliverTime = SettingsVO.DICT["shopDeliverTimeMin"] * 60 * 1000;
            shop.updateGoods();
            coreDispatch(Shop.NEW_DELIVER);
        }
        else
        {
            coreDispatch(Shop.DELIVER_TIME);
        }
    }




    public function getPrice($val : Number, $coeffName : String) : Number
    {
        var mult : Number = SettingsVO.DICT[$coeffName + "PriceMult"];
        return Math.round($val * $val * mult);
    }

    public function deleteCurrentPoint() : void
    {
        if (currentMonsterPoint != null)
        {
            var terr : Territory = territories[currentMonsterPoint.monsterType.id];
            terr.deletePoint(currentMonsterPoint);
        }
    }

    public function isMap() : Boolean
    {
        return state == MapScreen.NAME;
    }

    public function calcStars() : int
    {
        var stars : int = 0;
        if (movesAmount < monster.stars[0])
        {
            stars = 3;
        }
        else if (movesAmount < monster.stars[1])
        {
            stars = 2;
        }
        else if (movesAmount < monster.stars[2])
        {
            stars = 1;
        }


        return stars;
    }
}
}
