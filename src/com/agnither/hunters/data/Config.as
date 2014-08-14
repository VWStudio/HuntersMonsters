/**
 * Created by agnither on 11.06.14.
 */
package com.agnither.hunters.data {
import flash.utils.Dictionary;

import starling.utils.AssetManager;

public class Config {

    private static var config: Dictionary = new Dictionary();
    public static var list: Array = [];

    public static function init():void {
        addConfig("monster", MonsterVO);
        addConfig("weapon", WeaponVO);
        addConfig("armor", ArmorVO);
        addConfig("spell", SpellVO);
        addConfig("item", ItemVO);
        addConfig("magic", MagicVO);
        addConfig("drop", DropVO);
        addConfig("gold_drop", GoldDropVO);
        addConfig("chip", ChipVO);
    }

    public static function addConfig(id: String, ClassRef: Class):void {
        config[id] = ClassRef;
        list.push(id);
    }

    public static function parse(assets: AssetManager):void {
        for (var i:int = 0; i < list.length; i++) {
            var filename: String = list[i];
            config[filename].parseData(assets.getObject(filename));
        }
    }
}
}
