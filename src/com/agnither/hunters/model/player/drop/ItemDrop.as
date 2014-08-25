/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.drop {
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.model.player.inventory.Item;

public class ItemDrop extends Drop {

    private var _item: Item;
    public function get item():Item {
        return _item;
    }

    override public function get icon():String {
        return _item.icon;
    }

    public function ItemDrop(item: Item) {
        _item = item;
        _item.uniqueId = ItemTypeVO.DICT[item.type].name + "." + (new Date()).time;
    }

    override public function stack(drop: Drop):Boolean {
        return false;
    }
}
}
