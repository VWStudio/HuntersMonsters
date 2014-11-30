/**
 * Created by mor on 14.10.2014.
 */
package com.agnither.hunters.model.modules.monsters {
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;

import flash.utils.Dictionary;

public class MonsterAreaVO {

    public static const DICT: Dictionary = new Dictionary();
    public static const LIST: Vector.<MonsterAreaVO> = new <MonsterAreaVO>[];
    public static const NAMES_LIST: Vector.<String> = new <String>[];

    public var id: String = "";
    public var hud: String = "";
    public var unlock: Array = [];
    public var area: String = "";

    public var areamax : int = 0;
    public var areamin : int = 0;
    public var lifemin: int = 0;
    public var lifemax: int = 0;
    public var respawn: int = 0;
    public var house: String = "";
    public var icon: String = "";
    public var chestlife: int = 0;
    public var chestrespawn: int = 0;
    public var chestdropset: int = 0;
    public var expearned: int = 0;
    public var tameprice: Array = [];

    public var isHouse: Boolean = false;


    /*
     "id": "clouds_00",
     "hud": "hud00",
     "unlock": "clouds_01,clouds_02",
     "area": "blue_bull",
     "areaamount": "1,2",
     "lifetime": "60,300",
     "respawn": 180,
     "chesttimes": "300,300",
     "chestdropset": "3",
     "expearned": 50,
     "tameprice": "1,11,21"
     */


    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {

            var source: Object = data[i];
            source.unlock = source.unlock ? source.unlock.split(",") : [];

            if(source.tameprice)
            {
                source.tameprice = source.tameprice.toString().split(",");
            } else {
                source.isHouse = true;
            }

            var object: MonsterAreaVO = fill(new MonsterAreaVO(), source);
            DICT[object.id] = object;
            DICT[object.area] = object;
            LIST.push(object);
        }

        for (var j : int = 0; j < LIST.length; j++)
        {
            if(!LIST[j].isHouse) {
                NAMES_LIST.push(LIST[j].area);
            }
        }

    }

    public static function fill($target : MonsterAreaVO, $source : Object) : MonsterAreaVO {

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

    public function clone() : MonsterAreaVO {
        return fill(new MonsterAreaVO(), this);
    }
}
}
