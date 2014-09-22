/**
 * Created by agnither on 06.08.14.
 */
package com.agnither.hunters {
import com.agnither.hunters.data.Config;
import com.agnither.hunters.data.outer.MonsterVO;
import com.agnither.hunters.model.Match3Game;
import com.agnither.hunters.model.match3.Cell;
import com.agnither.hunters.model.player.AIPlayer;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.drop.DropSlot;
import com.agnither.hunters.model.player.drop.GoldDrop;
import com.agnither.hunters.model.player.drop.ItemDrop;
import com.agnither.hunters.model.player.inventory.Spell;
import com.agnither.hunters.utils.DeviceResInfo;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.popups.InventoryPopup;
import com.agnither.hunters.view.ui.popups.SelectMonsterPopup;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.hunters.view.ui.screens.battle.match3.FieldView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.BattleInventoryView;
import com.agnither.hunters.view.ui.screens.hud.HudScreen;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.ResourcesManager;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;

public class App extends Sprite {

    private var _info: DeviceResInfo;

    private var _resources: ResourcesManager;

//    private var _preloader: PreloaderScreen;
    private var _refs : CommonRefs;
    private var _ui : UI;

    private static var _instance : App;
    public static function get instance() : App {
        if(!_instance) {
            _instance = new App();
        }
        return _instance;
    }

    private var _player : LocalPlayer;
    private var _game : Match3Game;
    public function get player():LocalPlayer {
        return _player;
    }

    public function App() {
        addEventListener(Event.ADDED_TO_STAGE, start);
        _instance = this;
    }

    public function start(e: Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, start);

        _info = DeviceResInfo.getInfo(Starling.current.nativeOverlay.stage);

        Config.init();

        _resources = new ResourcesManager(_info);

//        _controller = new GameController(stage, _resources);

//        _preloader = new PreloaderScreen(_controller.refs);
//        addChild(_preloader);
//        _resources.onProgress.add(_preloader.progress);

        _resources.onComplete.addOnce(handleComplete);
        _resources.loadMain();
//        _resources.loadAnimations();
        _resources.loadGUI();
//        _resources.loadGame();
        _resources.load();
    }

    private function handleComplete():void {
//        _resources.onComplete.addOnce(handleLoadAnimation);
        _resources.onComplete.addOnce(handleInit);

//        SoundManager.init();

        initLocale();
        Config.parse(_resources.main);
    }

    private function initLocale():void {
//        LocalizationManager.init("ru");
//        LocalizationManager.parse(_resources.main.getObject("locale"));
    }

    private function handleLoadAnimation():void {
//        _resources.onComplete.addOnce(handleLoadGUI);
        _resources.onComplete.addOnce(handleInit);
    }

    private function handleLoadGUI():void {
        _resources.onComplete.addOnce(handleInit);
    }

    private function handleInit():void {

        _refs = new CommonRefs(_resources);

        _player = new LocalPlayer();

        _ui = new UI();

        _ui.addEventListener(Match3Game.START_GAME, onStartGame);
//        _ui.addEventListener(BattleScreen.SELECT_MONSTER, handleSelectMonster);

        stage.addChildAt(_ui, 0);

        showMap();
    }

//    private function handleSelectMonster(e: Event):void {
//        _ui.showPopup(SelectMonsterPopup.ID);
//    }

    private function handleSelectSpell(e: Event):void {
        if (!(_game.currentPlayer is AIPlayer)) {
            var spell: Spell = e.data as Spell;
            if (spell && _game.checkSpell(spell)) {
                _game.useSpell(spell);
            }
        }
    }

    private function onStartGame(event : Event) : void {
        _ui.hideScreen();
        startGame(event.data as MonsterVO);
    }

    public function startGame(monster: MonsterVO):void {
        var enemy: Player = new AIPlayer(monster);
        if(!_game) {
            _game = new Match3Game(stage);
        }
        _game.init(_player, enemy, monster.drop);
        _game.addEventListener(Match3Game.END_GAME, handleEndGame);

        _ui.showScreen(BattleScreen.ID);
//
//        _ui.showPopup(InventoryPopup.ID);

    }

        public function endGame():void {
        _game.removeEventListener(Match3Game.END_GAME, handleEndGame);

        _ui.hideScreen();
        showMap();

    }


        private function handleEndGame(e: Event):void {
        for (var i:int = 0; i < _game.dropList.list.length; i++) {
            var drop: DropSlot = _game.dropList.list[i];
            if (drop.content) {
                if (drop.content is GoldDrop) {
                    var gold: GoldDrop = drop.content as GoldDrop;
                    _player.addGold(gold.gold);
                } else if (drop.content is ItemDrop) {
                    var item: ItemDrop = drop.content as ItemDrop;
                    _player.addItem(item.item);
                }
            }
        }
        _player.save();

        endGame();
    }

    private function showMap() : void {
        _ui.showScreen(MapScreen.ID);
        _ui.showScreen(HudScreen.ID);
    }

    public function get refs() : CommonRefs {
        return _refs;
    }

    public function get game() : Match3Game {
        return _game;
    }
}
}
