/**
 * Created by mor on 20.09.2014.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class LeagueVO {

    public static const LIST: Vector.<LeagueVO> = new <LeagueVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public var id: int;
    public var name: String;

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: LeagueVO = new LeagueVO();
            object.id = row.id;
            object.name = row.name;

            LIST.push(object);
            DICT[object.id] = object;
        }
    }
}
}
