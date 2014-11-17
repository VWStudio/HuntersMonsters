/**
 * Created by agnither on 18.08.14.
 */
package com.agnither.hunters.model.player.drop {
import com.agnither.hunters.model.player.inventory.Item;

import starling.events.EventDispatcher;

public class DropSlot extends EventDispatcher {

    public static const UPDATE: String = "update_DropSlot";

    private var _content: Item;
    public function get content():Item {
        return _content;
    }

    public function DropSlot() {
    }

    public function addContent($content: Item):void {
//    public function addContent(content: Item):Boolean {
        if (!_content) {
            _content = $content;
        } else if (!_content.isGold()) {
            _content.amount += $content.amount;
        }
        dispatchEventWith(UPDATE);
    }

    public function clear():void {
        _content = null;
    }

    private function update():void {
        dispatchEventWith(UPDATE);
    }
}
}
