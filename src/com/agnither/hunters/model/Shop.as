/**
 * Created by mor on 09.11.2014.
 */
package com.agnither.hunters.model
{
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.players.SettingsVO;
import com.agnither.hunters.model.player.inventory.Item;

import flash.utils.Dictionary;

public class Shop
{
    private var _itemsDict : Dictionary;
    public static const DELIVER_TIME : String = "Shop.DELIVER_TIME";
    public static const NEW_DELIVER : String = "Shop.NEW_DELIVER";

    public function Shop()
    {

        _itemsDict = new Dictionary();

    }

    public function getItemsByType($type : String) : Array
    {
//        trace("getItemsByType", $type, _itemsDict[$type]);

        if (!_itemsDict[$type])
        {
            _itemsDict[$type] = generateItems($type);
        }

        return _itemsDict[$type];

    }

    private function generateItems($type : String) : Array
    {

        var createdItems : Array = [];
        var itemsMin : int = SettingsVO.DICT[$type + "TabMin"];
        var itemsMax : int = SettingsVO.DICT[$type + "TabMax"];
        var arr : Array = [];
        var amount : Number = itemsMin + int((itemsMax - itemsMin + 1) * Math.random());
        var i : int = 0;
        var item : Item;
        var itemVO : ItemVO;
        if (amount == 0)
        {

        }
        else
        {
            for (i = 0; i < amount; i++)
            {
                item = Model.instance.items.generateRandomItem($type);
                if (item)
                {
                    var itmString : String = item.toString();
//                    trace("created item:", itmString);
                    if(createdItems.indexOf(itmString) == -1) {
                        createdItems.push(itmString);
                        arr.push(item);
                    }
                }
            }

        }

        return arr;

    }

    public function updateGoods() : void
    {
        if (!_itemsDict)
        {
            _itemsDict = new Dictionary();
        }
        else
        {
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
