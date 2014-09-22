/**
 * Created by mor on 20.09.2014.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class LevelVO {

    public static const LIST: Vector.<LevelVO> = new <LevelVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public var id: int;
    public var exp: String;

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: LevelVO = new LevelVO();
            object.id = row.id;
            object.exp = row.exptolevel;

            LIST.push(object);
            DICT[object.id] = object;
        }
    }

}
}
