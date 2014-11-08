/**
 * Created by agnither on 25.08.14.
 */
package com.agnither.hunters.view.ui.popups.monsters {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.TrapVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.inventory.PetsInventory;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.common.TabView;
import com.agnither.hunters.view.ui.popups.monsters.CatchedPetsView;
import com.agnither.hunters.view.ui.popups.traps.TrapItem;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.ui.Popup;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;

public class SelectMonsterPopup extends Popup {

    public static const NAME : String = "com.agnither.hunters.view.ui.popups.monsters.SelectMonsterPopup";

    private var _tab1: TabView;
    private var _tab2: TabView;
    private var _tab3 : TabView;

    private var _closeBtn: Button;

    private var _monsters: CatchedPetsView;
    private var _monstersContainer: Sprite;

    private var _tamedmonsters : TamedPetsView;
    private var _traps : TrapsListView;

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

        _monstersContainer = new Sprite();
        addChild(_monstersContainer);
        _monstersContainer.x = _links.monsters.x;
        _monstersContainer.y = _links.monsters.y;

        removeChild(_links.monsters);

        delete _links.monsters;

        _monsters = new CatchedPetsView();
        _monstersContainer.addChild(_monsters);

        _tamedmonsters = new TamedPetsView();
        _monstersContainer.addChild(_tamedmonsters);

        _traps = new TrapsListView();
        _monstersContainer.addChild(_traps);

        addCloseButton(_links.close_btn);
    }


    override public function update() : void {
        _tab1.dispatchEventWith(TabView.TAB_CLICK);
    }

    private function handleSelectTab(e: Event):void {

        if(Model.instance.state == BattleScreen.NAME && (e.currentTarget == _tab2 || e.currentTarget == _tab3)) {

            return;

        }

        _traps.visible = false;
        _monsters.visible = false;
        _tamedmonsters.visible = false;
        switch (e.currentTarget) {
            case _tab1:
                _tamedmonsters.visible = true;
                _tamedmonsters.update();
                break;
            case _tab2:
                _monsters.visible = true;
                _monsters.update();
                break;
            case _tab3:
                _traps.visible = true;
                break;
        }

        _tab1.setIsSelected(e.currentTarget as TabView);
        _tab2.setIsSelected(e.currentTarget as TabView);
        _tab3.setIsSelected(e.currentTarget as TabView);

    }
}
}

