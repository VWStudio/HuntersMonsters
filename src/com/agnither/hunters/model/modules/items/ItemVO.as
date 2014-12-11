/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.modules.items
{
import com.agnither.hunters.model.modules.extensions.DamageExt;
import com.agnither.hunters.model.modules.extensions.DefenceExt;

import flash.utils.Dictionary;

public class ItemVO
{

    public static const LIST : Vector.<ItemVO> = new <ItemVO>[];
    public static const DICT : Dictionary = new Dictionary();
    public static const THINGS : Vector.<ItemVO> = new <ItemVO>[];
    public static const SPELLS : Vector.<ItemVO> = new <ItemVO>[];
    public static const SETS : Dictionary = new Dictionary();
    public static const ITEMS_BY_TYPE : Dictionary = new Dictionary();

    public static const TYPES : Vector.<String> = new <String>[];
    public static const TYPE_WEAPON : String = "weapon";
    public static const TYPE_ARMOR : String = "armor";
    public static const TYPE_MAGIC : String = "magic";
    public static const TYPE_SPELL : String = "spell";
    public static const TYPE_GOLD : String = "gold";
    public static const TYPE_PET : String = "pet";


    public var id : int;
    public var name : String;
    public var picture : String;
    public var droppicture : String;
    public var dropparam : Array;
    public var type : String;
    public var slot : int;
    public var ext : Object;
    public var setname : String;

    public static function get goldItemVO() : ItemVO
    {
        var obj : Object = {};
        obj.id = 0;
        obj.name = "goldItemVO";
        obj.picture = "";
        obj.type = "gold";
        obj.slot = 0;
        obj.setname = "";
        obj.droppicture = "drop_gold";

        return ItemVO.fill(new ItemVO(), obj)
    }

    public static function parseData(data : Object) : void
    {
        for (var i : int = 0; i < data.length; i++)
        {
            var source : Object = data[i];
            source.ext = parseExtension(source.ext);

            if(source.dropparam) {
                source.dropparam = source.dropparam.split(",");
            }

            var object : ItemVO = fill(new ItemVO(), source);
            LIST.push(object);
            DICT[object.id] = object;

            if (object.type == "spell")
            {
                SPELLS.push(object);
            }
            else if (object.type == "tamed_pet" || object.type == "pet")
            {

            }
            else
            {
                THINGS.push(object);
            }

            if (!SETS[object.setname])
            {
                SETS[object.setname] = [];
            }
            SETS[object.setname].push(object);


            if (!ITEMS_BY_TYPE[object.type])
            {
                ITEMS_BY_TYPE[object.type] = new Vector.<ItemVO>();
                TYPES.push(object.type);

            }

            ITEMS_BY_TYPE[object.type].push(object)
        }
    }

    public static function parseExtension(string : String) : Object
    {
        if (!string)
        {
            return null;
        }

        var object : Object = {};
        var array : Array = string.split(";");
        for (var i : int = 0; i < array.length; i++)
        {
            var row : Array = array[i].split(":");
            var id : String = row[0];
            var value : String = row[1];
            var obj : Object = JSON.parse(value);
            object[id] = obj is Array ? obj : [obj];
        }
        return object;
    }

    private static function getValue(data : String) : int
    {
        var value : Object = JSON.parse(data);
        if (value is Array)
        {
            var min : int = value[0];
            var max : int = value[1];
            return min + Math.random() * (max + 1 - min);
        }
        return value as int;
    }

    public static function fill($target : ItemVO, $source : Object) : ItemVO
    {

        var source : Object = $source;
        if (source.constructor != Object)
        {
            source = JSON.parse(JSON.stringify(source));
        }
        for (var key : String in source)
        {
            if ($target.hasOwnProperty(key))
            {
                $target[key] = source[key];
            }
        }
        return $target;
    }

    public function clone() : ItemVO
    {
        return fill(new ItemVO(), this);
    }

    public function isFitsParam($val : Number) : Boolean
    {
        return $val >= dropparam[0] && $val <= dropparam[1];

    }
}
}
