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

    public function DamageExt($args : Array)
    {
        super($args);


        /**
         * if there is min amd max values - generate new static value and delete min/max
         */
    }


    override protected function fill() : void
    {
        if(_arguments.length > 1) {
            var min : Number = _arguments[0];
            var max : Number = _arguments[1];
            _damage = getRandomExtValue(min, max);
            _arguments = [_damage];
        } else
        {
            _damage = _arguments[0];
        }
    }


    override public function updateItem($item : Item) : void
    {
        if($item.hasOwnProperty(TYPE)) {
            $item[TYPE] = _damage;
        }
    }


    override public function toObject() : Object
    {
//        var obj : Object = {};
//        obj[TYPE] = _damage;
        return _damage;
    }


    override public function getBaseValue() : Number
    {
        return _damage;
    }
}
}
