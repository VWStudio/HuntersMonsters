/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player.drop {
import com.agnither.hunters.data.outer.DropVO;
import com.agnither.hunters.data.outer.GoldDropVO;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.data.outer.ItemVO;
import com.agnither.hunters.model.player.inventory.Item;

import starling.events.EventDispatcher;

public class DropList extends EventDispatcher {

    private var _list : Vector.<DropSlot>;
    public function get list() : Vector.<DropSlot> {
        return _list;
    }

    private var _dropSet : int;

    public function DropList() {
        _list = new Vector.<DropSlot>(6);
        for (var i : int = 0; i < 6; i++) {
            _list[i] = new DropSlot();
        }
    }

    public function init(dropSet : int) : void {
        _dropSet = dropSet;
    }

    public function drop() : void {
        var drop : DropVO = DropVO.getRandomDrop(_dropSet);
        var content : Drop;
        switch (drop.type) {
            case ItemTypeVO.weapon:
            case ItemTypeVO.armor:
            case ItemTypeVO.magic:
                content = new ItemDrop(Item.createDrop(ItemVO.DICT[drop.item_id]));
                break;
            case ItemTypeVO.gold:
                content = new GoldDrop(GoldDropVO.DICT[drop.item_id].random);
                break;
        }
        addContent(content);
    }

    private function addContent(content : Drop) : void {
        var i : int = 0;
        while (i < _list.length && !_list[i].addContent(content)) {
            i++;
        }
    }

    public function clearList() : void {
        while (_list.length > 0) {
            var drop : DropSlot = _list.shift();
            drop.clear();
        }
    }
}
}