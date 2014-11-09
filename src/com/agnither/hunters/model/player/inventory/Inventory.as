/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.ExtensionVO;
import com.agnither.hunters.data.outer.ItemSlotVO;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.items.ItemVO;

import flash.utils.Dictionary;

import starling.events.EventDispatcher;

public class Inventory extends EventDispatcher {

    public static const UPDATE: String = "update_Inventory";

    public static var max_capacity: uint = 6;

    private var _data: Object;

    private var _inventoryItems : Array = []; // of String
    public function get inventoryItems():Array {
        return _inventoryItems;
    }

    private var _itemsDict: Object = new Object();
    public function getItem(name: String):Item {
        trace("GET ITEM", name, _itemsDict[name]);
        return _itemsDict[name];
    }

    private var _itemsByType: Dictionary = new Dictionary();
    public function getItemsByType(type : int):Array { // of String
        return _itemsByType[type];
    }

    private var _extensions: Dictionary = new Dictionary();
    private var _spells : Object = {};
    public function getExtension(type: int):int {
        return _extensions[type];
    }

    public function get damage():int {
        return getExtension(ExtensionVO.damage);
    }

    public function get defence():int {
        return getExtension(ExtensionVO.defence);
    }

    public function Inventory() {

    }

    public function init():void {
        for (var i: int = 0; i < ItemTypeVO.LIST.length; i++) {
            _itemsByType[ItemTypeVO.LIST[i].id] = [];
        }
        var extArray : Vector.<ExtensionVO> = Model.instance.items.getExtensions();
        for (i = 0; i < extArray.length; i++) {
            _extensions[extArray[i].id] = 0;
        }
    }

    public function parse(data : Object) : void {
        _data = data;
        for (var key: * in data) {
            var itemData: Object = data[key];
            var item : ItemVO = Model.instance.items.getItem(itemData.id);
            var newItem : Item = Item.createItem(item, itemData.extension);
            newItem.uniqueId = key;

            addItem(newItem);

//            _itemsDict[key] = newItem;
//            _itemsByType[item.type].push(key);
        }
    }

    public function addItem($item: Item):void {
        if (!_itemsDict[$item.uniqueId]) {
            var item : Item = Item.createItem($item.item, $item.extension);
            item.uniqueId = $item.uniqueId;
            _itemsDict[item.uniqueId] = item;
            _itemsByType[item.type].push(item.uniqueId);
            trace("**", item.uniqueId, item.type, item.type == ItemTypeVO.spell);
            if(item.type == ItemTypeVO.spell) {
                _spells["spell"+item.id] = item;
                trace("spell"+item.id, item, _spells["spell"+item.id])
            }

            _data[item.uniqueId] = {id: item.id, extension: item.extension};
        }
    }

    public function isHaveSpell($id : Number):Boolean {

        trace("isHaveSpell", $id, _spells["spell"+$id]);
        return _spells["spell"+$id] != null;

    }

    public function removeItem(item: Item):void {
        if (_itemsDict[item.uniqueId]) {

            unwearItem(item);

            delete _itemsDict[item.uniqueId];
            delete _data[item.uniqueId];


            var index: int = _itemsByType[item.type].indexOf(item.uniqueId);
            if (index >= 0) {
                _itemsByType[item.type].splice(index, 1);
            }
        }
    }

    public function wearItem(item: Item):void {
        addToInventory(item.uniqueId);
        update();
    }

    public function unwearItem(item: Item):void {
        removeFromInventory(item.uniqueId);
        update();
    }

    public function setInventoryItems(array : Array) : void {
        for (var i : int = 0; i < array.length; i++) {
            addToInventory(array[i]);
        }
        update();
    }

    public function update():void {
        updateExtensions();

        _inventoryItems.sort(sortInventory);

        dispatchEventWith(UPDATE);
    }

    private function addToInventory(uid : String) : void {
        var item : Item = _itemsDict[uid];
        if(item == null) {
            return;
        }


        var slotMax : int = ItemSlotVO.DICT[item.slot].max; // MAX for current slot kind

        var isHaveFree : Boolean = _inventoryItems.length < max_capacity;
        if(!isHaveFree) {
            return;
        }

        var slotAmount : int = 0;
        if(slotMax > 0) { // is limited slot, like only one head or only two hands
            for (var i : int = 0; i < _inventoryItems.length; i++)
            {
                var checkItem : Item = _itemsDict[_inventoryItems[i]];
                if(checkItem.slot == item.slot) {
                    slotAmount++;
                    if(slotAmount >= slotMax) {
                        return;
                    }
                }
            }
        }

        item.isWearing = true;
        _inventoryItems.push(uid);




    }

    private function sortInventory($a : String, $b : String) : int
    {
        var itemA : Item = _itemsDict[$a];
        var itemB : Item = _itemsDict[$b];

        if(itemA.slot < itemB.slot) {
            return -1;
        }
        else if (itemA.slot > itemB.slot)
        {
            return 1;
        } else {
            if(itemA.extension[ExtensionVO.damage] > itemA.extension[ExtensionVO.damage]) {
                return -1;
            } else if (itemA.extension[ExtensionVO.damage] < itemA.extension[ExtensionVO.damage]) {
                return 1;
            }
        }
        return 0;
    }

    private function removeFromInventory(uid : String) : void {
        var item : Item = _itemsDict[uid];
        var index: int = _inventoryItems.indexOf(uid);
        if (index >= 0) {
            item.isWearing = false;
            _inventoryItems.splice(index, 1);
        }
    }

    private function updateExtensions() : void {
        for (var key: * in _extensions) {
            _extensions[key] = 0;
        }

        for (var i : int = 0; i < _inventoryItems.length; i++) {
            var item: Object = _itemsDict[_inventoryItems[i]];
            if (item.type != ItemTypeVO.spell) {
                var extension:Object = item.extension;
                for (key in extension) {
                    if (!isNaN(extension[key])) {
                        _extensions[key] += int(extension[key]);
                    } else {

                        // what should we do if value is array?

                    }
                }
            }
        }
    }

    public function getItemsByName($code : String) : Array {
        var arr : Array = [];
        for (var uid : String in _itemsDict)
        {
            var item : Item = _itemsDict[uid];
            if(item.name == $code) {
                arr.push(item);
            }
        }
        return arr;
    }

    public function get items() : Object
    {
        return _itemsDict;
    }
}
}
