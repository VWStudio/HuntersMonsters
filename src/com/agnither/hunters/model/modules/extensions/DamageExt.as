/**
 * Created by mor on 23.11.2014.
 */
package com.agnither.hunters.model.modules.extensions
{
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.player.inventory.Item;

public class DamageExt extends Extension
{

    public static const TYPE : String = "damage";
    private var _damage : Number;
    private var _damageType : String;

    public function DamageExt($args : Array)
    {
        super($args);


        /**
         * if there is min amd max values - generate new static value and delete min/max
         */
    }


    override protected function fill() : void
    {
        _damageType = _extArguments[0];
        if(_extArguments.length > 2) {
            var min : Number = _extArguments[1];
            var max : Number = _extArguments[2];
            _damage = Math.round(getRandomExtValue(min, max));
            _extArguments = [_damageType,_damage];
        } else
        {
            _damage = _extArguments[1];
        }
    }


    override public function updateItem($item : Item) : void
    {
        $item.damage = $item.getDamage() + _damage;
    }


    public function getType() : String
    {
        return _damageType;
    }
    override public function getBaseValue() : Number
    {
        return _damage;
    }


    override public function getDescription() : String
    {
        return Locale.getString(TYPE) + ":"+_damage;
    }
}
}
