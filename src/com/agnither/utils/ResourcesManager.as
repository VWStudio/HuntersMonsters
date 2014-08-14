/**
 * Created by agnither on 30.01.14.
 */
package com.agnither.utils {
import com.agnither.hunters.data.Config;
import com.agnither.hunters.utils.DeviceResInfo;

import org.osflash.signals.Signal;

import starling.utils.AssetManager;

public class ResourcesManager {

    private var _info: DeviceResInfo;
    public function get info():DeviceResInfo {
        return _info;
    }

    private var _main: AssetManager;
    public function get main():AssetManager {
        return _main;
    }

    private var _gui: AssetManager;
    public function get gui():AssetManager {
        return _gui;
    }

    private var _map: AssetManager;
    public function get map():AssetManager {
        return _map;
    }

    private var _animations: AssetManager;
    public function get animations():AssetManager {
        return _animations;
    }

//    private var _back: String;
//    private var _wall: int;
    private var _game: AssetManager;
    public function get game():AssetManager {
        return _game;
    }

    private var _queue: Array = [];
    private var _loaded: int;
    private var _loading: int;

    public var onProgress: Signal;
    public var onComplete: Signal;
    public var onError: Signal;

    public function ResourcesManager(info: DeviceResInfo) {
        _info = info;

        _main = new AssetManager(_info.scaleFactor);
        _gui = new AssetManager(_info.scaleFactor);
        _map = new AssetManager(_info.scaleFactor);
        _animations = new AssetManager(_info.scaleFactor);
        _game = new AssetManager(_info.scaleFactor);

        _loaded = 0;
        _loading = 0;

        onProgress = new Signal(Number);
        onComplete = new Signal();
        onError = new Signal();
    }

    public function loadMain():void {
        _loading++;

        for (var i:int = 0; i < Config.list.length; i++) {
            _main.enqueue("config/config/" + Config.list[i] + ".json");
        }

        _main.enqueue(
            "config/gui.json"
//            File.applicationDirectory.resolvePath("levels")
//            File.applicationDirectory.resolvePath("particles")
        );
        _queue.push(_main);
    }

    public function loadGUI():void {
        _loading++;

        for (var i:int = 0; i < Fonts.fonts.length; i++) {
            _gui.enqueue("textures/fonts/"+Fonts.fonts[i]+".xml");
        }

        _gui.enqueue(
            "textures/gui/gui.png",
            "textures/gui/gui.xml"
        );
        _queue.push(_gui);
    }

    public function loadMap():void {
        _loading++;

        _map.enqueue(
//            File.applicationDirectory.resolvePath("textures/"+_info.art+"/map/")
        );
        _queue.push(_map);
    }

    public function loadAnimations():void {
        _loading++;

        _animations.enqueue(
//            File.applicationDirectory.resolvePath("animations/")
        );
        _queue.push(_animations);
    }

    public function loadGame():void {
//    public function loadGame(back: String, wall: int):void {
//        if (_back != back || _wall != wall) {
//            clearGame();
//
//            _back = back;
//            _wall = wall;
//        } else {
//            return;
//        }

        _loading++;

        _game.enqueue(
//            File.applicationDirectory.resolvePath("textures/"+_info.art+"/game/backs/"+_back+"/"),
//            File.applicationDirectory.resolvePath("textures/"+_info.art+"/game/walls/"+_wall+"/")
//            File.applicationDirectory.resolvePath("textures/"+_info.art+"/back/"),
//            File.applicationDirectory.resolvePath("textures/"+_info.art+"/hero/"),
//            File.applicationDirectory.resolvePath("textures/"+_info.art+"/objects/")
        );
        _queue.push(_game);
    }
    public function clearGame():void {
        _game.purge();
        _game.dispose();
    }

    public function load():void {
        var asm: AssetManager = _queue.shift();
        if (asm) {
            asm.loadQueue(handleProgress);
        } else {
            onComplete.dispatch();
        }
    }

    private function handleProgress(value: Number):void {
        onProgress.dispatch((_loaded+value)/_loading);

        if (value == 1) {
            _loaded++;
            onComplete.dispatch();

            if (_queue.length>0) {
                load();
            } else {
                _loaded = 0;
                _loading = 0;
            }
        }
    }
}
}
