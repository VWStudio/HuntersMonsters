/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory
{
import com.agnither.hunters.data.outer.ItemSlotVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.extensions.DamageExt;
import com.agnither.hunters.model.modules.extensions.DefenceExt;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;

import flash.utils.Dictionary;

import starling.events.EventDispatcher;

public class Inventory extends EventDispatcher
{

    public static const UPDATE : String = "update_Inventory";

    public static var max_capacity : uint = 6;

//    private var _data: Object;

    private var _inventoryItems : Array = []; // of String
    public function get inventoryItems() : Array
    {
        return _inventoryItems;
    }

    private var _itemsDict : Object = new Object();

    public function getItemsInSlot($id : String) : Array
    {
        return _slots[$id]
    }
    public function getItem(name : String) : Item
    {
        return _itemsDict[name];
    }

    private var _itemsByType : Dictionary = new Dictionary();

    public function getItemsByType(type : String) : Array
    { // of String
//    public function getItemsByType(type : int):Array { // of String
        return _itemsByType[type];
    }

    private var _extensions : Object = {};
    private var _spells : Object = {};
    private var _manaPriority : Array;
    private var _slots : Object = {};

    public function getExtension(type : String) : int
    {
        return _extensions[type];
    }

    public function getSpellsManaTypes() : Array
    {
        var arr : Array = [];
        var obj : Object = {};
        for (var key : String in _spells)
        {
            var spell : Item = _spells[key];
            if (spell.isWearing)
            {
                var manas : Object = spell.getMana();
                for (var manaID : String in manas)
                {
                    if (arr.indexOf(manaID) >= 0)
                    {
                        obj[manaID] += manas[manaID];
                    }
                    else
                    {
                        arr.push(manaID);
                        obj[manaID] = manas[manaID];
                    }
                }
            }
        }
        arr.sort(sortManas);
        function sortManas($a : String, $b : String) : Number
        {
            if (obj[$a] > obj[$b])
            {
                return -1;
            }
            if (obj[$a] < obj[$b])
            {
                return 1;
            }
            return 0;
        }

//        trace("INVENTORY", arr, JSON.stringify(obj));

        return arr;
    }


    public function get damage() : int
    {
        return getExtension(DamageExt.TYPE);
    }

    public function get defence() : int
    {
        return getExtension(DefenceExt.TYPE);
    }

    public function Inventory()
    {

    }

    public function init() : void
    {
//        for (var i: int = 0; i < ItemTypeVO.LIST.length; i++) {
        for (var i : int = 0; i < ItemVO.TYPES.length; i++)
        {
            _itemsByType[ItemVO.TYPES[i]] = [];
        }
//        var extArray : Vector.<ExtensionVO> = Model.instance.items.getExtensions();
//        for (i = 0; i < extArray.length; i++) {
//            _extensions[extArray[i].id] = 0;
//        }
    }

    public function parse(data : Object) : void
    {
//        _data = data;
        for (var key : * in data)
        {
            var itemData : Object = data[key];
            var itemVO : ItemVO;
            if(itemData is ItemVO) {
                itemVO = itemData as ItemVO;
            }
            else
            {
                if(itemData.type == ItemVO.TYPE_PET)
                {
                    var monsters : Dictionary = MonsterVO.DICT[itemData.name];
                    itemVO = ItemVO.createPetItemVO(monsters[1], itemData.id == 24);
                }
                else
                {
                    itemVO = Model.instance.items.getItemVO(itemData.id);
                }
                if (itemData.ext)
                {
                    itemVO.ext = itemData.ext;
                }
            }
            var newItem : Item = Item.create(itemVO);
            newItem.uniqueId = key;
            addItem(newItem);
        }

    }

    public function addItem($item : Item) : void
    {
        if (!_itemsDict[$item.uniqueId])
        {
            var item : Item = $item;
            _itemsDict[item.uniqueId] = item;
            _itemsByType[item.type].push(item.uniqueId);
            if (item.isSpell())
            {
//            if(item.type == ItemTypeVO.spell) {
                _spells["spell" + item.id] = item;
            }
        }
    }

    public function getItemsForView():Array {
        var arr : Array = [];
        for (var key : String in _itemsByType)
        {
            if(key == ItemVO.TYPE_SPELL) continue;
            var itemsbytype : Array = _itemsByType[key];
            arr = arr.concat(itemsbytype);
        }
        return arr;
    }

    public function getSpell($id : Number) : Item
    {
        return _spells["spell" + $id];
    }

    public function isHaveSpell($id : Number) : Boolean
    {

//        trace("isHaveSpell", $id, _spells["spell"+$id]);
        return _spells["spell" + $id] != null;

    }

    public function removeItem(item : Item) : void
    {
        if (_itemsDict[item.uniqueId])
        {

            unwearItem(item);

            delete _itemsDict[item.uniqueId];
//            delete _data[item.uniqueId];


            var index : int = _itemsByType[item.type].indexOf(item.uniqueId);
            if (index >= 0)
            {
                _itemsByType[item.type].splice(index, 1);
            }
        }
    }

    public function wearItem(item : Item) : void
    {
        addToInventory(item.uniqueId);
        update();
    }

    public function unwearItem(item : Item) : void
    {
        removeFromInventory(item.uniqueId);
        update();
    }

    public function setInventoryItems(array : Array) : void
    {
        for (var i : int = 0; i < array.length; i++)
        {
            addToInventory(array[i]);
        }
        update();
    }

    public function update() : void
    {
        updateExtensions();

        _inventoryItems.sort(sortInventory);


        _manaPriority = getSpellsManaTypes();
        dispatchEventWith(UPDATE);
    }

    private function addToInventory(uid : String) : void
    {
        var item : Item = _itemsDict[uid];
        if (item == null)
        {
            return;
        }

        var slotItems : Array = _slots[item.slot] ? _slots[item.slot] : [];
        var slotMax : int = ItemSlotVO.DICT[item.slot].max; // MAX for current slot kind
        var isHaveFree : Boolean = _inventoryItems.length < max_capacity;

//        trace("addToInventory", slotMax, isHaveFree, item.slot, slotItems.length);

        if(slotMax > 0)
        {
            /**
             * unwear something if:
             * - no more slots of this type available
             * - have slots of this type but havent any free slot
             */
            if(slotItems.length >= slotMax || (!isHaveFree && slotItems.length > 0 && slotItems.length <= slotMax))
            {

                removeFromInventory((slotItems[0] as Item).uniqueId);
            }
        }


        if (!isHaveFree)
        {
            return;
        }

        var slotAmount : int = 0;
        if (slotMax > 0)
        { // is limited slot, like only one head or only two hands
            for (var i : int = 0; i < _inventoryItems.length; i++)
            {
                var checkItem : Item = _itemsDict[_inventoryItems[i]];
                if (checkItem.slot == item.slot)
                {
                    slotAmount++;
                    if (slotAmount >= slotMax)
                    {
                        return;
                    }
                }
            }
        }

        item.isWearing = true;

        _inventoryItems.push(uid);
        slotItems.push(item);

        _slots[item.slot] = slotItems;

        item.update();

    }

    private function sortInventory($a : String, $b : String) : int
    {
        var itemA : Item = _itemsDict[$a];
        var itemB : Item = _itemsDict[$b];

        if (itemA.slot < itemB.slot)
        {
            return -1;
        }
        else if (itemA.slot > itemB.slot)
        {
            return 1;
        }
        else
        {
            if (itemA.getDamage() > itemA.getDamage())
            {
                return -1;
            }
            else if (itemA.getDamage() < itemA.getDamage())
            {
                return 1;
            }
        }
        return 0;
    }

    private function removeFromInventory(uid : String) : void
    {
        var item : Item = _itemsDict[uid];
        var index : int = _inventoryItems.indexOf(uid);
        if (index >= 0)
        {
            item.isWearing = false;
            var slotItems : Array = _slots[item.slot];
            slotItems.splice(slotItems.indexOf(item));
            _inventoryItems.splice(index, 1);
            item.update();
        }
    }

    private function updateExtensions() : void
    {
        for (var key : String in _extensions)
        {
            _extensions[key] = 0;
        }

        for (var i : int = 0; i < _inventoryItems.length; i++)
        {
            var item : Item = _itemsDict[_inventoryItems[i]];
            if (!item.isSpell())
            {

                _extensions[DamageExt.TYPE] = _extensions[DamageExt.TYPE] ? _extensions[DamageExt.TYPE] + item.getDamage() : item.getDamage();
                _extensions[DefenceExt.TYPE] = _extensions[DefenceExt.TYPE] ? _extensions[DefenceExt.TYPE] + item.getDefence() : item.getDefence();

            }
        }
//        trace("UPD EXTENSIONS", JSON.stringify(_extensions));
    }

    public function getItemsByName($code : String) : Array
    {
        var arr : Array = [];
        for (var uid : String in _itemsDict)
        {
            var item : Item = _itemsDict[uid];
            if (item.name == $code)
            {
                arr.push(item);
            }
        }
        return arr;
    }

    public function get items() : Object
    {
        return _itemsDict;
    }

    public function get manaPriority() : Array
    {
        return _manaPriority;
    }

    public function get spells() : Object
    {
        return _spells;
    }

    public function set spells(value : Object) : void
    {
        _spells = value;
    }

    public function clearSlot($id : String) : void
    {
        var arr : Array = _slots[$id];
        if(arr) {
            for (var i : int = 0; i < arr.length; i++)
            {
                var item : Item = arr[i];
                unwearItem(item);
                removeItem(item);

            }
        }
    }
}
}
