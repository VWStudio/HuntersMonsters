/**
 * Created by mor on 08.10.2014.
 */
package com.agnither.hunters.model {
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.modules.items.Items;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.modules.monsters.Monsters;
import com.agnither.hunters.model.player.AIPlayer;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.view.ui.popups.monsters.PetsView;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.hunters.view.ui.screens.map.HousePoint;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.viewmanage.ShowScreenCmd;

import flash.utils.Dictionary;

public class Model {

    public static const UPDATE_PROGRESS : String = "Model.UPDATE_PROGRESS";

    private static var _instance : Model;
    public var state : String;
    public static function get instance() : Model {
        if (!_instance)
        {
            _instance = new Model();
        }
        return _instance;
    }

    public var houses : Object = {};
    public var match3mode : String;
    public var currentHousePoint : HousePoint;

    public var monsters : Monsters;
    public var items : Items;
    public var monsterAreas : Dictionary = new Dictionary();
//    public var unlockedMonsters : Array = ["blue_bull"];
    public var player : LocalPlayer;
    public var monstersResults : Object = {};
    public var monster : MonsterVO;
    public var drop : int;
    public var enemy : AIPlayer;

    public function Model() {

        monsters = new Monsters();
        items = new Items();
        coreAddListener(Model.UPDATE_PROGRESS, onProgress);
        coreAddListener(PetsView.PET_SELECTED, handlePetSelected);
        coreAddListener(Match3Game.START_GAME, onStartGame);
    }

    private function onProgress() : void {

        monstersResults[monster.id] = 1 + int(Math.random() * 3);
        var monsterToUnlock : MonsterVO = Model.instance.monsters.getMonster(monster.unlock);
//        var monsterToUnlock : MonsterVO = MonsterVO.DICT[_monster.unlock];
        if (player.unlockedMonsters.indexOf(monsterToUnlock.id) == -1)
        {
            player.unlockedMonsters.push(monsterToUnlock.id);
            monstersResults[monsterToUnlock.id] = 0;
        }

        player.save();
    }

    private function onStartGame($monster : MonsterVO) : void {

        trace("onStartGame", $monster.name);
        player.resetToBattle();
        monster = $monster;
        drop = monster.drop;
        enemy = new AIPlayer(monster);

        coreExecute(ShowScreenCmd, BattleScreen.NAME);
    }



    private function handlePetSelected(pet : Pet) : void {
        player.summonPet(pet);
    }

    public function init() : void {
        player = new LocalPlayer();
        monstersResults["blue_bull"] = 0; // stars
    }
}
}
