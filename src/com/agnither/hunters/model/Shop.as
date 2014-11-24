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
        if (amount == 0)
        {
            for (i = 0; i < ItemVO.SPELLS.length; i++)
            {

                itemVO = ItemVO.SPELLS[i].clone();
                if(Model.instance.progress.sets.indexOf(itemVO.setname) >= 0) {
//                    Model.instance.items.getItemVO(itemVO.id, itemVO);
                    arr.push(Item.create(itemVO));
                }
            }
        }
        else
        {
            for (i = 0; i < amount; i++)
            {
//                var set : String = getRandomSet();
//                item = getRandomItem(set, $type);
                item = Model.instance.items.generateRandomItem($type);
                arr.push(item);
//                    arr.push(Item.createItem(itemVO, itemVO));
            }

        }

        return arr;

    }









    public function removeItem($item : Item) : void
    {
        var arr : Array = _itemsDict[$item.type];
        var index : int = arr.indexOf($item);
        arr.splice(index, 1);
    }
}
}
