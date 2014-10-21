/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class TrapVO {

    public static const LIST: Vector.<TrapVO> = new <TrapVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public var level: int = 0;
    public var area : String = "";
    public var leveleffect : Array = [];
    public var timechance : Array = [];
    public var areaeffect : Number = 0;

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            row.leveleffect = row.leveleffect.toString().split(",");
            row.timechance = row.timechance.toString().split(",");

            var object: TrapVO = fill(new TrapVO(), row);

            LIST.push(object);
            DICT[object.level] = object;
        }
    }

    private static function parseExtension(string: String):Object {
        if (!string) {
            return null;
        }

        var object: Object = {};
        var array: Array = string.split(",");
        for (var i:int = 0; i < array.length; i++) {
            while (array[i].indexOf("[") >= 0 && array[i].indexOf("]") < 0) {
                array[i] += "," + array[i+1];
                array.splice(i+1, 1);
            }

            var row: Array = array[i].split(":");
            var id: String = row[0];
            var value: String = row[1];
            object[id] = value;
        }
        return object;
    }

    public static function fill($target : TrapVO, $source : Object) : TrapVO {

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
    public function clone() : TrapVO {
        return fill(new TrapVO(), this);
    }





}
}
