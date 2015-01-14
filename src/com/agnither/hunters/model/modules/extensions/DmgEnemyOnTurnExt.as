/**
 * Created by mor on 23.11.2014.
 */
package com.agnither.hunters.model.modules.extensions
{
import com.agnither.hunters.model.player.inventory.Item;

public class DmgEnemyOnTurnExt extends Extension
{

    public static const TYPE : String = "dmg_on_turn";
    private var _amount : Number;

    public function DmgEnemyOnTurnExt($args : Array)
    {
        super($args);
    }


    override protected function fill() : void
    {
        _amount = _extArguments[0];
    }


    override public function toObject() : Object
    {
        return _amount;
    }

    public function get amount() : Number
    {
        return _amount;
    }

    override public function getBaseValue() : Number
    {
        return _amount;
    }

    override public function getDescription() : String
    {
        var description : String = super.getDescription() + ", "
                                   +_amount+"%";


        return description;
    }
}
}
