/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player.drop {
import com.agnither.hunters.data.outer.DropVO;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.player.inventory.Item;

import starling.events.EventDispatcher;

public class DropList extends EventDispatcher {

    private var _list : Vector.<DropSlot>;
    public function get list() : Vector.<DropSlot> {
        return _list;
    }

    private var _dropSet : int;
    private var _goldContent : DropSlot;
    private var _lastIndex : int = 0;
    private var _itemsAmount : int = 0;

    public function DropList() {
        _list = new Vector.<DropSlot>(6);
        for (var i : int = 0; i < 6; i++) {
            _list[i] = new DropSlot();
        }
    }

    public function init(dropSet : int) : void {
        _dropSet = dropSet;
    }

    public function drop() : Item {

        var isOnlyGold : Boolean = _itemsAmount < _list.length - 1;
        var content : Item = Model.instance.items.createDropItem(isOnlyGold ? _dropSet : 2);


//        var drop : DropVO =  ? DropVO.getRandomDrop(_dropSet) : DropVO.getRandomDrop(2); // set 2 is only goldItemVO
////        var content : Drop;
//        switch (drop.type) {
//            case ItemTypeVO.weapon:
//            case ItemTypeVO.armor:
//            case ItemTypeVO.magic:
//                content = Model.instance.items.createDrop(drop.item_id));
////                content = new ItemDrop(Item.createDrop(Model.instance.items.getItem(drop.item_id)));
//                break;
//            case ItemTypeVO.goldItemVO:
//                content = new GoldDrop(drop.randomAmount);
////                content = new GoldDrop(GoldDropVO.DICT[drop.item_id].random);
//                break;
//        }
        addContent(content);
        return content;
    }

    private function addContent(content : Item) : void {
        if(content.isGold()) {
            if(!_goldContent) {
                _goldContent = _list[_lastIndex];
                _lastIndex++;
            }
            _goldContent.addContent(content);
            return;
        } else {
            if(_lastIndex < _list.length) {
                _list[_lastIndex].addContent(content);
            }
            _itemsAmount++;
            _lastIndex++;
        }
//        while (i < _list.length && !_list[i].addContent(content)) {
//            i++;
//        }
    }

    public function clearList() : void {
        for (var i : int = 0; i < _list.length; i++)
        {
            var slot : DropSlot = _list[i];
            slot.clear();
        }
        _lastIndex = 0;
        _itemsAmount = 0;
        _goldContent = null;
    }
}
}
