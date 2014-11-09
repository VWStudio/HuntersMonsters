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

        trace("generateItems", $type)

        var itemType : ItemTypeVO = ItemTypeVO.DICT[$type];
        var arr : Array = []
        var amount : Number = itemType.tabMin + int((itemType.tabMax - itemType.tabMin + 1) * Math.random());
        trace("AMOUNT", amount);
        var i : int = 0;
        var item : ItemVO;
        if (amount == 0)
        {
            for (i = 0; i < ItemVO.SPELLS.length; i++)
            {

                item = ItemVO.SPELLS[i];
                trace(item.name, item.setname, Model.instance.progress.sets);
                if(Model.instance.progress.sets.indexOf(item.setname) >= 0) {
                    arr.push(Item.createDrop(item));
                }
            }
        }
        else
        {
            for (i = 0; i < amount; i++)
            {
                var set : String = getRandomSet();
                item = getRandomItem(set, $type);
                if(item != null) {
                    arr.push(Item.createDrop(item));
                }
            }

        }

        return arr;

    }

    private function getRandomItem($set : String, $type : int) : ItemVO
    {

        var items : Array = ItemVO.SETS[$set];
        var itemsByType : Array = [];
        var i : int = 0;
        for (i = 0; i < items.length; i++)
        {
            var object : ItemVO = items[i];
            if(object.type == $type) {
                itemsByType.push(object);
            }
        }

        return itemsByType.length > 0 ? itemsByType[int(itemsByType.length* Math.random())] : null;

    }


    private function getRandomSet() : String
    {
        var chances : Vector.<Number> = new <Number>[]
        var chanceSum : Number = 0;
        var i : int = 0;
        for (i = 0; i < Model.instance.progress.sets.length; i++)
        {
            var chance : Number = (i + 1) / Model.instance.progress.sets.length;
            chances.push(chance);
            chanceSum += chance;
        }

        var rand : int = Math.random() * chanceSum;
        for ( i = 0; i < chances.length; i++)
        {
            if(chances[i] > rand) {
                return Model.instance.progress.sets[i];
            }
            rand -= chances[i];

        }
        return Model.instance.progress.sets[0];
    }

    public function removeItem($item : Item) : void
    {
        var arr : Array = _itemsDict[$item.type];
        var index : int = arr.indexOf($item);
        arr.splice(index, 1);
    }
}
}
