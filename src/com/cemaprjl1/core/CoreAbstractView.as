package com.cemaprjl1.core {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;

/**
 * @author com.cemaprjl1
 */
public class CoreAbstractView extends EventDispatcher {

    private var _asset:Sprite;

    public function get viewName():String {
        var s : String = (this as Object).constructor["NAME"];
        if(s != null) {
            return s;
        }
        return "";
    }

    public function addChild($child : DisplayObject) : void {
        asset.addChild($child);
    }

    public function get asset():Sprite {
        return _asset;
    }

    public function CoreAbstractView($asset:Sprite = null) {
        super();
        if ($asset) {
            _asset = $asset;
        } else {
            _asset = new Sprite();
        }
        preinitialize();
        initializeContent();
    }
    protected var data : Object = {};

    public function update() : void {

    }

    public function setData($data : Object) : void {
        if ($data != null)
        {
            data = $data;
        }
        else
        {
            data = {};
        }
    }

    protected function onResize() : void {

    }
    protected function preinitialize():void {

    }
    protected function initializeContent():void {
    }

    public function destroy():void {
    }

}
}
