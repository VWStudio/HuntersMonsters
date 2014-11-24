/**
 * Created by mor on 11.10.2014.
 */
package com.agnither.hunters.model.modules.items {
import com.agnither.hunters.data.outer.DropVO;
import com.agnither.hunters.data.outer.ExtensionVO;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.player.inventory.Item;
import com.cemaprjl.utils.Util;

import flash.utils.Dictionary;

public class Items {
    public function Items() {
    }

    public function getExtensions() : Vector.<ExtensionVO> {
        return ExtensionVO.LIST;
    }
    public function getRandomThing() : ItemVO {
        return getItemVO(ItemVO.THINGS[int(ItemVO.THINGS.length * Math.random())].id);
    }
    public function getItemVO($id : int, $fillObj : Object = null) : ItemVO {

        var item : ItemVO = ItemVO.DICT[$id];
        if(!item) {
            return null;
        }
        if($fillObj) {
            return ItemVO.fill(item.clone(), $fillObj);
        }
        return item.clone();
    }

    public function createDropItem($dropSetID : int):Item {

        var item : Item;
        var drop : DropVO = DropVO.getRandomDrop($dropSetID); // set 2 is only goldItemVO
        if(drop.type == ItemTypeVO.gold) {
            item = Item.create(ItemVO.goldItemVO);
            item.amount = drop.randomAmount;
        } else {
            var itemVO : ItemVO = getItemVO(drop.item_id);
//            var extension: Object = {};
//            for (var key: * in itemVO.extension) {
//                var extString : String = itemVO.extension_drop[key] ? itemVO.extension_drop[key] : itemVO.extension[key];
//                var extObj : Object = JSON.parse(extString);
//                if(extObj is Array) {
//                    extension[key] = getRandomExtValue(extObj[0], extObj[1]);
//                } else {
//                    extension[key] = extObj as int;
//                }
//            }
//            itemVO.extension = extension;
            item = Item.create(itemVO);
            item.uniqueId = Util.uniq(item.name);
        }
        return item;
    }

    private function getRandomSet() : String
    {
        var chances : Vector.<Number> = new <Number>[];
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

    public function generateRandomItem($type):Item {
        var set : String = getRandomSet();
        return getRandomItem(set, $type);
    }

    private function getRandomItem($set : String, $type : int) : Item
    {

        var items : Array = ItemVO.SETS[$set];
        var itemsByType : Array = [];
        var i : int = 0;
        for (i = 0; i < items.length; i++)
        {
            var object : ItemVO = items[i].clone();
            if(object.type == $type) {
                itemsByType.push(object);
            }
        }

        var itemVO : ItemVO = itemsByType.length > 0 ? itemsByType[int(itemsByType.length* Math.random())] : null;
        if(!itemVO) return null;

//        var ext : Object = {};
//
//        for (var key : String in itemVO.extension_drop)
//        {
//
//            var dropExt : Array = JSON.parse(itemVO.extension_drop[key]) as Array;
//            itemVO.extension[key] = getRandomExtValue(dropExt[0], dropExt[1])
//
//        }

        var item : Item = Item.create(itemVO);

        return item;
//        return itemsByType.length > 0 ? itemsByType[int(itemsByType.length* Math.random())] : null;

    }

//    public function getRandomExtValue($min : Number, $max : Number, $factor : Number = 0.5):Number {
//        var returnVal : Number = 0;
//        var chance:Number = 2 / Math.pow(2, 6 * Math.random() + 1); //0-60%; 1-2%
//        var pSpread:Number = $max - $min;
//        if (Math.random() < $factor)
//        {
//            returnVal = pSpread * $factor * -chance;
//        }
//        else
//        {
//            returnVal = (pSpread - (pSpread * $factor)) * chance;
//        }
//        returnVal = $min + (pSpread * $factor) + returnVal;
//        return returnVal;
//    }



}
}
