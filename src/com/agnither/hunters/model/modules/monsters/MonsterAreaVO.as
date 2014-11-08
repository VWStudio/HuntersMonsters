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
    public var order: int = 0;
    public var area: String = "";
    public var area_max : int = 0;
    public var area_min : int = 0;
    public var lifetime_max: int = 0;
    public var lifetime_min: int = 0;
    public var respawn: int = 0;
    public var house: String = "";
    public var chestLife: int = 0;
    public var chestRespawn: int = 0;
    public var chestdropset: int = 0;
    public var expearned: int = 0;
    public var tameprice: Array = [];

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {

            var source: Object = data[i];
            var arr : Array = source.areaamount.toString().split(",");
            source.area_min = arr[0];
            source.area_max = arr[1];
            delete source.areaamount;

            arr = source.lifetime.toString().split(",");
            source.lifetime_min = arr[0];
            source.lifetime_max = arr[1];
            delete source.lifetime;

            arr = source.chesttimes.toString().split(",");
            source.chestLife = arr[0];
            source.chestRespawn = arr[1];
            delete source.chesttimes;

            source.tameprice = source.tameprice ? source.tameprice.toString().split(",") : [];

            var object: MonsterAreaVO = fill(new MonsterAreaVO(), source);
            DICT[object.id] = object;
            LIST.push(object);
        }
        LIST.sort(sortByOrder);
        for (var j : int = 0; j < LIST.length; j++)
        {
            NAMES_LIST.push(LIST[j].id);
        }

    }
    private static function sortByOrder($a : MonsterAreaVO, $b : MonsterAreaVO) : Number {
        if($a.order < $b.order) return -1;
        if($a.order > $b.order) return 1;
        return 0;
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
