/**
 * Created by agnither on 06.08.14.
 */
package com.agnither.hunters {
import com.agnither.hunters.data.Config;
import com.agnither.hunters.data.outer.MonsterVO;
import com.agnither.hunters.model.Match3Game;
import com.agnither.hunters.model.player.AIPlayer;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.model.player.personage.Monster;
import com.agnither.hunters.utils.DeviceResInfo;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.popups.monsters.PetsView;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.ResourcesManager;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.core.coreRemoveListener;
import com.cemaprjl.viewmanage.ShowScreenCmd;

import flash.utils.Dictionary;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;

public class App extends Sprite {

    private var _info : DeviceResInfo;

    private var _resources : ResourcesManager;

//    private var _preloader: PreloaderScreen;
    private var _refs : CommonRefs;
    private var _ui : UI;

    private static var _instance : App;
    public var monsterAreas : Dictionary = new Dictionary();
    public var unlockedMonsters : Array = ["blue_bull"];
    public static const UPDATE_PROGRESS : String = "App.UPDATE_PROGRESS";
    public static function get instance() : App {
        if (!_instance)
        {
            _instance = new App();
        }
        return _instance;
    }

    private var _player : LocalPlayer;
//    private var _game : Match3Game;
    private var _enemy : Player;
    private var _drop : int = 0;
    private var _monster : MonsterVO;
    private var _monstersResults : Object = {};

    public function get player() : LocalPlayer {
        return _player;
    }

    public function App() {
        addEventListener(Event.ADDED_TO_STAGE, start);
        _instance = this;
    }

    public function start(e : Event = null) : void {

        removeEventListener(Event.ADDED_TO_STAGE, start);

        _info = DeviceResInfo.getInfo(Starling.current.nativeOverlay.stage);

        Config.init();

        _resources = new ResourcesManager(_info);

//        _controller = new GameController(stage, _resources);

//        _preloader = new PreloaderScreen(_controller.refs);
//        addChild(_preloader);
//        _resources.onProgress.add(_preloader.progress);

        coreAddListener(ResourcesManager.ON_COMPLETE, handleComplete);
        coreAddListener(App.UPDATE_PROGRESS, onProgress);
//        _resources.onComplete.addOnce(handleComplete);
        _resources.loadMain();
//        _resources.loadAnimations();
        _resources.loadGUI();
//        _resources.loadGame();
        _resources.load();
    }

    private function onProgress() : void {

        _monstersResults[_monster.id] = 1 + int(Math.random() * 3);
        var monsterToUnlock : MonsterVO = MonsterVO.DICT[_monster.unlock];
        if(unlockedMonsters.indexOf(monsterToUnlock.name) == -1) {
            unlockedMonsters.push(monsterToUnlock.name);
            _monstersResults[monsterToUnlock.id] = 0;
        }

    }

    private function handleComplete() : void {
        coreRemoveListener(ResourcesManager.ON_COMPLETE, handleComplete);
        coreAddListener(ResourcesManager.ON_COMPLETE, handleInit);
//        _resources.onComplete.addOnce(handleLoadAnimation);
//        _resources.onComplete.addOnce(handleInit);

//        SoundManager.init();

        initLocale();
        Config.parse(_resources.main);
    }

    private function initLocale() : void {
//        LocalizationManager.init("ru");
//        LocalizationManager.parse(_resources.main.getObject("locale"));
    }

    private function handleLoadAnimation() : void {
//        _resources.onComplete.addOnce(handleLoadGUI);
        // XXX commented, not in use
//        _resources.onComplete.addOnce(handleInit);
    }

    private function handleLoadGUI() : void {
        // XXX commented, not in use
//        _resources.onComplete.addOnce(handleInit);
    }

    private function handleInit() : void {

        _refs = new CommonRefs(_resources);

        _player = new LocalPlayer();

        _ui = new UI();

        coreAddListener(Match3Game.START_GAME, onStartGame);
        coreAddListener(PetsView.PET_SELECTED, handlePetSelected);

//        _ui.addEventListener(BattleScreen.SELECT_MONSTER, handleSelectMonster);

        stage.addChildAt(_ui, 0);

        _monstersResults[1] = 0; // stars

        coreExecute(ShowScreenCmd, MapScreen.NAME);
    }

//    private function onSelectItem(item: Item) : void {
//        _player.selectItem(item);
//    }

    private function onStartGame(monster : MonsterVO) : void {
        _monster = monster;
        _drop = monster.drop;
        _enemy = new AIPlayer(monster);

        coreExecute(ShowScreenCmd, BattleScreen.NAME);

//        startGame(monster);
    }

    private function handlePetSelected(pet : Pet) : void {
        _player.summonPet(pet);
    }

//    public function startGame(monster : MonsterVO) : void {
//        var enemy : Player = new AIPlayer(monster);
//        if (!_game)
//        {
//            _game = new Match3Game(stage);
//        }
//        _game.init(_player, enemy, monster.drop);
//
//        coreAddListener(Match3Game.END_GAME, handleEndGame);
//
//        coreExecute(ShowScreenCmd, BattleScreen.NAME);
//    }

//    public function endGame() : void {
//
//    }


//    private function handleEndGame($isWin : Boolean) : void {
//
//        for (var i : int = 0; i < _game.dropList.list.length; i++)
//        {
//            var drop : DropSlot = _game.dropList.list[i];
//            if (drop.content)
//            {
//                if (drop.content is GoldDrop)
//                {
//                    var gold : GoldDrop = drop.content as GoldDrop;
//                    _player.addGold(gold.gold);
//                }
//                else if (drop.content is ItemDrop)
//                {
//                    var item : ItemDrop = drop.content as ItemDrop;
//                    _player.addItem(item.item);
//                }
//            }
//        }
//        _player.save();
//        coreRemoveListener(Match3Game.END_GAME, handleEndGame);
//        coreExecute(ShowPopupCmd, WinPopup.NAME, {isWin : $isWin});
////        coreExecute(ShowScreenCmd, MapScreen.NAME);
//    }

    public function get refs() : CommonRefs {
        return _refs;
    }

//    public function get game() : Match3Game {
//        return _game;
//    }

    public function get enemy() : Player {
        return _enemy;
    }

    public function get drop() : int {
        return _drop;
    }

    public function get monster() : com.agnither.hunters.data.outer.MonsterVO {
        return _monster;
    }

    public function get monstersResults() : Object {
        return _monstersResults;
    }
}
}
