/**
 * Created by agnither on 11.06.14.
 */
package com.agnither.hunters.data {
import com.agnither.hunters.data.outer.ChipVO;
import com.agnither.hunters.data.outer.DropVO;
import com.agnither.hunters.data.outer.ExtensionVO;
import com.agnither.hunters.data.outer.GoldDropVO;
import com.agnither.hunters.data.outer.ItemSlotVO;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.data.outer.ItemVO;
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.data.outer.LeagueVO;
import com.agnither.hunters.data.outer.LevelVO;
import com.agnither.hunters.data.outer.MonsterVO;
import com.agnither.hunters.data.outer.PlayerVO;

import flash.utils.Dictionary;

import starling.utils.AssetManager;

public class Config {

    private static var config: Dictionary = new Dictionary();
    public static var list: Array = [];

    public static function init():void {
        addConfig("levels", LevelVO);
        addConfig("player", PlayerVO);
        addConfig("league", LeagueVO);
        addConfig("monster", MonsterVO);
        addConfig("item", ItemVO);
        addConfig("item_type", ItemTypeVO);
        addConfig("item_slot", ItemSlotVO);
        addConfig("extension", ExtensionVO);
        addConfig("damage_type", DamageTypeVO);
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
