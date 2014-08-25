/**
 * Created by agnither on 25.08.14.
 */
package com.agnither.hunters.view.ui.popups {
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.inventory.PetsInventory;
import com.agnither.hunters.view.ui.common.TabView;
import com.agnither.hunters.view.ui.popups.monsters.PetsView;
import com.agnither.ui.Popup;
import com.agnither.utils.CommonRefs;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;

public class SelectMonsterPopup extends Popup {

    public static const ID: String = "SelectMonsterPopup";

    private var _player: Player;

    private var _tab1: TabView;
    private var _tab2: TabView;

    private var _monsters: PetsView;
    private var _monstersContainer: Sprite;

    private var _closeBtn: Button;

    public function SelectMonsterPopup(refs:CommonRefs, player: Player) {
        _player = player;
        super(refs);
    }

    override protected function initialize():void {
        createFromConfig(_refs.guiConfig.monsters_popup);

        _links.tab1.visible = false;
        _tab1 = new TabView(_refs, "tamed");
        _tab1.addEventListener(TabView.TAB_CLICK, handleSelectTab);
        _tab1.x = _links.tab1.x;
        _tab1.y = _links.tab1.y;
        addChild(_tab1);

        _links.tab2.visible = false;
        _tab2 = new TabView(_refs, "untamed");
        _tab2.addEventListener(TabView.TAB_CLICK, handleSelectTab);
        _tab2.x = _links.tab2.x;
        _tab2.y = _links.tab2.y;
        addChild(_tab2);

        PetsView.itemX = _links.monster2.x - _links.monster1.x;
        PetsView.itemY = _links.monster3.y - _links.monster1.y;

        _links.monster1.removeFromParent(true);
        _links.monster2.removeFromParent(true);
        _links.monster3.removeFromParent(true);

        _monsters = new PetsView(_refs, _player.pets);
        _monstersContainer = _links.monsters;
        _monstersContainer.addChild(_monsters);

        _closeBtn = _links.close_btn;
        _closeBtn.addEventListener(Event.TRIGGERED, handleClose);
    }

    override public function open():void {
        super.open();

        _monsters.showType(PetsInventory.TAMED);
    }

    private function handleSelectTab(e: Event):void {
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
        dispatchEventWith(CLOSE);
    }
}
}
