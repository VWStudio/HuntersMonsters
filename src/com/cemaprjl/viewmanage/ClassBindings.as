/**
 * Created by mor on 22.09.2014.
 */
package com.cemaprjl.viewmanage
{
import com.agnither.hunters.view.ui.common.AreaHud;
import com.agnither.hunters.view.ui.common.BattleManaView;
import com.agnither.hunters.view.ui.common.GoldView;
import com.agnither.hunters.view.ui.common.ItemManaView;
import com.agnither.hunters.view.ui.common.MonsterArea;
import com.agnither.hunters.view.ui.common.MonsterInfo;
import com.agnither.hunters.view.ui.common.TabView;
import com.agnither.hunters.view.ui.popups.traps.TrapItem;
import com.agnither.hunters.view.ui.screens.battle.player.DropListView;
import com.agnither.hunters.view.ui.screens.battle.player.DropSlotView;
import com.agnither.hunters.view.ui.screens.battle.player.ManaListView;
import com.agnither.hunters.view.ui.screens.battle.player.PersonageView;
import com.agnither.hunters.view.ui.screens.map.ChestPoint;
import com.agnither.hunters.view.ui.screens.map.MonsterPoint;
import com.agnither.hunters.view.ui.screens.map.PlayerPoint;
import com.agnither.hunters.view.ui.screens.map.StarsBar;
import com.agnither.hunters.view.ui.screens.map.TrapPoint;

import flash.net.registerClassAlias;

public class ClassBindings
{

    public static function init() : void
    {
        registerClassAlias("map.Point", MonsterPoint);
        registerClassAlias("map.Player", PlayerPoint);
        registerClassAlias("map.PointStars", StarsBar);
        registerClassAlias("map.MonsterArea", MonsterArea);
        registerClassAlias("map.Trap", TrapPoint);
        registerClassAlias("map.Chest", ChestPoint);
        registerClassAlias("map.AreaHud", AreaHud);

        registerClassAlias("common.TabView", TabView);
        registerClassAlias("common.ItemManaView", ItemManaView);
        registerClassAlias("common.BattleManaView", BattleManaView);
        registerClassAlias("common.GoldIcon", GoldView);
        registerClassAlias("common.TrapItem", TrapItem);

        registerClassAlias("battle.PersonageView", PersonageView);
        registerClassAlias("battle.ManaListView", ManaListView);
        registerClassAlias("battle.DropListView", DropListView);
        registerClassAlias("battle.DropSlotView", DropSlotView);

        registerClassAlias("battle.MonsterInfo", MonsterInfo);
    }

}
}
