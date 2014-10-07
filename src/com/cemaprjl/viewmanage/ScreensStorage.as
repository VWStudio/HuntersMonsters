/**
 * Created by mor on 11.12.13.
 */
package com.cemaprjl.viewmanage {
import com.agnither.hunters.view.ui.popups.InventoryPopup;
import com.agnither.hunters.view.ui.popups.SelectMonsterPopup;
import com.agnither.hunters.view.ui.popups.hunt.HuntStepsPopup;
import com.agnither.hunters.view.ui.popups.win.WinPopup;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.hunters.view.ui.screens.battle.monster.TrapPopup;
import com.agnither.hunters.view.ui.screens.hud.HudScreen;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.hunters.view.ui.popups.hunt.HuntPopup;

public class ScreensStorage {
    public static function init() : void {
        /*
         SCREENS
         */
        ViewFactory.add(HudScreen.NAME, HudScreen);
        ViewFactory.add(MapScreen.NAME, MapScreen);
        ViewFactory.add(BattleScreen.NAME, BattleScreen);
        /**
         * WINDOWS AND POPUPS
         */
        ViewFactory.add(InventoryPopup.NAME, InventoryPopup);
        ViewFactory.add(SelectMonsterPopup.NAME, SelectMonsterPopup);
        ViewFactory.add(HuntPopup.NAME, HuntPopup);
        ViewFactory.add(WinPopup.NAME, WinPopup);
        ViewFactory.add(TrapPopup.NAME, TrapPopup);
        ViewFactory.add(HuntStepsPopup.NAME, HuntStepsPopup);


    }

}
}
