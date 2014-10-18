/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.model.modules.monsters {
import com.agnither.hunters.model.modules.players.PersonageVO;

import flash.utils.Dictionary;

public dynamic class MonsterVO extends PersonageVO{

    public static const LIST: Vector.<MonsterVO> = new <MonsterVO>[];
    public static const DICT_BY_TYPE : Dictionary = new Dictionary();
    public static const DICT: Dictionary = new Dictionary();

    public var id: String;
//    public var level: int;
    public var order: Number = 0;
//    public var area : String;
//    public var picture: String;
    public var difficulty: int;
    public var drop: int;

    public var items: Array = [];
    public var stars: Array = [];



    /*
     "level": 1,
     "monster": "blue_bull",
     "hp": 100,
     "damage": 5,
     "defence": 5,

     "magic": 6,
     "difficulty": 10,
     "drop": 1,
     "items": "4,6,13,14",
     "stars": "7,12,20",
     "picture": "monster_1.png"
     */
    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {

            var source: Object = data[i];

            source.items = source.items ? source.items.toString().split(",") : [];
            source.stars = source.stars ? source.stars.toString().split(",") : [];

            var object: MonsterVO = fill(new MonsterVO(), source);

            var monsterID : String = source["monster"];
            var monsterLevel : String = source["level"];
            if(!DICT[object.id]) {
                DICT[object.id] = new Dictionary();
                DICT_BY_TYPE[object.id] = new Vector.<MonsterVO>();
            }

            DICT[object.id][object.level] = object;
            LIST.push(object);
            DICT_BY_TYPE[object.id].push(object);

        }
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
