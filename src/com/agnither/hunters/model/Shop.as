/**
 * Created by mor on 09.11.2014.
 */
package com.agnither.hunters.model
{
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.player.inventory.Item;

import flash.utils.Dictionary;

public class Shop
{
    private var _itemsDict : Dictionary;

    public function Shop()
    {

        _itemsDict = new Dictionary();

    }

    public function getItemsByType($type : int) : Array
    {
        trace("getItemsByType", $type, _itemsDict[$type])

        if (!_itemsDict[$type])
        {
            _itemsDict[$type] = generateItems($type);
        }

        return _itemsDict[$type];

    }

    private function generateItems($type : int) : Array
    {

        var itemType : ItemTypeVO = ItemTypeVO.DICT[$type];
        var arr : Array = [];
        var amount : Number = itemType.tabMin + int((itemType.tabMax - itemType.tabMin + 1) * Math.random());
        var i : int = 0;
        var item : Item;
        var itemVO : ItemVO;
//        trace("GENERATE", $type, amount, itemType.tabMin, itemType.tabMax);
        if (amount == 0)
        {
//            XXX deprecated, spells are random too
//            trace("SETS:", Model.instance.progress.sets );
//            for (i = 0; i < ItemVO.DICT[$type].length; i++)
//            {
//
//                itemVO = ItemVO.SPELLS[i].clone();
//                trace(i, itemVO.id, itemVO.setname);
//
//                if(Model.instance.progress.sets.indexOf(itemVO.setname) >= 0) {
////                    Model.instance.items.getItemVO(itemVO.id, itemVO);
//                    trace(itemVO.id, "ADDED");
//                    arr.push(Item.create(itemVO));
//                }
//            }
        }
        else
        {
            for (i = 0; i < amount; i++)
            {
//                var set : String = getRandomSet();
//                item = getRandomItem(set, $type);
                item = Model.instance.items.generateRandomItem($type);
                if(item) {
                    arr.push(item);
                }
//                    arr.push(Item.createItem(itemVO, itemVO));
            }

        }

        return arr;

    }

    public function updateGoods():void {
        if(!_itemsDict) {
            _itemsDict = new Dictionary();
        } else {
            for (var key : String in _itemsDict)
            {
                _itemsDict[key] = null;
                delete _itemsDict[key];
            }
        }
    }








    public function removeItem($item : Item) : void
    {
        var arr : Array = _itemsDict[$item.type];
        var index : int = arr.indexOf($item);
        arr.splice(index, 1);
    }
}
}
