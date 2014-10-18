/**
 * Created by agnither on 25.08.14.
 */
package com.agnither.hunters.view.ui.popups {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.TrapVO;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.inventory.PetsInventory;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.common.TabView;
import com.agnither.hunters.view.ui.popups.monsters.PetsView;
import com.agnither.hunters.view.ui.popups.traps.TrapView;
import com.agnither.ui.Popup;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;

public class SelectMonsterPopup extends Popup {

    public static const NAME: String = "SelectMonsterPopup";

    private var _tab1: TabView;
    private var _tab2: TabView;
    private var _tab3 : TabView;

    private var _monsters: PetsView;
    private var _monstersContainer: Sprite;

    private var _closeBtn: Button;
    private var _trapsContainer : Sprite;

    public function SelectMonsterPopup() {
    }

    override protected function initialize():void {
        createFromConfig(_refs.guiConfig.monsters_popup);

        _tab1 = _links.tab1;
        _tab1.label = Locale.getString("tamed_tab");
        _tab1.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _tab2 = _links.tab2;
        _tab2.label = Locale.getString("untamed_tab");
        _tab2.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _tab3 = _links.tab3;
        _tab3.label = Locale.getString("traps_tab");
        _tab3.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        PetsView.itemX = _links.monster2.x - _links.monster1.x;
        PetsView.itemY = _links.monster3.y - _links.monster1.y;

        _links.monster1.removeFromParent(true);
        _links.monster2.removeFromParent(true);
        _links.monster3.removeFromParent(true);

        _monsters = new PetsView();
        _monstersContainer = _links.monsters;
        _monstersContainer.addChild(_monsters);

        _trapsContainer = new Sprite();
        addChild(_trapsContainer);

        _trapsContainer.x = _monstersContainer.x;
        _trapsContainer.y = _monstersContainer.y;


        _closeBtn = _links.close_btn;
        _closeBtn.addEventListener(Event.TRIGGERED, handleClose);
    }


    override public function update() : void {
        _tab1.dispatchEventWith(TabView.TAB_CLICK);
//        _monsters.showType(PetsInventory.TAMED);
    }

    private function handleSelectTab(e: Event):void {
        _monstersContainer.visible = true;
        _trapsContainer.visible = false;
        switch (e.currentTarget) {
            case _tab1:
                _monsters.showType(PetsInventory.TAMED);
                break;
            case _tab2:
                _monsters.showType(PetsInventory.UNTAMED);
                break;
            case _tab3:
                _monstersContainer.visible = false;
                _trapsContainer.visible = true;
                updateTraps();

                break;
        }

        _tab1.setIsSelected(e.currentTarget as TabView);
        _tab2.setIsSelected(e.currentTarget as TabView);
        _tab3.setIsSelected(e.currentTarget as TabView);

    }

    private function updateTraps() : void {

        _trapsContainer.removeChildren();
        for (var i : int = 0; i < TrapVO.LIST.length; i++)
        {
            var trap : TrapVO = TrapVO.LIST[i].clone();
            var trapView : TrapView = new TrapView(trap);
            trapView.x = _trapsContainer.numChildren % 4 * 170;
            trapView.y = int(_trapsContainer.numChildren / 4) * 170;
            _trapsContainer.addChild(trapView);


//            _trapsContainer

            //trapItem



        }


    }

    private function handleClose(e: Event):void {
        coreDispatch(UI.HIDE_POPUP, SelectMonsterPopup.NAME);
    }
}
}
