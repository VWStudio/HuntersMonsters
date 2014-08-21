/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.inner.ItemVO;

import starling.events.EventDispatcher;

public class Item extends EventDispatcher {

    protected var _item: ItemVO;
    public function get name():String {
        return _item.name;
    }
    public function get picture():String {
        return _item.picture;
    }
    public function get icon():String {
        return null;
    }

    public function Item(item: ItemVO) {
        _item = item;
    }

    public function destroy():void {
        _item = null;
    }
}
}
