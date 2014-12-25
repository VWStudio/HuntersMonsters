/**
 * Created by mor on 23.11.2014.
 */
package com.agnither.hunters.model.modules.extensions
{
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.model.player.inventory.Item;

public class ManaExt extends Extension
{

    public static const TYPE : String = "mana";
    private var _mana : Object;

    public function ManaExt($args : Array)
    {
        super($args);


        /**
         * if there is min amd max values - generate new static value and delete min/max
         */
    }


    override protected function fill() : void
    {

        _mana = {};
//        trace("MANA FILL", JSON.stringify(_extArguments));
        for (var i : int = 0; i < int(_extArguments.length / 2); i++)
        {
            var magic: MagicTypeVO = MagicTypeVO.DICT[_extArguments[i * 2].toString()];
//            trace(i, magic, magic.name);
            _mana[magic.name] = _extArguments[i * 2 + 1];
        }

//        trace("Mana extension:", JSON.stringify(_mana));
    }


    public function getManaObj() : Object
    {
        return _mana;
    }


    override public function toObject() : Object
    {
//        var obj : Object = {};
//        obj[TYPE] = _mana;
//        return obj;
        return _extArguments;
    }
}
}
