/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.view.ui.popups {
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.view.ui.screens.battle.player.InventoryView;
import com.agnither.hunters.view.ui.screens.battle.player.ItemsView;
import com.agnither.hunters.view.ui.screens.battle.player.TabView;
import com.agnither.ui.Popup;
import com.agnither.utils.CommonRefs;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;

public class InventoryPopup extends Popup {

    public static const ID: String = "InventoryPopup";

    private var _player: LocalPlayer;

    private var _weaponTab: TabView;
    private var _armorTab: TabView;
    private var _itemTab: TabView;
    private var _spellTab: TabView;

    private var _inventoryView: InventoryView;

    private var _items: ItemsView;
    private var _itemsContainer: Sprite;

    private var _closeBtn: Button;

    public function InventoryPopup(refs:CommonRefs, player: LocalPlayer) {
        _player = player;

        super(refs);
    }

    override protected function initialize():void {
        createFromConfig(_refs.guiConfig.inventory_popup);

        _links.tab1.visible = false;
        _weaponTab = new TabView(_refs, "weapon");
        _weaponTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);
        _weaponTab.x = _links.tab1.x;
        _weaponTab.y = _links.tab1.y;
        addChild(_weaponTab);

        _links.tab2.visible = false;
        _armorTab = new TabView(_refs, "armor");
        _armorTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);
        _armorTab.x = _links.tab2.x;
        _armorTab.y = _links.tab2.y;
        addChild(_armorTab);

        _links.tab3.visible = false;
        _itemTab = new TabView(_refs, "items");
        _itemTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);
        _itemTab.x = _links.tab3.x;
        _itemTab.y = _links.tab3.y;
        addChild(_itemTab);

        _links.tab4.visible = false;
        _spellTab = new TabView(_refs, "spells");
        _spellTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);
        _spellTab.x = _links.tab4.x;
        _spellTab.y = _links.tab4.y;
        addChild(_spellTab);

        ItemsView.itemX = _links.slot10.x - _links.slot00.x;
        ItemsView.itemY = _links.slot01.y - _links.slot00.y;

        _links.slot00.removeFromParent(true);
        _links.slot01.removeFromParent(true);
        _links.slot10.removeFromParent(true);

        _items = new ItemsView(_refs, _player.inventory);
        _itemsContainer = _links.items;
        _itemsContainer.addChild(_items);

        _links.slots.visible = false;
        _inventoryView = new InventoryView(_refs, _player.inventory);
        _inventoryView.x = _links.slots.x;
        _inventoryView.y = _links.slots.y;
        addChild(_inventoryView);

        _closeBtn = _links.close_btn;
        _closeBtn.addEventListener(Event.TRIGGERED, handleClose);
    }

    override public function open():void {
        super.open();

        _items.showType(ItemTypeVO.weapon);
    }

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
