/**
 * Created by agnither on 18.08.14.
 */
package com.agnither.hunters.model.player.drop {
import starling.events.EventDispatcher;

public class DropSlot extends EventDispatcher {

    public static const UPDATE: String = "update_DropSlot";

    private var _content: Drop;
    public function get content():Drop {
        return _content;
    }

    public function DropSlot() {
    }

    public function addContent(content: Drop):Boolean {
        if (!_content) {
            _content = content;
        } else if (!_content.stack(content)) {
            return false;
        }
        dispatchEventWith(UPDATE);
        return true;
    }

    public function clear():void {
        _content = null;
    }

    private function update():void {
        dispatchEventWith(UPDATE);
    }
}
}
