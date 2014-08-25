/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.ExtensionVO;
import com.agnither.hunters.data.outer.ItemSlotVO;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.data.outer.ItemVO;

import flash.utils.Dictionary;

import starling.events.EventDispatcher;

public class Inventory extends EventDispatcher {

    public static var max_capacity: uint = 6;

    private var _stockItems: Array = []; // of String
    public function get stockItems():Array {
        return _stockItems;
    }

    private var _inventoryItems : Array = []; // of String
    public function get inventoryItems():Array {
        return _inventoryItems;
    }

    private var _itemsDict: Dictionary = new Dictionary();
    public function getItem(name: String):Item {
        return _itemsDict[name];
    }

    private var _itemsByType: Dictionary = new Dictionary();
    public function getItemsByType(type : int):Array { // of String
        return _itemsByType[type];
    }

    private var _extensions: Dictionary = new Dictionary();
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

        for (i = 0; i < ExtensionVO.LIST.length; i++) {
            _extensions[ExtensionVO.LIST[i].id] = 0;
        }
    }

    public function parse(data : Object) : void {
        for (var key: * in data) {
            var itemData: Object = data[key];
            var item : ItemVO = ItemVO.DICT[itemData.id];
            var newItem : Item = new Item(item, itemData.extension);
            newItem.uniqueId = key;

            _itemsDict[key] = newItem;
            _stockItems.push(key);
            _itemsByType[item.type].push(key);
        }
    }

    public function addItem(item: Item):void {
        if (!_itemsDict[item.uniqueId]) {
            _itemsDict[item.uniqueId] = item;
            _stockItems.push(item);
        }
    }

    public function removeItem(item: Item):void {
        if (_itemsDict[item.uniqueId]) {
            delete _itemsDict[item.uniqueId];
            var index: int = _stockItems.indexOf(item);
            if (index >= 0) {
                _stockItems.splice(index, 1);
            }
        }
    }

    public function setInventoryItems(array : Array) : void {
        for (var i : int = 0; i < array.length; i++) {
            addToInventory(array[i]);
        }

        updateExtensions();
    }

    private function addToInventory(uid : String) : void {
        var item : Item = _itemsDict[uid];
        var slotType : int = item.slot; // current slot kind
        var slotMax : int = ItemSlotVO.DICT[slotType]; // MAX for current slot kind

        var isHaveFree : Boolean = _inventoryItems.length < max_capacity;
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
    }

    private function updateExtensions() : void {
        for (var i : int = 0; i < _inventoryItems.length; i++) {
            var item: Object = _itemsDict[_inventoryItems[i]];
            if (item.type != ItemTypeVO.spell) {
                var extension:Object = item.extension;
                for (var key:* in extension) {
                    if (!isNaN(extension[key])) {
                        _extensions[key] += int(extension[key]);
                    } else {

                        // what should we do if value is array?

                    }
                }
            }
        }
    }


}
}
