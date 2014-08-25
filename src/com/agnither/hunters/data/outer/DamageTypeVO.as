/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class DamageTypeVO {

    public static var weapon: DamageTypeVO;
    public static var nature: DamageTypeVO;
    public static var water: DamageTypeVO;
    public static var fire: DamageTypeVO;
    public static var add1: DamageTypeVO;
    public static var add2: DamageTypeVO;
    public static var add3: DamageTypeVO;

    public static const LIST: Vector.<DamageTypeVO> = new <DamageTypeVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: DamageTypeVO = new DamageTypeVO();
            object.id = row.id;
            object.name = row.name;
            object.picture = row.picture;

            LIST.push(object);
            DICT[object.id] = object;
            DICT[object.name] = object;
            DamageTypeVO[object.name] = object;
        }
    }

    public var id: int;
    public var name: String;
    public var picture: String;
}
}