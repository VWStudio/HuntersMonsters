/**
 * Created by agnither on 11.06.14.
 */
package com.agnither.hunters.data {
import com.agnither.hunters.data.outer.DropVO;
import com.agnither.hunters.data.outer.ExtensionVO;
import com.agnither.hunters.data.outer.ItemSlotVO;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.data.outer.LeagueVO;
import com.agnither.hunters.data.outer.LevelVO;
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.data.outer.PlayerItemVO;
import com.agnither.hunters.data.outer.SkillVO;
import com.agnither.hunters.data.outer.TrapVO;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.locale.LocaleVO;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.modules.monsters.PriceItemVO;
import com.agnither.hunters.model.modules.players.PlayerPetVO;
import com.agnither.hunters.model.modules.players.SettingsVO;

import flash.utils.Dictionary;

import starling.utils.AssetManager;

public class Config {

    private static var config : Dictionary = new Dictionary();
    public static var list : Array = [];

    public static function init() : void {
        addConfig("monster", MonsterVO);
        addConfig("levels", LevelVO);
        addConfig("settings", SettingsVO);
        addConfig("league", LeagueVO);
        addConfig("item", ItemVO);
        addConfig("item_type", ItemTypeVO);
        addConfig("item_slot", ItemSlotVO);
        addConfig("extension", ExtensionVO);
        addConfig("drop", DropVO);
//        addConfig("gold_drop", GoldDropVO);
        addConfig("magic_type", MagicTypeVO);
        addConfig("player_items", PlayerItemVO);
        addConfig("player_pets", PlayerPetVO);
        addConfig("locale", LocaleVO);
        addConfig("monster_area", MonsterAreaVO);
        addConfig("trap", TrapVO);
        addConfig("skills", SkillVO);
        addConfig("pricelist", PriceItemVO);
    }

    public static function addConfig(id : String, ClassRef : Class) : void {
        config[id] = ClassRef;
        list.push(id);
    }

    public static function parse(assets : AssetManager) : void {
        for (var i : int = 0; i < list.length; i++)
        {
            var filename : String = list[i];
            config[filename].parseData(assets.getObject(filename));
        }
    }
}
}
