/**
 * Created by mor on 23.11.2014.
 */
package com.agnither.hunters.model.modules.extensions
{
import com.agnither.hunters.model.player.inventory.Item;

public class MirrorDamageExt extends Extension
{

    public static const TYPE : String = "mirror_damage";
    private var _chance : Number;
    private var _percent : Number;

    public function MirrorDamageExt($args : Array)
    {
        super($args);


        /**
         * if there is min amd max values - generate new static value and delete min/max
         */
    }


    override protected function fill() : void
    {
//        trace("fill-----",_extArguments);
        _chance = _extArguments[0];
        _percent = _extArguments[1];
    }


    override public function toObject() : Object
    {
//        var obj : Object = {};
//        obj[TYPE] = [_chance, _percent];
//        return obj;
        return [_chance, _percent];
    }

    public function isLucky() : Boolean
    {
        var roll : Number = Math.random() * 100;
//        trace("IS MIRROR", roll, "==",_chance);
        return _chance >= roll;
    }

    public function get percent() : Number
    {
        return _percent / 100;
    }

    override public function getBaseValue() : Number
    {
        return _chance;
    }

    override public function getDescription() : String
    {
        var description : String = super.getDescription() + " "
                                   +_percent+"% от урона.";


        return description;
    }
}
}
