/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.ExtensionVO;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.model.modules.items.ItemVO;

import starling.events.EventDispatcher;

public class Item extends EventDispatcher {

    public static const UPDATE: String = "update_Item";

//    private var _extension: Object;
    protected var _item: ItemVO;

    public var uniqueId: String;
    public var amount: int = 0;
    public var isWearing : Boolean = false;

    public static function create($data: ItemVO):Item {
        var item : Item;
        switch ($data.type) {
            case ItemTypeVO.weapon:
            case ItemTypeVO.armor:
            case ItemTypeVO.magic:
            case ItemTypeVO.gold:
            case ItemTypeVO.spell:
                item = new Item($data);
                break;
//                item = new Spell($data);
//                break;
        }
//        if(item && $extension) {
//            item.setExtension($extension);
//        }


        return item;
    }

    public function Item($item: ItemVO) {
        _item = $item;
    }

//    protected function updateExtensions() : void
//    {
//
//        for (var key : String in _extension)
//        {
//            if(ExtensionVO.damage.toString() == key) {
//                _damage = _extension[key];
//            }
//            if(ExtensionVO.defence.toString() == key) {
//                _defence = _extension[key];
//            }
//        }
//    }

//    public static function createDrop(data: ItemVO):Item {
//        var extension: Object = {};
//        for (var key: * in data.extension) {
//            extension[key] = data.getDropExtensionValue(key);
//        }
//        var item : Item = new Item(data, extension);
//        item.uniqueId = Util.uniq(ItemTypeVO.DICT[item.type].name);
//        return item;
//    }




//    public function get extension():Object {
//        return _extension;
//    }
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
    public function isGold() : Boolean {
        return _item.type == ItemTypeVO.gold;
    }
    public function isSpell() : Boolean {
        return _item.type == ItemTypeVO.spell;
    }
    public function get slot():int {
        return _item.slot;
    }
    public function get icon():String {
        return _item.droppicture;
    }
    public function get mana():Object {
        return _item.extension_drop;
    }

//    public function get extension_drop():Object {
//        return _item.extension_drop;
//    }

//    private var _isWearing: Boolean;
//    public function set isWearing(value: Boolean):void {
//        _isWearing = value;
//        update();
//    }
//    public function get isWearing():Boolean {
//        return _isWearing;
//    }


    public function update():void {
        dispatchEventWith(UPDATE);
    }

    public function destroy():void {
        _item = null;
    }

    public function getDamage() : int
    {
        return _item.extension ? _item.extension[ExtensionVO.damage] : 0;
    }

    public function getDefence() : int
    {
        return _item.extension ? _item.extension[ExtensionVO.defence] : 0;
    }

    /**
     * XXX required to save
     */
    public function get extension() : Object
    {
        return _item.extension;
    }
}
}
