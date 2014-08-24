/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.ItemVO;

import starling.events.EventDispatcher;

public class Item extends EventDispatcher {

    public static const UPDATE: String = "update_Item";

    protected var _uniqueId: String;
    public function set uniqueId(value: String):void {
        _uniqueId = value;
    }
    public function get uniqueId():String {
        return _uniqueId;
    }

    private var _extension: Object;
    public function get extension():Object {
        return _extension;
    }

    protected var _item: ItemVO;
    public function get id():int {
        return _item.id;
    }
    public function get name():String {
        return _item.name;
    }
    public function get picture():String {
        return _item.picture;
    }
    public function get icon():String {
        return null;
    }

    private var _used: Boolean;
    public function set used(value: Boolean):void {
        _used = value;
        update();
    }
    public function get used():Boolean {
        return _used;
    }

    public function Item(item: ItemVO, extension: Object) {
        _item = item;
        _extension = extension;
    }

    public function update():void {
        dispatchEventWith(UPDATE);
    }

    public function destroy():void {
        _item = null;
    }
}
}
