/**
 * Created by agnither on 25.08.14.
 */
package com.agnither.hunters.view.ui.popups {
import com.agnither.hunters.App;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.inventory.PetsInventory;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.common.TabView;
import com.agnither.hunters.view.ui.popups.monsters.PetsView;
import com.agnither.ui.Popup;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;

public class SelectMonsterPopup extends Popup {

    public static const NAME: String = "SelectMonsterPopup";

    private var _player: Player;

    private var _tab1: TabView;
    private var _tab2: TabView;

    private var _monsters: PetsView;
    private var _monstersContainer: Sprite;

    private var _closeBtn: Button;

    public function SelectMonsterPopup() {
        _player = App.instance.player;
    }

    override protected function initialize():void {
        createFromConfig(_refs.guiConfig.monsters_popup);

        _tab1 = _links.tab1;
        _tab1.label = "tamed";
        _tab1.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _tab2 = _links.tab2;
        _tab2.label = "untamed";
        _tab2.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        PetsView.itemX = _links.monster2.x - _links.monster1.x;
        PetsView.itemY = _links.monster3.y - _links.monster1.y;

        _links.monster1.removeFromParent(true);
        _links.monster2.removeFromParent(true);
        _links.monster3.removeFromParent(true);

        _monsters = new PetsView();
        _monstersContainer = _links.monsters;
        _monstersContainer.addChild(_monsters);

        _closeBtn = _links.close_btn;
        _closeBtn.addEventListener(Event.TRIGGERED, handleClose);
    }


    override public function update() : void {
        _monsters.showType(PetsInventory.TAMED);
    }

    private function handleSelectTab(e: Event):void {
        trace("handleSelectTab");
        switch (e.currentTarget) {
            case _tab1:
                _monsters.showType(PetsInventory.TAMED);
                break;
            case _tab2:
                _monsters.showType(PetsInventory.UNTAMED);
                break;
        }
    }

    private function handleClose(e: Event):void {
        coreDispatch(UI.HIDE_POPUP, SelectMonsterPopup.NAME);
    }
}
}
