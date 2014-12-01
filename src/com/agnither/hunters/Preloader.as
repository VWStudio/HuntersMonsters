/**
 * Created by mor on 21.11.2014.
 */
package com.agnither.hunters
{
import app.PreloaderAsset;

import com.agnither.hunters.model.Model;
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
        setProgress(pc * 0.5);
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

        trace("LOAD ASSETS");

        var isLocal : Boolean = stage.loaderInfo.url.indexOf("http") < 0;

        _libLoader = new Loader();
        var myUrlReq : URLRequest = new URLRequest(!isLocal ? "http://cs6130.vk.me/u284790/e1e4d1f7233016.zip" : "AssetsLib.swf");
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

        trace(_libLoader.content);
        trace(_libLoader.contentLoaderInfo.content);

        _libLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onGraphicLoaded);
        _libLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, libProgress);
        initApp();
    }

    /*
     /*
     access_token=b68e518bfb06d7dee3697d1955cc2a31ffc659ad53c8e07dedf370b20cb588d800ffec533e1965ff59867&
     ad_info=ElsdCQVYQFVkBgBfAwJSXHt4A0Q8HTJXUVBBJRVBNwoIFjI2HA8E&
     api_id=4607351&
     api_settings=256&
     api_url=http%3A%2F%2Fapi.vk.com%2Fapi.php&
     auth_key=fd14ef7de708a575bd501abe0c946ae3&
     group_id=0&
     hash=&
     is_app_user=1&
     is_secure=0&
     language=0&
     lc_name=5180a0ac&
     parent_language=0&
     referrer=unknown&
     secret=e7cf436db4&
     sid=fed6f3774d9b6c41ffd216782667fdc1bc52669d990ebe3796706c29840ea0060bac78758420e4b841233&
     user_id=0&
     viewer_id=44100344&
     viewer_type=0
     */

    private function initApp() : void {
        trace("INIT APP");
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
