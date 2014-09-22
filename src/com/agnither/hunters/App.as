/**
 * Created by agnither on 06.08.14.
 */
package com.agnither.hunters {
import com.agnither.hunters.data.Config;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.utils.DeviceResInfo;
import com.agnither.hunters.view.ui.UI;
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
        stage.addChildAt(_ui, 0);

        showMap();
    }

    private function showMap() : void {
        _ui.showScreen(MapScreen.ID);
        _ui.showScreen(HudScreen.ID);
    }

    public function get refs() : CommonRefs {
        return _refs;
    }
}
}
