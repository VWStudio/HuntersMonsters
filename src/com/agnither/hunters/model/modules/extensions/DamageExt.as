/**
 * Created by mor on 23.11.2014.
 */
package com.agnither.hunters.model.modules.extensions
{
import com.agnither.hunters.model.player.inventory.Item;

public class DamageExt extends Extension
{

    public static const TYPE : String = "damage";
    private var _damage : Number;
    private var _damageType : String;

    public function DamageExt($args : Array)
    {
        super($args);


        /**
         * if there is min amd max values - generate new static value and delete min/max
         */
    }


    override protected function fill() : void
    {
        _damageType = _arguments[0];
        if(_arguments.length > 2) {
            var min : Number = _arguments[1];
            var max : Number = _arguments[2];
            _damage = getRandomExtValue(min, max);
            _arguments = [_damageType,_damage];
        } else
        {
            _damage = _arguments[1];
        }
    }


    override public function updateItem($item : Item) : void
    {
        if($item.hasOwnProperty(TYPE)) {
            $item[TYPE] = _damage;
        }
    }


//    override public function toObject() : Object
//    {
////        var obj : Object = {};
////        obj[TYPE] = _damage;
//        return _damage;
//    }

    public function getType() : String
    {
        return _damageType;
    }
    override public function getBaseValue() : Number
    {
        return _damage;
    }
}
}
