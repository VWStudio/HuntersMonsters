/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.modules.items
{
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.extensions.DamageExt;
import com.agnither.hunters.model.modules.extensions.DefenceExt;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.modules.players.SettingsVO;

import flash.utils.Dictionary;

public class ItemVO
{

    public static const LIST : Vector.<ItemVO> = new <ItemVO>[];
    public static const DICT : Dictionary = new Dictionary();
    public static const THINGS : Vector.<ItemVO> = new <ItemVO>[];
    public static const SPELLS : Vector.<ItemVO> = new <ItemVO>[];
    public static const SETS : Dictionary = new Dictionary();
    public static const ITEMS_BY_TYPE : Dictionary = new Dictionary();
    public static const ITEMS_BY_SLOT : Dictionary = new Dictionary();

    public static const TYPES : Vector.<String> = new <String>[];
    public static const TYPE_WEAPON : String = "weapon";
    public static const TYPE_ARMOR : String = "armor";
    public static const TYPE_MAGIC : String = "magic";
    public static const TYPE_SPELL : String = "spell";
    public static const TYPE_GOLD : String = "gold";
    public static const TYPE_PET : String = "pet";
    public static const TYPE_TAMED_PET : String = "tamed_pet";


//    public var id : int;
    public var name : String;
    public var picture : String;
    public var droppicture : String;
    public var dropparam : Array;
    public var type : String;
    public var slot : int;
    public var price : int;
    public var pricecrystal : int;
    public var ext : Object;
    public var setname : String;
    public var localekey : String = "";
    public var enemy : Boolean;

    public static function createPetItemVO($monster : MonsterVO, $isTamed : Boolean = false, isEnemy:Boolean = false) : ItemVO {

        var obj : Object = {};
//        obj.id = $isTamed ? 24 : 23;
        obj.name = $monster.id;
        obj.picture = $monster.itemimage;
        obj.price = 0;
//        obj.picture = "magic_dark";
        obj.type = "pet";
        obj.localekey = $monster.id;

        obj.slot = 0;
        //if (Model.instance.progress.tamedMonsters.indexOf($monster.id) >= 0) obj.slot = 1;
        obj.slot = $isTamed ? 1 : 0;

        obj.enemy = isEnemy;

        obj.setname = "";
        obj.droppicture = "";
        var extObj : Object = {monster:$monster.id};
        if($monster.extension) {
            for (var meKey : String in $monster.extension)
            {
                extObj[meKey] = $monster.extension[meKey];
            }


        }
//        if(SettingsVO.DICT[$monster.id+"Extension"]) {
//            var str : String = SettingsVO.DICT[$monster.id+"Extension"];
//            var extArr : Array = str.split(":");
//            extObj[extArr[0]] = JSON.parse(extArr[1]);
//        }
//        trace($monster.id, $monster.id+"Extension", SettingsVO.DICT[$monster.id+"Extension"], JSON.stringify(extObj));
        obj.ext = extObj;

        return ItemVO.fill(new ItemVO(), obj)

    }


    public static function get createGoldItemVO() : ItemVO
    {
        var obj : Object = {};
        obj.id = 0;
        obj.name = "goldItemVO";
        obj.picture = "";
        obj.type = "gold";
        obj.price = 0;
        obj.slot = 0;
        obj.setname = "";
        //obj.localekey = "gold";
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
//            DICT[object.id] = object;
            DICT[object.name] = object;



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
            ITEMS_BY_TYPE[object.type].push(object);

            if (!ITEMS_BY_SLOT["slot"+object.slot])
            {
                ITEMS_BY_SLOT["slot"+object.slot] = new Vector.<ItemVO>();
            }
            ITEMS_BY_SLOT["slot"+object.slot].push(object);

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

    public function minval() : Number {
        return dropparam[0];
    }
    public function maxval() : Number {
        return dropparam[1];
    }

}
}
