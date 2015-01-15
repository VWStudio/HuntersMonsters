/**
 * Created by mor on 23.11.2014.
 */
package com.agnither.hunters.model.modules.extensions
{
import com.agnither.hunters.model.player.inventory.Item;

public class SpellDefenceExt extends Extension
{

    public static const TYPE : String = "spell_defence";
    private var _type : String;
    private var _percent : Number;

    public function SpellDefenceExt($args : Array)
    {
        super($args);


        /**
         * if there is min amd max values - generate new static value and delete min/max
         */
    }


    override protected function fill() : void
    {
        _type = _extArguments[0];
        _percent = _extArguments[1];
    }


    override public function toObject() : Object
    {
//        var obj : Object = {};
//        obj[TYPE] = [_type, _amount];
        return [_type, _percent];
    }

    public function getType() : String
    {
        return _type;
    }

    public function getPercent() : Number
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
                                   +_type+", "+_percent;


        return description;
    }

}
}
