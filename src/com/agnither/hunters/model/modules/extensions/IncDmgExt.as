/**
 * Created by mor on 23.11.2014.
 */
package com.agnither.hunters.model.modules.extensions
{
import com.agnither.hunters.model.player.inventory.Item;

public class IncDmgExt extends Extension
{

    public static const TYPE : String = "increase_dmg";
    private var _percent : Number;

    public function IncDmgExt($args : Array)
    {
        super($args);


        /**
         * if there is min amd max values - generate new static value and delete min/max
         */
    }


    override protected function fill() : void
    {
        _percent = _extArguments[0];
    }


    override public function toObject() : Object
    {
        return _percent;
    }

    public function get percent() : Number
    {
        return _percent / 100;
    }

    override public function getBaseValue() : Number
    {
        return _percent;
    }

    override public function getDescription() : String
    {
        var description : String = super.getDescription() + ", "
                                   +_percent+"%";


        return description;
    }
}
}
