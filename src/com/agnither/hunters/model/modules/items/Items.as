/**
 * Created by mor on 11.10.2014.
 */
package com.agnither.hunters.model.modules.items {
import com.agnither.hunters.data.outer.ExtensionVO;

import flash.utils.Dictionary;

public class Items {
    public function Items() {
    }

    public function getExtensions() : Vector.<ExtensionVO> {
        return ExtensionVO.LIST;
    }
    public function getRandomThing() : ItemVO {
        return getItem(ItemVO.THINGS[int(ItemVO.THINGS.length * Math.random())].id);
    }
    public function getItem($id : int, $fillObj : Object = null) : ItemVO {

        var item : ItemVO = ItemVO.DICT[$id];
        if(!item) {
            return null;
        }
        if($fillObj) {
            return ItemVO.fill(item.clone(), $fillObj);
        }
        return item.clone();
    }
}
}
