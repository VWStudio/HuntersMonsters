/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.model.modules.players {
import com.agnither.hunters.model.modules.players.PersonageVO;

import flash.utils.Dictionary;

public class PlayerVO extends PersonageVO {

    public static const LIST: Vector.<PlayerVO> = new <PlayerVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: PlayerVO = fill(new PlayerVO(), row);
//            object.name = row.name;
//            object.level = row.level;
//            object.exp = row.exp;
//            object.gold = row.gold;
//            object.hp = row.hp;
//            object.damage = row.damage;
//            object.defence = row.defence;
//            object.league = row.league;
//            object.rating = row.rating;

            LIST.push(object);
            DICT[object.level] = object;
        }
    }

    public static function fill($target : PlayerVO, $source : Object) : PlayerVO {

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
    public function clone() : PlayerVO {
        return fill(new PlayerVO(), this);
    }

}
}
