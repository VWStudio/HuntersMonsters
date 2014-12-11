/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player.drop
{
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.extensions.DamageExt;
import com.agnither.hunters.model.modules.extensions.DefenceExt;
import com.agnither.hunters.model.modules.extensions.Extension;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.inventory.Item;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.utils.Util;

import starling.events.EventDispatcher;

public class DropList extends EventDispatcher
{

    private var _list : Vector.<DropSlot>;
    public static const GENERATE_DROP : String = "DropList.GENERATE_DROP";
    public function get list() : Vector.<DropSlot>
    {
        return _list;
    }

    private var _dropSet : int;
    private var _goldContent : DropSlot;
    private var _lastIndex : int = 0;
    private var _itemsAmount : int = 0;

    public function DropList()
    {
        _list = new Vector.<DropSlot>(6);
        for (var i : int = 0; i < 6; i++)
        {
            _list[i] = new DropSlot();
        }

        coreAddListener(DropList.GENERATE_DROP, onDropGenerate);
    }

    private function onDropGenerate($hitPercent : Number) : void
    {
        var currentMonster : MonsterVO = Model.instance.enemy.hero.monster;
        trace("GENERATE DROP", currentMonster, $hitPercent);
        if(!currentMonster) return;

        var isDropped : Boolean = ($hitPercent * 300) > Math.random() * 100;
        trace("isDropped", isDropped);

        if(!isDropped)
        {
            return;
        }

        var isGold : Boolean = Math.random() < 0.6;

        trace("isGold", isGold);
        /**
         * TODO complete drop
         */
        /*
         p - кол-во вападающего золота.
         n - награда за монстра (из конфига).
         pMin = n / 1,4 (минимальное значение золота).
         pMax = n * 1,3 (максимальное значение золота).

         chance = 2 / Math.pow(2, 6 * Math.random() + 1)
         pSpread = pMax - pMin

         if (Math.random() < 0.5)
            p = pSpread * 0.5 * -chance
         else
            p = (pSpread - (pSpread * 0.5)) * chance
         p = pMin + (pSpread * 0.5) + p

         */

        var pMin : Number = currentMonster.reward / 1.4;
        var pMax : Number = currentMonster.reward * 1.3;
        var pSpread : Number = pMax - pMin;
        var chance : Number = 6 * Math.random() + 1;
        chance = chance * chance;
        chance = 2 / chance;
        var p : Number;
        if(Math.random() < 0.5) {
            p = pSpread * 0.5 * -chance;
        } else {
            p = pSpread * 0.5 * chance;
        }
        p = pMin + (pSpread * 0.5) + p;
        var content : Item;
//        if(false) {
//        if(true) {
        if(isGold) {
            trace(p, pMin, pMax, pSpread);
            content = Item.create(ItemVO.goldItemVO);
            content.amount = p;
        }
        else
        {
            var types : Array = Model.instance.items.types;
//            chance = Model.instance.items.dropChanceSum * Math.random();
            var indexOfItem : int = Util.getIndexOfRandom(Model.instance.items.chances, Model.instance.items.dropChanceSum);
            trace("INDEX:", indexOfItem, Model.instance.items.types[indexOfItem],"SUM", Model.instance.items.dropChanceSum, "CHANCES", Model.instance.items.chances);
            var type : String = Model.instance.items.types[indexOfItem];
            var itemParam : Number = Math.sqrt(p / 0.6);
            var items : Array = Model.instance.items.itemsByType[type];

            trace(itemParam, items);

            if(items.length > 0) {
                content = findItem(items, Math.round(itemParam), -1);
            }





        }

        if(content) {
            addContent(content);
        }
    }

    private function findItem($items : Array, itemParam : Number, changeValue : Number) : Item
    {
        trace("findItem", itemParam, changeValue);
        if(itemParam < 1) return null;

        var selectedItems : Array = [];
        for (var i : int = 0; i < $items.length; i++)
        {
            var itm : ItemVO = $items[i];
            if(itm.isFitsParam(itemParam)) {
                selectedItems.push(itm);
            }
        }
        trace("*", itemParam, selectedItems);
        if(!selectedItems.length) {
            var newChangeValue : Number = changeValue < 0 ? -1 * (changeValue - 1) : -1 * (changeValue + 1);
            return findItem($items, itemParam + changeValue, newChangeValue);
        }

        var index : int = int(Math.random() * selectedItems.length);

        var itemVO : ItemVO = selectedItems[index].clone();
        var item : Item = Item.create(itemVO);
        var ext : Extension;
        if(item.isWeapon()) {
            ext = item.getExt(DamageExt.TYPE);
            ext.setArguments([ext.toObject()[0], itemParam])
        }
        if(item.isArmor()) {
            ext = item.getExt(DefenceExt.TYPE);
            ext.setArguments([itemParam])
        }

        trace(index, JSON.stringify(itemVO));

        return item;
    }

    public function init(dropSet : int) : void
    {
        _dropSet = dropSet;
    }

    public function drop() : Item
    {

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

    private function addContent(content : Item) : void
    {
        if (content.isGold())
        {
            if (!_goldContent)
            {
                _goldContent = _list[_lastIndex];
                _lastIndex++;
            }
            _goldContent.addContent(content);
            return;
        }
        else
        {
            if (_lastIndex < _list.length)
            {
                _list[_lastIndex].addContent(content);
            }
            _itemsAmount++;
            _lastIndex++;
        }
//        while (i < _list.length && !_list[i].addContent(content)) {
//            i++;
//        }
    }

    public function clearList() : void
    {
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
