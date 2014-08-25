/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.ItemSlotVO;
import com.agnither.hunters.data.outer.ItemVO;

import flash.utils.Dictionary;

import starling.events.EventDispatcher;

public class Inventory extends EventDispatcher {

    private var _data: Object;

    private var _stockItems: Vector.<String> = new <String>[];
    private var _inventoryItems : Vector.<String> = new <String>[];
    private var _itemsDict: Dictionary = new Dictionary();
    private var _itemsByType: Dictionary = new Dictionary();
    private var _extensions: Dictionary = new Dictionary();
    private var MAX_INVENTORY : uint = 6;

    public function getItem(name: String):Item {
        return _itemsDict[name];
    }
    public function get stockItems():Vector.<String> {
        return _stockItems;
    }
    public function get inventoryItems() : Vector.<String> {
        return _inventoryItems;
    }


    public function Inventory() {
    }


    private var _damage: int = 0;
    public function get damage():int {
        return _extensions["1"];
    }



//    private var _defence: int = -1;
    public function get defence():int {
        return _extensions["2"];
    }



//    public function parse(data: Object):void {
//        _data = data;
//
//    }



    public function parse(data : Object) : void {
//        _itemsDict = new Dictionary();
        for (var key: * in data) {
            var itemData: Object = data[key];
            var item : ItemVO = ItemVO.DICT[itemData.id];
            var newItem : Item = new Item(item, itemData);
            newItem.uniqueId = key;

            _itemsDict[key] = newItem;
            _stockItems.push(key);

            var typeArr : Vector.<String> = _itemsByType[item.type];
            if(!typeArr) {
                _itemsByType[item.type] = typeArr = new <String>[];
            }
            typeArr.push(key);
        }
    }

    public function getItemsByType(type : int):Vector.<String> {

        var typeArr : Vector.<String> = _itemsByType[type];
        if(!typeArr) {
            _itemsByType[type] = typeArr = new <String>[];
        }
        return typeArr;

    }

    public function addItem(item: Item):void {

        if(_stockItems.indexOf(item.uniqueId) == -1) {
            _stockItems.push(item);
            _itemsDict[item.name] = item;
        }

    }

    public function clearList():void {
        while (_stockItems.length > 0) {
            var uid : String = _stockItems.shift();
            var item: Item = _itemsDict[uid];
            item.destroy();
            delete _itemsDict[uid];
            var inventoryIndex : int = _inventoryItems.indexOf(uid);
            if( inventoryIndex > -1) {
                _inventoryItems.splice(inventoryIndex, 1);
            }
        }
    }

    public function setInventoryItems(array : Array) : void {

        for (var i : int = 0; i < array.length; i++)
        {

            addToInventory(array[i]);

        }
    }

    private function addToInventory(uid : String) : void {
        var item : Item = _itemsDict[uid];
        var slotType : int = item.slot; // current slot kind
        var slotMax : int = ItemSlotVO.DICT[slotType]; // MAX for current slot kind

        var isHaveFree : Boolean = _inventoryItems.length < MAX_INVENTORY;
        if(!isHaveFree) {
            return;
        }

        var slotAmount : int = 0;
        if(slotMax > 0) { // is limited slot, like only one head or only two hands
            for (var i : int = 0; i < _inventoryItems.length; i++)
            {
                var checkItem : Item = _itemsDict[_inventoryItems[i]];
                if(checkItem.slot == slotType) {
                    slotAmount++;
                    if(slotAmount >= slotMax) {
                        return;
                    }
                }
            }
        }

        _inventoryItems.push(uid);

        updateExtensions();

//        for (var key : * in item.extension)
//        {
//            switch (key) {
//                case "melee_damage" :
//                    isUpdateDamage = true;
//                    break;
//            }
//
//
//
//        }



    }

    private function updateExtensions() : void {
        _extensions = new Dictionary();
        for (var i : int = 0; i < _inventoryItems.length; i++)
        {
            var item : Object = _itemsDict[_inventoryItems[i]].extension;
            for (var key : * in item)
            {
                if(!_extensions[key]) {
                    _extensions[key] = 0;
                }
                if(!isNaN(item[key])) {
                    _extensions[key] += item[key];
                } else {

                    // what should we do if value is array?

                }
            }
        }
    }


}
}
