/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.model.modules.monsters {
import com.agnither.hunters.model.modules.players.PersonageVO;

import flash.utils.Dictionary;

public dynamic class MonsterVO extends PersonageVO {

    public static const LIST: Vector.<MonsterVO> = new <MonsterVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public var id: String;
    public var picture: String;
    public var area : String;
    public var unlock : String;
    public var magic: int;
    public var difficulty: int;
    public var drop: int;
    public var weapon: int;
    public var armor: Array;
    public var items: Array;
    public var spells: Array;
    public var stars: Array;


    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {

            var source: Object = data[i];
            source.armor = source.armor ? source.armor.split(",") : [];
            source.items = source.items ? source.items.split(",") : [];
            source.spells = source.spells ? source.spells.split(",") : [];
            source.stars = source.stars.split(",");

            var object: MonsterVO = fill(new MonsterVO(), source);

            LIST.push(object);
            DICT[object.id] = object;
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
