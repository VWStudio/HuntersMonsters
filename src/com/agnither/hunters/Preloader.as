/**
 * Created by mor on 21.11.2014.
 */
package com.agnither.hunters
{
import app.PreloaderAsset;

import com.agnither.hunters.model.Model;

import flash.display.DisplayObject;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.utils.getDefinitionByName;
import flash.utils.setTimeout;

[SWF(frameRate="60", width="1000", height="720", backgroundColor="#000000")]
public class Preloader extends MovieClip
{
    private var _back : PreloaderAsset;
    private var _bar : DisplayObject;
    public function Preloader()
    {
        super();

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        _back = new PreloaderAsset();
        addChild(_back);
        _bar = _back.bar;
        _bar.scaleX = 0;
        loadMain();
    }

    public function setProgress($val : Number):void {
        _bar.scaleX = $val;
    }

    private function loadMain() : void {
        addEventListener(Event.ENTER_FRAME, onMainLoadEnterFrame);
        loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
        loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
    }
    private function ioError(e : IOErrorEvent) : void {
        trace(e.text);
    }
    private function progress(e : ProgressEvent) : void {
        var pc : Number = e.bytesLoaded / e.bytesTotal;
//        var pc : Number = _alreadyLoaded + e.bytesLoaded / e.bytesTotal * _stepPart;
        setProgress(pc);
    }
    private function onMainLoadEnterFrame(event : Event) : void {
        if (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal)
        {
            removeEventListener(Event.ENTER_FRAME, onMainLoadEnterFrame);
            loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
            loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
//            _loadComplete = true;
//            loadGraphics();

            initApp();
        }
    }

    private function initApp() : void {

//            nextFrame();
        var mainClass : Object = getDefinitionByName("game.Main");
        addChildAt(new mainClass() as Sprite, 0);
        setTimeout(removeStuff, 2000);
    }

    private function removeStuff() : void
    {
        while(numChildren > 1) {
            removeChildAt(1);
        }
    }
}
}
