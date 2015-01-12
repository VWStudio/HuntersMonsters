/**
 * Created by mor on 23.11.2014.
 */
package com.agnither.hunters.model.modules.extensions
{
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.model.modules.locale.Locale;
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

    override public function getDescription() : String
    {
        var str : String = "";

        for (var i : int = 0; i < int(_extArguments.length / 2); i++)
        {
            str += _extArguments[i*2+1];
            str += " ";
            str += Locale.getString(_extArguments[i*2]);
            if (i+1 < int(_extArguments.length / 2)) str += "    ";
        }

        return str;
        //return Locale.getString(TYPE) + ": ";
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
