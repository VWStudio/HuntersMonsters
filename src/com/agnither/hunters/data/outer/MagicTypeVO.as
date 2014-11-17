/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import flash.utils.Dictionary;

public class MagicTypeVO {


    public static var weapon: MagicTypeVO;
    public static var nature: MagicTypeVO;
    public static var water: MagicTypeVO;
    public static var fire: MagicTypeVO;
    public static var add1: MagicTypeVO;
    public static var add2: MagicTypeVO;
    public static var add3: MagicTypeVO;

    public static const CHEST: String = "chest";
    public static const WEAPON: String = "weapon";
    public static const NATURE: String = "nature";
    public static const WATER: String = "water";
    public static const FIRE: String = "fire";
    public static const ADD1: String = "add1";
    public static const ADD2: String = "add2";
    public static const ADD3: String = "add3";

    public static const LIST: Vector.<MagicTypeVO> = new <MagicTypeVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: MagicTypeVO = new MagicTypeVO();
            object.id = row.id;
            object.name = row.name;
            object.picturechip = row.picturechip;
            object.picturedamage = row.picturedamage;
            object.itemmarker = row.itemmarker;
            object.manaicon = row.manaicon;

            LIST.push(object);
            DICT[object.id] = object;
            DICT[object.name] = object;
            MagicTypeVO[object.name] = object;
        }
    }

    /*
     "id": 5,
     "name": "fire",
     "picturechip": "chip_5.png",
     "picturedamage": "m_5.png"
     */

    public var id: int;
    public var name: String;
    public var picturechip: String;
    public var picturedamage: String;
    public var itemmarker: String;
    public var manaicon: String;
}
}