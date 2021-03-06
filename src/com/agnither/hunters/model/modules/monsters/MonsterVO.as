/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.model.modules.monsters {
import com.agnither.hunters.model.modules.players.PersonageVO;

import flash.utils.Dictionary;

public dynamic class MonsterVO extends PersonageVO {

    public static const LIST: Vector.<MonsterVO> = new <MonsterVO>[];
    public static const DICT_BY_TYPE : Dictionary = new Dictionary();
    public static const DICT: Dictionary = new Dictionary();

    public var id: String;
    public var difficulty: int;
    public var drop: int;
    public var expearned: int;
    public var speed: uint = 75;
    public var damagetype: String;
    public var itemimage: String;
    public var extension: Object;
    public var reward: Number = 0;
    public var order: Number = 0;
    public var difficultyfactor: Number = 0;

    public var items: Array = [];
    public var stars: Array = [];

    public static var maxOrder : int = 0;



    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {

            var source: Object = data[i];

            source.items = source.items ? source.items.toString().split(",") : [];
            source.stars = source.stars ? source.stars.toString().split(",") : [];
            source.extension = parseExtension(source.extension);
            var object: MonsterVO = fill(new MonsterVO(), source);

            var monsterID : String = source["monster"];
            var monsterLevel : String = source["level"];
            if(!DICT[object.id]) {
                DICT[object.id] = new Dictionary();
                DICT_BY_TYPE[object.id] = new Vector.<MonsterVO>();
            }

            DICT[object.id][object.level] = object;
            DICT["order"+object.order] = object;
            maxOrder = Math.max(object.order, maxOrder);
            //trace(object.id, object.order, maxOrder, DICT["order"+object.order], object.reward, JSON.stringify(object));
            LIST.push(object);
            DICT_BY_TYPE[object.id].push(object);
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



    public static function fill($target : MonsterVO, $source : Object) : MonsterVO {

        var source : Object = $source;
        if(source.constructor != Object){
            source = JSON.parse(JSON.stringify(source));
        }
        for (var key : String in source)
        {
            if($target.hasOwnProperty(key)) {
                $target[key] = source[key];
            }
        }
        return $target;
    }
    public function clone() : MonsterVO {
        return fill(new MonsterVO(), this);
    }
}
}
