/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.cemaprjl.utils.Util;

import starling.events.EventDispatcher;

public class Item extends EventDispatcher {

    public static const UPDATE: String = "update_Item";

    public static function createItem(data: ItemVO, extension: Object = null):Item {
        switch (data.type) {
            case ItemTypeVO.weapon:
            case ItemTypeVO.armor:
            case ItemTypeVO.magic:
                return new Item(data, extension);
            case ItemTypeVO.spell:
                return new Spell(data, extension);
        }
        return null;
    }

    public static function createDrop(data: ItemVO):Item {
        var extension: Object = {};
        for (var key: * in data.extension) {
            extension[key] = data.getDropExtensionValue(key);
        }
        var item : Item = new Item(data, extension);
        item.uniqueId = Util.uniq(ItemTypeVO.DICT[item.type].name);
        return item;
    }

    protected var _uniqueId: String;
    public function set uniqueId(value: String):void {
        _uniqueId = value;
    }
    public function get uniqueId():String {
        return _uniqueId;
    }

    private var _extension: Object;
    public function get extension():Object {
        return _extension;
    }

    private var _item: ItemVO;
    public function get id():int {
        return _item.id;
    }
    public function get name():String {
        return _item.name;
    }
    public function get picture():String {
        return _item.picture;
    }
    public function get type():int {
        return _item.type;
    }
    public function get slot():int {
        return _item.slot;
    }
    public function get icon():String {
        return ItemTypeVO.DICT[_item.type].picture;
    }
    public function get extension_drop():Object {
        return _item.extension_drop;
    }

    private var _isWearing: Boolean;
    public function set isWearing(value: Boolean):void {
        _isWearing = value;
        update();
    }
    public function get isWearing():Boolean {
        return _isWearing;
    }

    public function Item(item: ItemVO, extension: Object) {
        _item = item;
        _extension = extension;
    }

    public function update():void {
        dispatchEventWith(UPDATE);
    }

    public function destroy():void {
        _item = null;
        _extension = null;
    }

    public function get item() : ItemVO
    {
        return _item;
    }
}
}
