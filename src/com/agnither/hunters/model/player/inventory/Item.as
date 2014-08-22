/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.inner.ItemVO;

import starling.events.EventDispatcher;

public class Item extends EventDispatcher {

    public static const UPDATE: String = "update_Item";

    protected var _inventoryId: int;
    public function set inventoryId(value: int):void {
        _inventoryId = value;
    }
    public function get inventoryId():int {
        return _inventoryId;
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

    public function Item(item: ItemVO) {
        _item = item;
    }

    public function update():void {
        dispatchEventWith(UPDATE);
    }

    public function destroy():void {
        _item = null;
    }
}
}
