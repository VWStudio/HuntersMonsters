/**
 * Created by agnither on 06.08.14.
 */
package com.agnither.hunters {
import com.agnither.hunters.data.Config;
import com.agnither.hunters.utils.DeviceResInfo;
import com.agnither.utils.ResourcesManager;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;

public class App extends Sprite {

    private var _info: DeviceResInfo;

    private var _resources: ResourcesManager;

    private var _controller: GameController;

//    private var _preloader: PreloaderScreen;

    public function App() {
        addEventListener(Event.ADDED_TO_STAGE, start);
    }

    public function start(e: Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, start);

        _info = DeviceResInfo.getInfo(Starling.current.nativeOverlay.stage);

        Config.init();

        _resources = new ResourcesManager(_info);

        _controller = new GameController(stage, _resources);
        _controller.init();

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
//        _preloader.destroy();
//        _preloader.removeFromParent(true);
//        _preloader = null;

        _controller.ready();
    }
}
}
