/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player {
import starling.events.EventDispatcher;

public class DropList extends EventDispatcher {

    private var _list: Vector.<DropSlot>;
    public function get list():Vector.<DropSlot> {
        return _list;
    }

    public function DropList() {
        _list = new Vector.<DropSlot>(6);
        for (var i:int = 0; i < 6; i++) {
            _list[i] = new DropSlot();
        }
    }

    public function addContent(content: *):void {
        var i: int = 0;
        while (i < _list.length && !_list[i].addContent(content)) {
            i++;
        }
    }

    public function clearList():void {
        while (_list.length > 0) {
            var drop: DropSlot = _list.shift();
            drop.clear();
        }
    }
}
}
