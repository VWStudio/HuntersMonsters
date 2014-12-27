/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.view.ui.popups.inventory
{
import com.agnither.hunters.model.modules.extensions.DamageExt;
import com.agnither.hunters.model.modules.extensions.DefenceExt;
import com.agnither.hunters.model.modules.extensions.ManaExt;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.common.Scroll;
import com.agnither.hunters.view.ui.common.TabView;
import com.agnither.hunters.view.ui.common.Tooltip;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.ui.Popup;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;

import flash.geom.Rectangle;

import starling.core.Starling;
import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class InventoryPopup extends Popup
{

    public static const NAME : String = "InventoryPopup";

    private var _itemsTab : TabView;
//    private var _armorTab : TabView;
    private var _spellTab : TabView;
    private var _petsTab : TabView;
//    private var _trapsTab: TabView;

    private var _inventoryView : InventoryView;

    private var _items : ItemsListView;
    private var _itemsContainer : Sprite;

    private var _closeBtn : Button;
    private var _scroll : Scroll;
//    private var _tooltip : Tooltip;
    private var _invTitle : TextField;
    private var _itemHeight : Number = 60;

    public function InventoryPopup()
    {
    }

    override protected function initialize() : void
    {
        createFromConfig(_refs.guiConfig.inventory_popup);

        _invTitle = _links["label_tf"];

        _itemsTab = _links.tab1;
        _itemsTab.label = Locale.getString("items_tab");
        _itemsTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _spellTab = _links.tab2;
        _spellTab.label = Locale.getString("spells_tab");
        _spellTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _petsTab = _links.tab3;
        _petsTab.label = Locale.getString("monster_tab");
        _petsTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

//        _spellTab = _links.tab4;
//        _spellTab.label = Locale.getString("spells_tab");
//        _spellTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

//        _trapsTab = _links.tab5;
//        removeChild(_trapsTab);
//        _trapsTab.label = Locale.getString("traps_tab");
//        _trapsTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        ItemsListView.itemX = _links.slot10.x - _links.slot00.x;
        ItemsListView.itemY = _links.slot01.y - _links.slot00.y;

        _links.slot00.removeFromParent(true);
        _links.slot01.removeFromParent(true);
        _links.slot10.removeFromParent(true);

        _items = new ItemsListView();
        _itemsContainer = _links.items;
        _itemsContainer.addChild(_items);


        _links.slots.visible = false;
        _inventoryView = new InventoryView();
        addChild(_inventoryView);
        _inventoryView.x = _links.slots.x;
        _inventoryView.y = _links.slots.y;
        _inventoryView.name = "INVENTORY POPUP ITEMS";

        _closeBtn = _links.close_btn;
        _closeBtn.touchable = true;
        _closeBtn.addEventListener(Event.TRIGGERED, handleClose);

        _scroll = new Scroll(_links["scroll"]);
        _scroll.onChange = onScroll;
        _itemsContainer.clipRect = new Rectangle(0, 0, 640, 460);


//        _tooltip = new Tooltip();
//        addChild(_tooltip);
//        _tooltip.visible = false;
//
//        coreAddListener(ItemView.HOVER, onItemHover);
//        coreAddListener(ItemView.HOVER_OUT, onItemHoverOut);
        //coreDispatch(ItemView.HOVER, item.item);
    }

//    private function onItemHoverOut() : void
//    {
//        _tooltip.visible = false;
//    }
//
//    private function onItemHover($item : ItemView) : void
//    {
//        if (!isActive)
//        {
//            return;
//        }
//        if ($item)
//        {
//            var rect : Rectangle = $item.getBounds(this);
//            _tooltip.x = rect.left;
//            _tooltip.y = rect.bottom;
//            var str : String = $item.item.description;
//            var exts : Object = $item.item.getExtensions();
//            for (var key : String in exts)
//            {
//                if (key == DamageExt.TYPE || key == DefenceExt.TYPE || key == ManaExt.TYPE)
//                {
////                    continue;
//                }
//                if (str.length > 0)
//                {
//                    str += "\n";
//                }
//                str += exts[key].getDescription();
////                str += Locale.getString(key);
//            }
//            _tooltip.text = str;
//            _tooltip.visible = str.length > 0;
//        }
//    }

    private function onScroll($val : Number) : void
    {

        var newy : Number = -_itemHeight * $val;
        Starling.juggler.tween(_items, 0.4, {y: newy});
    }


    override public function update() : void
    {
        _itemsTab.dispatchEventWith(TabView.TAB_CLICK);
//        handleSelectTab();
//        _items.showType(ItemTypeVO.weapon);
    }

//    override public function open():void {
//        super.open();
//
//    }

    private function handleSelectTab(e : Event) : void
    {
        _items.y = 0;
        switch (e.currentTarget)
        {
            case _itemsTab:
                _items.showThings();
//                _items.showType(ItemVO.TYPE_WEAPON);
//                _items.showType(ItemTypeVO.weapon);
                _itemHeight = 60;
                _scroll.setScrollParams(_items.itemsAmount, 8);

                break;
            case _spellTab:
//            case _armorTab:
                _items.showSpells();
//                _items.showType(ItemVO.TYPE_ARMOR);
//                _items.showType(ItemTypeVO.armor);
                _itemHeight = 60;
                _scroll.setScrollParams(_items.itemsAmount, 8);
                break;
            case _petsTab:
                _items.showPets();
//                _items.showType(ItemVO.TYPE_MAGIC);
//                _items.showType(ItemTypeVO.magic);
                _itemHeight = 180;
                _scroll.setScrollParams(_items.itemsAmount, 2);
                break;
//                _items.showType(ItemVO.TYPE_SPELL);
////                _items.showType(ItemTypeVO.spell);
//                _scroll.setScrollParams(_items.itemsAmount, 8);

//                break;
////            case _spellTab:
////                _trapsTab
//                break;
        }
        _itemsTab.setIsSelected(e.currentTarget as TabView);
//        _armorTab.setIsSelected(e.currentTarget as TabView);
        _petsTab.setIsSelected(e.currentTarget as TabView);
        _spellTab.setIsSelected(e.currentTarget as TabView);
//        _trapsTab.setIsSelected(e.currentTarget as TabView);


    }

    override protected function handleClose(e : Event) : void
    {
        coreDispatch(UI.HIDE_POPUP, NAME);
    }
}
}
