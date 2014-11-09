/**
 * Created by mor on 11.12.13.
 */
package com.cemaprjl.viewmanage {
import com.agnither.hunters.view.ui.popups.inventory.InventoryPopup;
import com.agnither.hunters.view.ui.popups.house.HousePopup;
import com.agnither.hunters.view.ui.popups.hunt.HuntPopup;
import com.agnither.hunters.view.ui.popups.hunt.HuntStepsPopup;
import com.agnither.hunters.view.ui.popups.monsters.SelectMonsterPopup;
import com.agnither.hunters.view.ui.popups.monsters.TameMonsterPopup;
import com.agnither.hunters.view.ui.popups.shop.ShopPopup;
import com.agnither.hunters.view.ui.popups.skills.SkillsPopup;
import com.agnither.hunters.view.ui.popups.trainer.TrainerPopup;
import com.agnither.hunters.view.ui.popups.traps.TrapSetPopup;
import com.agnither.hunters.view.ui.popups.win.WinPopup;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.hunters.view.ui.screens.camp.CampScreen;
import com.agnither.hunters.view.ui.screens.hud.HudScreen;
import com.agnither.hunters.view.ui.screens.map.MapScreen;

public class ScreensStorage {
    public static function init() : void {
        /*
         SCREENS
         */
        ViewFactory.add(HudScreen.NAME, HudScreen);
        ViewFactory.add(MapScreen.NAME, MapScreen);
        ViewFactory.add(CampScreen.NAME, CampScreen);
        ViewFactory.add(BattleScreen.NAME, BattleScreen);
        /**
         * WINDOWS AND POPUPS
         */
        ViewFactory.add(InventoryPopup.NAME, InventoryPopup);
        ViewFactory.add(SelectMonsterPopup.NAME, SelectMonsterPopup);
        ViewFactory.add(TameMonsterPopup.NAME, TameMonsterPopup);
        ViewFactory.add(HuntPopup.NAME, HuntPopup);
        ViewFactory.add(WinPopup.NAME, WinPopup);
        ViewFactory.add(TrapSetPopup.NAME, TrapSetPopup);
        ViewFactory.add(HuntStepsPopup.NAME, HuntStepsPopup);
        ViewFactory.add(HousePopup.NAME, HousePopup);
        ViewFactory.add(SkillsPopup.NAME, SkillsPopup);
        ViewFactory.add(TrainerPopup.NAME, TrainerPopup);
        ViewFactory.add(ShopPopup.NAME, ShopPopup);


    }

}
}
