/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.popups.win
{
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.drop.DropList;
import com.agnither.hunters.model.player.drop.DropSlot;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.common.MonsterInfo;
import com.agnither.hunters.view.ui.screens.battle.player.DropSlotView;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.hunters.view.ui.screens.map.*;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Popup;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.core.coreRemoveListener;
import com.cemaprjl.viewmanage.ShowPopupCmd;
import com.cemaprjl.viewmanage.ShowScreenCmd;

import flash.geom.Rectangle;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class AlivePopup extends Popup
{

    public static const NAME : String = "com.agnither.hunters.view.ui.popups.win.AlivePopup";
    private var c10_btn : ButtonContainer;
    private var c50_btn : ButtonContainer;
    private var loose_btn : ButtonContainer;

//    public static const SELECT_MONSTER: String = "select_monster_BattleScreen";


    public function AlivePopup()
    {

        super();
    }


    override public function get isDarkenessCloseAllowed() : Boolean
    {
        return false;
    }

    override protected function initialize() : void
    {

        createFromConfig(_refs.guiConfig.alivePopup);

//        _back = _links["bitmap_common_back"];
//        _back.touchable = true;

        c10_btn = _links["c10_btn"];
        c10_btn.addEventListener(Event.TRIGGERED, onC10);
        c50_btn = _links["c50_btn"];
        c50_btn.addEventListener(Event.TRIGGERED, onC50);
        loose_btn = _links["loose_btn"];
        loose_btn.addEventListener(Event.TRIGGERED, onLoose);



    }

    private function onLoose(event : Event) : void
    {
        coreExecute(ShowScreenCmd, MapScreen.NAME);
        coreDispatch(UI.HIDE_POPUP, NAME);
//        coreExecute(ShowPopupCmd, WinPopup.NAME, {isWin: false});
    }

    private function onC50(event : Event) : void
    {
        if(Model.instance.progress.crystalls < 5)
        {
            return;
        }
        Model.instance.progress.crystalls -= 5;
        Model.instance.progress.saveProgress();
        Model.instance.player.hero.heal(Model.instance.player.hero.maxHP * 0.5);
        coreDispatch(Match3Game.CONTINUE);
        coreDispatch(UI.HIDE_POPUP, NAME);
    }

    private function onC10(event : Event) : void
    {

        if(Model.instance.progress.crystalls < 1)
        {
            return;
        }
        Model.instance.progress.crystalls -= 1;
        Model.instance.progress.saveProgress();

        Model.instance.player.hero.heal(Model.instance.player.hero.maxHP * 0.1);
        coreDispatch(Match3Game.CONTINUE);
        coreDispatch(UI.HIDE_POPUP, NAME);

    }

    override public function update() : void
    {

    }


}
}
