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
        for (var i : int = 0; i < int(_arguments.length / 2); i++)
        {
            var magic: MagicTypeVO = MagicTypeVO.DICT[_arguments[i * 2].toString()];
            _mana[magic.name] = _arguments[i * 2 + 1];
        }

//        trace("Mana extension:", JSON.stringify(_mana));
    }


    override public function updateItem($item : Item) : void
    {
//        if($item.hasOwnProperty(TYPE)) {
//            $item[TYPE] = _mana;
//        }
    }


    override public function toObject() : Object
    {
//        var obj : Object = {};
//        obj[TYPE] = _mana;
//        return obj;
        return _mana;
    }
}
}
