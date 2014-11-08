/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class SkillVO {

    public static const LIST: Vector.<SkillVO> = new <SkillVO>[];
    public static const DICT: Dictionary = new Dictionary();
    public static const LEVELS: Object = {};

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: SkillVO = fill(new SkillVO(), row);
            LIST.push(object);
            DICT[object.id] = object;
            if(!LEVELS[object.unlocklevel.toString()]) {
                LEVELS[object.unlocklevel.toString()] = [];
            }
            LEVELS[object.unlocklevel.toString()].push(object);
        }



    }
    public static function fill($target : SkillVO, $source : Object) : SkillVO {

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
    public function clone() : SkillVO {
        return fill(new SkillVO(), this);
    }
    public var id: int;
    public var name: String;
    public var description: String;
    public var unlocklevel: int;
    public var points: int;
    public var changevalue: int;

}
}