/**
 * Created by agnither on 06.08.14.
 */
package com.agnither.hunters {
import com.agnither.hunters.data.Config;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.AIPlayer;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.utils.DeviceResInfo;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.popups.monsters.CatchedPetsView___not_used;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.hunters.view.ui.screens.hud.HudScreen;
import com.agnither.hunters.view.ui.screens.map.ChestPoint;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.ui.Popup;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.ResourcesManager;
import com.agnither.utils.ResourcesManager;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.core.coreRemoveListener;
import com.cemaprjl.viewmanage.ShowScreenCmd;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

public class App extends Sprite {



    private var _info : DeviceResInfo;
    private var _resources : ResourcesManager;
    private var _refs : CommonRefs;

    private var _ui : UI;



    public var chestStep : int = -1;
    public var steps : Vector.<MonsterVO>;
    public var chest : ChestPoint;

    private static var _instance : App;
    public static function get instance() : App {
        if (!_instance)
        {
            _instance = new App();
        }
        return _instance;
    }

//    private var _enemy : Player;
//    private var _drop : int = 0;
//    private var _monster : MonsterVO;

    private var _trapMode : Boolean = false;
    private var _tick : Ticker;
    private var _timeleft : Number = -1;

    public function App() {
        addEventListener(Event.ADDED_TO_STAGE, start);
        _instance = this;
    }

    public function start(e : Event = null) : void {

        removeEventListener(Event.ADDED_TO_STAGE, start);

        _info = DeviceResInfo.getInfo(Starling.current.nativeOverlay.stage);

        Config.init();

        _resources = new ResourcesManager(_info);

        coreAddListener(ResourcesManager.ON_COMPLETE_LOAD, handleComplete);

//        _resources.onComplete.addOnce(handleComplete);
        _resources.loadMain();
//        _resources.loadAnimations();
//        _resources.loadGUI();
//        _resources.loadGame();
        _resources.load();
    }



    private function handleComplete() : void {
        coreRemoveListener(ResourcesManager.ON_COMPLETE_LOAD, handleComplete);

//        if(!ResourcesManager.isLocal) {
//            handleInit();
//        } else {
//            coreAddListener(ResourcesManager.ON_COMPLETE_INIT, handleInit);
            initLocale();
            Config.parse(_resources.main);
            handleInit();
//        }
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
        var tex : Texture = _refs.gui.getTexture("camp");
        trace("camp", tex.height);

        _ui = new UI();

        _tick = new Ticker(stage);
        _tick.addTickCallback(eventGeneration);

        Model.instance.init();

//        coreAddListener(MapScreen.START_TRAP, onTrapStart);
//        coreAddListener(MapScreen.STOP_TRAP, onTrapEnd);

        stage.addChildAt(_ui, 0);

        coreExecute(ShowScreenCmd, MapScreen.NAME);
    }

    private function eventGeneration($delta : Number) : void {

        if (_timeleft <= 0)
        {
            generateEvent();
            _timeleft = MonsterAreaVO.LIST[0].chestrespawn * 1000;
        }
        else
        {
            _timeleft -= $delta;
        }
    }

    private function generateEvent() : void {

        coreDispatch(MapScreen.ADD_CHEST);
    }

    private function onTrapEnd() : void {
        _trapMode = false;
        coreDispatch(HudScreen.UPDATE);
    }

    private function onTrapStart() : void {
        _trapMode = true;
        coreDispatch(HudScreen.UPDATE);
    }

    public function get refs() : CommonRefs {
        return _refs;
    }

    public function get trapMode() : Boolean {
        return _trapMode;
    }

    public function get tick() : Ticker {
        return _tick;
    }

    public function get currentPopup() : Popup {
        return _ui.currentPopup;
    }
}
}
