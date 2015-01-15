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
import com.agnither.hunters.model.modules.players.SettingsVO;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.utils.Util;

import flash.geom.Utils3D;

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
        _list = new Vector.<DropSlot>(12);
        for (var i : int = 0; i < 6; i++)
        {
            _list[i] = new DropSlot();
        }

        coreAddListener(DropList.GENERATE_DROP, onDropGenerate);
    }

    private function onDropGenerate($hitPercent : Number, hp : Number = 0) : void
    {
        var currentMonster : MonsterVO = Model.instance.enemy.hero.monster;
        if(!currentMonster) return;


        var chance : Number = ($hitPercent * 200);
//        trace(chance);
        if(Model.instance.player.doubleDrop) {
            chance += chance * Model.instance.player.doubleDrop.percent;
//            trace("inc chance:", chance);
        }

        var isDropped : Boolean = chance > Math.random() * 100;
        if(!hp && $hitPercent)
        {
            isDropped = true;
        }
        else
        {
            if(_list.length == 11) {
                return;
            }
        }
       //isDropped = true;
        if(!isDropped) return;

        var isGold : Boolean = Math.random() > SettingsVO.DICT["itemDropChance"] || _itemsAmount >= _list.length;
        var content : Item;

        //isGold = false;
        if(isGold)
        {
            var pMin : Number;
            if (currentMonster.order == 0)  pMin = 1;
            else pMin = Math.round(MonsterVO.DICT["order"+(currentMonster.order-1)].reward * 0.2);

            var pAverage :Number = Math.round(currentMonster.reward * 0.3);

            var nextMonster : MonsterVO;
            if(currentMonster.order < MonsterVO.maxOrder) {
                var monOrder : int = currentMonster.order + 1;
                nextMonster = MonsterVO.DICT["order"+monOrder];
            } else {
                nextMonster = currentMonster;
            }

            var pMax : Number = Math.round(nextMonster.reward * 0.2);
            var p : Number = Util.getRandomParam(pMin, pAverage, pMax); // возвращает кол-во золота

            content = Item.create(ItemVO.createGoldItemVO);
            content.amount = Math.ceil(p);
        }
        else
        {
//          var types : Array = Model.instance.items.slots;
////        chance = Model.instance.items.dropChanceSum * Math.random();

            var indexOfItem : int = Util.getIndexOfRandom(Model.instance.items.chances, Model.instance.items.dropChanceSum);
            var slot : String = Model.instance.items.slots[indexOfItem];
            var items : Array = Model.instance.items.itemsBySlot[slot];
            var arr : Array = [];
            for (var i : int = 0; i < items.length; i++)
            {
                var vo : ItemVO = items[i];
                if(vo.pricecrystal > 0)
                {
                    continue;
                }
                arr.push(vo);
            }
            trace("*", items);
            items = arr;
            trace("**", items);

            var paramMult : Number = SettingsVO.DICT[slot+"ParamMult"];

            if (currentMonster.order < 3)
            {
                pMin = 1;
            }
            else {
                pMin = Math.round(Math.sqrt((MonsterVO.DICT["order"+(currentMonster.order - 3)].reward * (MonsterVO.DICT["order"+(currentMonster.order - 2)].difficultyfactor + 1)) / paramMult));
            }

            if (currentMonster.order < 1) {
                pAverage = 1;
            }
            else {
                pAverage = Math.round(Math.sqrt((MonsterVO.DICT["order"+(currentMonster.order - 1)].reward * (currentMonster.difficultyfactor + 1)) / paramMult));
            }

            pMax = Math.round(Math.sqrt((currentMonster.reward * (MonsterVO.DICT["order"+(currentMonster.order + 1)].difficultyfactor + 1)) / paramMult));

            var itemParam : Number = Util.getRandomParam(pMin, pAverage, pMax);
            trace("dropItem min:" + pMin + " pAverage:" + pAverage + " pMax:" + pMax + " itemParam:" + itemParam + "slot: " + slot);
            if(items && items.length > 0)
            {
                content = findItem(items, Math.round(itemParam), -1);
            }
        }
        if(content)
        {
            addContent(content);
        }
    }

    private function findItem($items : Array, itemParam : Number, changeValue : Number) : Item
    {
        trace("findItem", itemParam, changeValue, $items);
        var selectedItems : Array = [];
        if(itemParam > 0) {
            var minVal : Number
            var maxVal : Number
            for (var i : int = 0; i < $items.length; i++)
            {
                var itm : ItemVO = $items[i];
                if(!minVal) {
                    minVal = itm.minval();
                } else {
                    minVal = Math.min(minVal, itm.minval());
                }
                if(!maxVal) {
                    maxVal = itm.maxval();
                } else {
                    maxVal = Math.max(maxVal, itm.maxval());
                }

                if(itm.isFitsParam(itemParam)) {
                    selectedItems.push(itm);
                }
            }
        }
        trace("*", itemParam, selectedItems, minVal, maxVal);
        if(!selectedItems.length) {
            var newChangeValue : Number = changeValue < 0 ? -1 * (changeValue - 1) : -1 * (changeValue + 1);
            if(itemParam + changeValue + newChangeValue < 0) {
                newChangeValue = -1 * (newChangeValue - 1)
            }
            return findItem($items, itemParam + changeValue, newChangeValue);
        }

        var index : int = int(Math.random() * selectedItems.length);

        var itemVO : ItemVO = selectedItems[index].clone();

        if(itemVO.type == ItemVO.TYPE_WEAPON) {
            itemVO.ext[DamageExt.TYPE] = [itemVO.ext[DamageExt.TYPE][0], Math.round(itemParam)];
        }
        if(itemVO.type == ItemVO.TYPE_ARMOR) {
            itemVO.ext[DefenceExt.TYPE] = [Math.round(itemParam)];
        }

        var item : Item = Item.create(itemVO);

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


//        var drop : DropVO =  ? DropVO.getRandomDrop(_dropSet) : DropVO.getRandomDrop(2); // set 2 is only createGoldItemVO
////        var content : Drop;
//        switch (drop.type) {
//            case ItemTypeVO.weapon:
//            case ItemTypeVO.armor:
//            case ItemTypeVO.magic:
//                content = Model.instance.items.createDrop(drop.item_id));
////                content = new ItemDrop(Item.createDrop(Model.instance.items.getItem(drop.item_id)));
//                break;
//            case ItemTypeVO.createGoldItemVO:
//                content = new GoldDrop(drop.randomAmount);
////                content = new GoldDrop(GoldDropVO.DICT[drop.item_id].random);
//                break;
//        }
        addContent(content);
        return content;
    }

    private function addContent(content : Item) : void
    {
        coreDispatch(BattleScreen.PLAY_CHEST_FLY, content);
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
//                coreDispatch(BattleScreen.PLAY_CHEST_FLY, content);
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
