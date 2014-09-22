/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.view.ui.popups {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.view.ui.popups.inventory.InventoryView;
import com.agnither.hunters.view.ui.popups.inventory.ItemsView;
import com.agnither.hunters.view.ui.common.TabView;
import com.agnither.ui.Popup;
import com.agnither.utils.CommonRefs;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;

public class InventoryPopup extends Popup {

    public static const ID: String = "InventoryPopup";

    private var _player: Player;

    private var _weaponTab: TabView;
    private var _armorTab: TabView;
    private var _itemTab: TabView;
    private var _spellTab: TabView;
    private var _trapsTab: TabView;

    private var _inventoryView: InventoryView;

    private var _items: ItemsView;
    private var _itemsContainer: Sprite;

    private var _closeBtn: Button;

    public function InventoryPopup() {
        _player = App.instance.player;
    }

    override protected function initialize():void {
        createFromConfig(_refs.guiConfig.inventory_popup);

        _weaponTab = _links.tab1;
        _weaponTab.label = "weapon";
        _weaponTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _armorTab = _links.tab2;
        _armorTab.label = "armor";
        _armorTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _itemTab = _links.tab3;
        _itemTab.label = "items";
        _itemTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _spellTab = _links.tab4;
        _spellTab.label = "spells";
        _spellTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _trapsTab = _links.tab5;
        _trapsTab.label = "traps";
        _trapsTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        ItemsView.itemX = _links.slot10.x - _links.slot00.x;
        ItemsView.itemY = _links.slot01.y - _links.slot00.y;

        _links.slot00.removeFromParent(true);
        _links.slot01.removeFromParent(true);
        _links.slot10.removeFromParent(true);

        _items = new ItemsView();
        _itemsContainer = _links.items;
        _itemsContainer.addChild(_items);

        _links.slots.visible = false;
        _inventoryView = new InventoryView();
        _inventoryView.x = _links.slots.x;
        _inventoryView.y = _links.slots.y;
        addChild(_inventoryView);

        _closeBtn = _links.close_btn;
        _closeBtn.addEventListener(Event.TRIGGERED, handleClose);
    }


    override public function update() : void {
        _items.showType(ItemTypeVO.weapon);
    }

//    override public function open():void {
//        super.open();
//
//    }

    private function handleSelectTab(e: Event):void {
        switch (e.currentTarget) {
            case _weaponTab:
                _items.showType(ItemTypeVO.weapon);
                break;
            case _armorTab:
                _items.showType(ItemTypeVO.armor);
                break;
            case _itemTab:
                _items.showType(ItemTypeVO.magic);
                break;
            case _spellTab:
                _items.showType(ItemTypeVO.spell);
                break;
        }
    }

    private function handleClose(e: Event):void {
        dispatchEventWith(CLOSE);
    }
}
}
