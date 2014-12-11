/**
 * Created by mor on 23.11.2014.
 */
package com.agnither.hunters.model.modules.extensions
{
import com.agnither.hunters.model.player.inventory.Item;

public class DefenceExt extends Extension
{

    public static const TYPE : String = "defence";
    private var _defence : Number;

    public function DefenceExt($args : Array)
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
            _defence = getRandomExtValue(min, max);
            _arguments = [_defence];
        } else
        {
            _defence = _arguments[0];
        }
    }


    override public function updateItem($item : Item) : void
    {
        $item.defence = $item.getDefence() + _defence;
    }


    override public function toObject() : Object
    {
        return _defence;
    }

    override public function getBaseValue() : Number
    {
        return _defence;
    }
}
}
