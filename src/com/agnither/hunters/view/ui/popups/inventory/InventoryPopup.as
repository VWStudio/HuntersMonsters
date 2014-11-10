/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.view.ui.popups.inventory {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.popups.inventory.InventoryView;
import com.agnither.hunters.view.ui.popups.inventory.ItemsView;
import com.agnither.hunters.view.ui.common.TabView;
import com.agnither.ui.Popup;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;

public class InventoryPopup extends Popup {

    public static const NAME: String = "InventoryPopup";

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
    }

    override protected function initialize():void {
        createFromConfig(_refs.guiConfig.inventory_popup);

        _weaponTab = _links.tab1;
        _weaponTab.label = Locale.getString("weapon_tab");
        _weaponTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _armorTab = _links.tab2;
        _armorTab.label = Locale.getString("armor_tab");
        _armorTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _itemTab = _links.tab3;
        _itemTab.label = Locale.getString("items_tab");
        _itemTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _spellTab = _links.tab4;
        _spellTab.label = Locale.getString("spells_tab");
        _spellTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _trapsTab = _links.tab5;
        _trapsTab.label = Locale.getString("traps_tab");
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
        addChild(_inventoryView);
        _inventoryView.x = _links.slots.x;
        _inventoryView.y = _links.slots.y;

        _closeBtn = _links.close_btn;
        _closeBtn.touchable = true;
        _closeBtn.addEventListener(Event.TRIGGERED, handleClose);
    }


    override public function update() : void {
        _weaponTab.dispatchEventWith(TabView.TAB_CLICK);
//        handleSelectTab();
//        _items.showType(ItemTypeVO.weapon);
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
            case _spellTab:
//                _trapsTab
                break;
        }
        _weaponTab.setIsSelected(e.currentTarget as TabView);
        _armorTab.setIsSelected(e.currentTarget as TabView);
        _itemTab.setIsSelected(e.currentTarget as TabView);
        _spellTab.setIsSelected(e.currentTarget as TabView);
        _trapsTab.setIsSelected(e.currentTarget as TabView);


    }

    override protected function handleClose(e: Event):void {
        coreDispatch(UI.HIDE_POPUP, NAME);
    }
}
}
