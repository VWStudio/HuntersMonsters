/**
 * Created by mor on 23.11.2014.
 */
package com.agnither.hunters.model.modules.extensions
{
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.player.inventory.Item;

public class DoubleDropExt extends Extension
{

    public static const TYPE : String = "double_drop";
    private var _chance : Number;

    public function DoubleDropExt($args : Array)
    {
        super($args);


        /**
         * if there is min amd max values - generate new static value and delete min/max
         */
    }


    override protected function fill() : void
    {
        _chance = _arguments[0];
    }


    override public function toObject() : Object
    {
//        var obj : Object = {};
//        obj[TYPE] = _chance;
//        return obj;
        return _chance;
    }

    public function isLucky() : Boolean
    {
        var roll : Number = Math.random() * 100;
        return _chance > roll;
    }

    override public function getBaseValue() : Number
    {
        return _chance;
    }


    override public function getDescription() : String
    {
        var description : String = super.getDescription() + ", "
                +_chance+"%";


        return description;
    }
}
}
