/**
 * Created by agnither on 11.06.14.
 */
package com.agnither.hunters.data {
import com.agnither.hunters.data.outer.ArmorVO;
import com.agnither.hunters.data.outer.ChipVO;
import com.agnither.hunters.data.outer.DropVO;
import com.agnither.hunters.data.outer.GoldDropVO;
import com.agnither.hunters.data.outer.MagicItemVO;
import com.agnither.hunters.data.outer.MagicVO;
import com.agnither.hunters.data.outer.MonsterVO;
import com.agnither.hunters.data.outer.PlayerVO;
import com.agnither.hunters.data.outer.SpellVO;
import com.agnither.hunters.data.outer.WeaponVO;

import flash.utils.Dictionary;

import starling.utils.AssetManager;

public class Config {

    private static var config: Dictionary = new Dictionary();
    public static var list: Array = [];

    public static function init():void {
        addConfig("player", PlayerVO);
        addConfig("monster", MonsterVO);
        addConfig("weapon", WeaponVO);
        addConfig("armor", ArmorVO);
        addConfig("spell", SpellVO);
        addConfig("item", MagicItemVO);
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
