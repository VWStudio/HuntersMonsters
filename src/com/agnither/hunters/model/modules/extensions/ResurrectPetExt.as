/**
 * Created by mor on 23.11.2014.
 */
package com.agnither.hunters.model.modules.extensions
{
import com.agnither.hunters.model.player.inventory.Item;

public class ResurrectPetExt extends Extension
{

    public static const TYPE : String = "resurrect_pet";
    private var _hpPercent : Number;

    public function ResurrectPetExt($args : Array)
    {
        super($args);


        /**
         * if there is min amd max values - generate new static value and delete min/max
         */
    }


    override protected function fill() : void
    {
        _hpPercent = _extArguments[0];
    }


    override public function toObject() : Object
    {
//        var obj : Object = {};
//        obj[TYPE] = _hpPercent;
        return _hpPercent;
    }

    public function getPercent() : Number
    {
        return _hpPercent / 100;
    }

    override public function getBaseValue() : Number
    {
        return _hpPercent;
    }

    override public function getDescription() : String
    {
        var description : String = super.getDescription() + ", "
                                   +"hp "+_hpPercent+"%";


        return description;
    }

}
}
