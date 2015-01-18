/**
 * Created by mor on 21.11.2014.
 */
package com.agnither.hunters
{
import app.PreloaderAsset;

import com.agnither.hunters.model.Model;
import com.agnither.utils.ResourcesManager;
import com.agnither.utils.ResourcesManager;

import flash.display.DisplayObject;
import flash.display.Loader;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.SecurityDomain;
import flash.utils.getDefinitionByName;
import flash.utils.getTimer;
import flash.utils.setTimeout;

[SWF(frameRate="60", width="1000", height="720", backgroundColor="#000000")]
public class Preloader extends MovieClip
{
    private var _back : PreloaderAsset;
    private var _bar : DisplayObject;
    private var _libLoader : Loader;
    public function Preloader()
    {
        super();

        //trace("aaa");

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
        //trace(e.text);
    }
    private function progress(e : ProgressEvent) : void {

        trace(e.bytesLoaded, "of", e.bytesTotal, "--", getTimer());
        var pc : Number = e.bytesLoaded / e.bytesTotal;
        setProgress(pc * (ResourcesManager.isLocal ? 1 : 0.5));
    }
    private function onMainLoadEnterFrame(event : Event) : void {
        if (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal)
        {
            removeEventListener(Event.ENTER_FRAME, onMainLoadEnterFrame);
            loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
            loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
//            _loadComplete = true;
//            loadGraphics();
            if(ResourcesManager.isLocal) {
                initApp();
            } else {
                loadAssets();
            }
        }
    }

    private function loadAssets() : void
    {

//        trace("LOAD ASSETS");

        var isLocal : Boolean = stage.loaderInfo.url.indexOf("http") < 0;

        _libLoader = new Loader();
        var myUrlReq : URLRequest = new URLRequest(!isLocal ? "http://app.vk.com/c6130/u284790/1585c56412b7c4.swf" : "AssetsLib.swf");
//        var myUrlReq : URLRequest = new URLRequest(!isLocal ? "http://app.vk.com/c6130/u284790/7db47f1516a93d.swf" : "AssetsLib.swf");
        _libLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onGraphicLoaded);
        _libLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, libProgress);
        _libLoader.load(myUrlReq, new LoaderContext(false, ApplicationDomain.currentDomain, !isLocal ? SecurityDomain.currentDomain : null));
    }

    private function libProgress(e : ProgressEvent) : void
    {



        var pc : Number = e.bytesLoaded / e.bytesTotal;
        setProgress(0.5 + pc * 0.5);
    }

    private function onGraphicLoaded(event : Event) : void
    {

//        trace(_libLoader.content);
//        trace(_libLoader.contentLoaderInfo.content);

        _libLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onGraphicLoaded);
        _libLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, libProgress);
        initApp();
    }

     private function initApp() : void {
//        trace("INIT APP");
//            nextFrame();
        //trace("bbb");
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
