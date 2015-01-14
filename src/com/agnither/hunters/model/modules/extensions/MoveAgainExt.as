/**
 * Created by mor on 23.11.2014.
 */
package com.agnither.hunters.model.modules.extensions
{
import com.agnither.hunters.model.player.inventory.Item;

public class MoveAgainExt extends Extension
{

    public static const TYPE : String = "move_again";

    public function MoveAgainExt($args : Array)
    {
        super($args);


        /**
         * if there is min amd max values - generate new static value and delete min/max
         */
    }


    override protected function fill() : void
    {
//        _percent = _extArguments[0];
    }


    override public function toObject() : Object
    {
        return [];
    }

//    public function get percent() : Number
//    {
//        return _percent / 100;
//    }

    override public function getBaseValue() : Number
    {
        return 1;
    }

    override public function getDescription() : String
    {
        var description : String = super.getDescription();



        return description;
    }
}
}
