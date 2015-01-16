/**
 * Created by mor on 11.10.2014.
 */
package com.agnither.hunters.model.modules.items
{
import com.agnither.hunters.data.outer.DropVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.players.SettingsVO;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.personage.Progress;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.utils.Util;

public class Items
{
    public var slots : Array = [];
    public var itemsBySlot : Object = {};
    public var dropChanceSum : Number;
    public var chances : Array;
//    private var itemsBySlot : Object;
    public function Items()
    {
    }

//    public function getExtensions() : Vector.<ExtensionVO> {
//        return ExtensionVO.LIST;
//    }
    public function getRandomThing() : ItemVO
    {
        return getItemVO(ItemVO.THINGS[int(ItemVO.THINGS.length * Math.random())].id);
    }

    public function getItemVO($id : int, $fillObj : Object = null) : ItemVO
    {

        var item : ItemVO = ItemVO.DICT[$id];
        if (!item)
        {
            return null;
        }
        if ($fillObj)
        {
            return ItemVO.fill(item.clone(), $fillObj);
        }
        return item.clone();
    }

    public function createDropItem($dropSetID : int) : Item
    {

        var item : Item;
        var drop : DropVO = DropVO.getRandomDrop($dropSetID); // set 2 is only createGoldItemVO
        if (drop.item_id && ItemVO.DICT[drop.item_id])
        {
            var itemVO : ItemVO = getItemVO(drop.item_id);
            item = Item.create(itemVO);
            item.uniqueId = Util.uniq(item.name);
        }
        else
        {
            item = Item.create(ItemVO.createGoldItemVO);
            item.amount = drop.randomAmount;
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
        for (i = 0; i < chances.length; i++)
        {
            if (chances[i] > rand)
            {
                return Model.instance.progress.sets[i];
            }
            rand -= chances[i];

        }
        return Model.instance.progress.sets[0];
    }

    public function generateRandomItem($type : String) : Item
    {
        var set : String = getRandomSet();
        return getRandomItem(set, $type);
    }

    private function getRandomItem($set : String, $type : String) : Item
    {
        var items : Array = ItemVO.SETS[$set];
        var itemsByType : Array = [];
        var i : int = 0;
        if (!items)
        {
            return null;
        }
        for (i = 0; i < items.length; i++)
        {
            var object : ItemVO = items[i].clone();
            if (object.type == $type)
            {
                itemsByType.push(object);
            }
        }

        var itemVO : ItemVO = itemsByType.length > 0 ? itemsByType[int(itemsByType.length * Math.random())] : null;
        if (!itemVO)
        {
            return null;
        }

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


    public function getUnlockedTypes() : Array
    {
        return slots;
    }

    public function updateItems() : void
    {
        /**
         * согласно сетам обновить:
         * - типы доступных предметов
         * - предметы
         *
         *
         */

        itemsBySlot = {};
//        itemsByType = {};
        slots = [];
        chances = [];
        dropChanceSum = 0;

        for (var i : int = 0; i < Model.instance.progress.sets.length; i++)
        {
            var setItems : Array = ItemVO.SETS[Model.instance.progress.sets[i]];
            if(setItems) {
                for (var j : int = 0; j < setItems.length; j++)
                {

                    var vo : ItemVO = setItems[j];
                    if(vo.type == ItemVO.TYPE_WEAPON || vo.type == ItemVO.TYPE_ARMOR || vo.type == ItemVO.TYPE_SPELL || vo.type == ItemVO.TYPE_MAGIC) {
//                        if(!itemsByType[vo.type]) {
//                            itemsByType[vo.type] = [];
//                            slots.push(vo.type);
//                            chances.push(SettingsVO.DICT[vo.type+"DropChance"]);
//                            dropChanceSum += SettingsVO.DICT[vo.type+"DropChance"];
//                        }
//                        itemsByType[vo.type].push(vo);

                        if(!itemsBySlot["slot"+vo.slot]) {
                            itemsBySlot["slot"+vo.slot] = [];
                            slots.push("slot"+vo.slot);
                            chances.push(SettingsVO.DICT["slot"+vo.slot+"DropChance"]);
                            dropChanceSum += SettingsVO.DICT["slot"+vo.slot+"DropChance"];
                        }
                        itemsBySlot["slot"+vo.slot].push(vo)

                    }
                }
            }
        }
    }
}
}
