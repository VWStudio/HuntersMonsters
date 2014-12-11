/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory
{
import com.agnither.hunters.model.modules.extensions.Extension;
import com.agnither.hunters.model.modules.extensions.ManaExt;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.cemaprjl.utils.Util;

import starling.events.EventDispatcher;

public class Item extends EventDispatcher
{

    public static const UPDATE : String = "update_Item";

//    private var _extension: Object;
    protected var _item : ItemVO;

    public var uniqueId : String;
    public var amount : int = 0;
    public var isWearing : Boolean = false;
    private var _extensions : Object;
    private var _damage : int = 0;
    private var _defence : int = 0;

    public static function create($data : ItemVO) : Item
    {
        var item : Item;
//        switch ($data.type) {
//            case ItemTypeVO.weapon:
//            case ItemTypeVO.armor:
//            case ItemTypeVO.gold:
//            case ItemTypeVO.spell:
//            case ItemTypeVO.magic:
//                item = new Item($data);
//                break;
//                trace(JSON.stringify($data));
//                item = new Item($data);
//                break;
//                item = new Spell($data);
//        }
//        if(item && $extension) {
//            item.setExtension($extension);
//        }
        item = new Item($data);
        item.uniqueId = Util.uniq(item.name);

        return item;
    }

    public function Item($item : ItemVO)
    {
        _item = $item;
        _extensions = fillExtensions();

        updateProperties();

    }

    private function fillExtensions() : Object
    {
        var resultObj : Object = {};
        for (var key : String in _item.ext)
        {
            var ext : Extension = Extension.create(key, _item.ext[key] is Array ? _item.ext[key] : [_item.ext[key]]);
            resultObj[key] = ext;

            // refill ext in case of generating random to constant values
            _item.ext[key] = ext.toObject();
        }
        return resultObj;
    }

    private function updateProperties() : void
    {
        for (var key : String in _extensions)
        {
            var ext : Extension = _extensions[key];
            ext.updateItem(this);
        }
    }


    public function get id() : int
    {
        return _item.id;
    }

    public function get name() : String
    {
        return _item.name;
    }

    public function get picture() : String
    {
        return _item.picture;
    }

    public function get type() : String
    {
        return _item.type;
    }

    public function isGold() : Boolean
    {
        return _item.type == ItemVO.TYPE_GOLD;
    }

    public function isSpell() : Boolean
    {
        return _item.type == ItemVO.TYPE_SPELL;
    }

    public function isPet() : Boolean
    {
        return _item.type == ItemVO.TYPE_PET;
    }

    public function get slot() : int
    {
        return _item.slot;
    }

    public function get icon() : String
    {
        return _item.droppicture;
    }

    public function getMana() : Object
    {
        return (_extensions[ManaExt.TYPE] as ManaExt).getManaObj();
    }


    public function update() : void
    {
        dispatchEventWith(UPDATE);
    }

    public function destroy() : void
    {
        _item = null;
    }

    public function set damage($val : int) : void
    {
        _damage = $val;
    }

    public function getDamage() : int
    {
        return _damage;
    }

    public function set defence($val : int) : void
    {
        _defence = $val;
    }

    public function getDefence() : int
    {
        return _defence;
    }

    /*
     dictionary of *Ext classes
     */
    public function getExtObj() : Object
    {
        return _extensions;
    }

    /*
     extensions converted from *Ext class
     */
    public function get ext() : Object
    {
        return _item.ext;
    }

    /*
     *Ext class
     */
    public function getExt($type : String) : Extension
    {
        return _extensions[$type];
    }

    public function isWeapon() : Boolean
    {
        return _item.type == ItemVO.TYPE_WEAPON;
    }
    public function isArmor() : Boolean
    {
        return _item.type == ItemVO.TYPE_ARMOR;
    }
}
}
