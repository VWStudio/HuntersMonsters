/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import com.agnither.hunters.data.inner.PersonageVO;

import flash.utils.Dictionary;

public class PlayerVO extends PersonageVO {

    public static const LIST: Vector.<PlayerVO> = new <PlayerVO>[];
    public static const DICT: Dictionary = new Dictionary();



    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: PlayerVO = new PlayerVO();
            object.name = row.name;
            object.level = row.level;
            object.exp = row.exp;
            object.gold = row.gold;
            object.hp = row.hp;
            object.damage = row.damage;
            object.defence = row.defence;
            object.league = row.league;
            object.rating = row.rating;

            LIST.push(object);
            DICT[object.level] = object;
        }
    }
}
}
