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
        _chance = _arguments[0];
        _percent = _arguments[1];
    }


    override public function toObject() : Object
    {
//        var obj : Object = {};
//        obj[TYPE] = [_chance, _percent];
//        return obj;
        return _percent;
    }

    public function isLucky() : Boolean
    {
        var roll : Number = Math.random() * 100;
        return _chance > roll;
    }

    public function get percent() : Number
    {
        return _percent / 100;
    }

    override public function getBaseValue() : Number
    {
        return _chance;
    }

}
}
