/**
 * Created by mor on 08.11.2014.
 */
package com.agnither.hunters.view.ui.popups.shop
{
import com.agnither.hunters.App;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.Shop;
import com.agnither.hunters.model.modules.extensions.DamageExt;
import com.agnither.hunters.model.modules.extensions.DefenceExt;
import com.agnither.hunters.model.modules.extensions.ManaExt;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.personage.Progress;
import com.agnither.hunters.view.ui.common.GoldView;
import com.agnither.hunters.view.ui.common.Scroll;
import com.agnither.hunters.view.ui.common.TabView;
import com.agnither.hunters.view.ui.common.Tooltip;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.hunters.view.ui.popups.inventory.InventoryView;
import com.agnither.ui.AbstractView;
import com.agnither.ui.Popup;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.utils.Formatter;

import flash.geom.Point;

import flash.geom.Rectangle;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class ShopPopup extends Popup
{

    public static const NAME : String = "com.agnither.hunters.view.ui.popups.shop.ShopPopup";

    private var _traderTab : TabView;
    private var _hunterTab : TabView;
    private var _weaponsTab : TabView;
    private var _armorTab : TabView;
    private var _currentOwner : TabView;
    private var _currentType : TabView;
    private var _container : Sprite;
    private var _itemsRect : Rectangle;
    private var _magicTab : TabView;
    private var _spellsTab : TabView;
    private var _inventory : Inventory;
    public static const SHOW_TOOLTIP : String = "ShopPopup.SHOW_TOOLTIP";
    public static const HIDE_TOOLTIP : String = "ShopPopup.HIDE_TOOLTIP";
    private var _tooltip : Sprite;
//    private var _gold : GoldView;
    private var _inventoryView : InventoryView;
    private var _scroll : Scroll;
    private var _scrollMask : Sprite;
//    private var _tooltipItem : Tooltip;
    private var _deliver : TextField;
    private var _deliverTime : TextField;

    public function ShopPopup()
    {
        super();
    }


    override protected function initialize() : void
    {
        createFromConfig(_refs.guiConfig.shop);

        handleCloseButton(_links["close_btn"]);

        _traderTab = _links["trainer"];
        _traderTab.label = Locale.getString("hunter_tab");
        _traderTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _hunterTab = _links["hunter"];
        _hunterTab.label = Locale.getString("seller_tab");
        _hunterTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);


        _currentOwner = _hunterTab;


        _inventoryView = new InventoryView();
        addChild(_inventoryView);
        _inventoryView.x = 20;
        _inventoryView.y = 85;
        _inventoryView.name = "SHOP POPUP ITEMS";


        _weaponsTab = _links["weapon"];
        _weaponsTab.label = Locale.getString("weapon_tab");
//        _weaponsTab.addEventListener(TabView.TAB_CLICK, handleSelectItems);
        _armorTab = _links["armor"];
        _armorTab.label = Locale.getString("armor_tab");
//        _armorTab.addEventListener(TabView.TAB_CLICK, handleSelectItems);
        _magicTab = _links["magic"];
        _magicTab.label = Locale.getString("items_tab");
//        _magicTab.addEventListener(TabView.TAB_CLICK, handleSelectItems);
        _spellsTab = _links["spells"];
        _spellsTab.label = Locale.getString("spells_tab");
//        _spellsTab.addEventListener(TabView.TAB_CLICK, handleSelectItems);

        _weaponsTab.visible = false;
        _armorTab.visible = false;
        _magicTab.visible = false;
        _spellsTab.visible = false;

        _currentType = _weaponsTab;

        _scrollMask = new Sprite();
        addChild(_scrollMask);
        _scrollMask.x = _links.items.x;
        _scrollMask.y = _links.items.y;

        _container = new Sprite();
        _scrollMask.addChild(_container);

        _itemsRect = _links.items.getBounds(this);
        removeChild(_links.items);
        delete _links.items;

        _inventory = Model.instance.player.inventory;

        coreAddListener(Progress.UPDATED, update);

//        coreAddListener(ShopPopup.SHOW_TOOLTIP, showTooltip);
//        coreAddListener(ShopPopup.HIDE_TOOLTIP, hideTip);

        coreAddListener(Shop.NEW_DELIVER, onNewDeliver);
        coreAddListener(Shop.DELIVER_TIME, onDeliverTime);

        _tooltip = new Sprite();
        addChild(_tooltip);

//        _gold = new GoldView();
//        _tooltip.addChild(_gold);
//        _tooltip.visible = false;

//        _gold.touchable = true;
//        _tooltip.touchable = true;

//        Model.instance.itemsTooltip = _gold;

        _scroll = new Scroll(_links["scroll"]);
        _scroll.onChange = onScroll;
        _scrollMask.clipRect = new Rectangle(0, 0, 440, 500);

//        _tooltipItem = new Tooltip();
//        _tooltip.addChild(_tooltipItem);
//        _tooltipItem.visible = false;
//        _tooltipItem.y = 50;

        _deliver = _links["deliver_tf"];
        _deliverTime = _links["deliverTime_tf"];


        update();
    }

    private function onNewDeliver() : void
    {
        if (!isActive)
        {
            return;
        }
        update();
    }

    private function onDeliverTime() : void
    {
        if (!isActive)
        {
            return;
        }
        _deliverTime.text = Formatter.msToHHMMSS(Model.instance.deliverTime);
    }

    private function onScroll($val : Number) : void
    {

        var newy : Number = -60 * $val;
        Starling.juggler.tween(_container, 0.4, {y: newy});
    }

//    private function showTooltip($item : AbstractView) : void
//    {
//        var price : Number = $item["price"];
//        var item : Item = $item["item"];
////        if (!price)
////        {
////            return;
////        }
//
//        var rect : Rectangle = $item.getBounds(this);
//
//        _tooltip.visible = true;
//        _tooltip.x = rect.x;
//        _tooltip.y = rect.y + rect.height - 5;
//        _gold.data = price;
//        _gold.item = item;
//        _gold.isSell = _currentOwner == _hunterTab;
//        _gold.update();
//
//
////        _gold.visible = str.length > 0;
//
//    }
//
//    private function hideTip($val : Boolean = true) : void
//    {
//        if(_gold.touched) return;
//        _tooltip.visible = !$val;
//    }


    override public function update() : void
    {

        if (!isActive)
        {
            return;
        }


        _container.removeChildren();
        if (_currentOwner == _traderTab)
        {
            showSellerItems();
        }
        else
        {
            showPlayerItems();
        }
        coreDispatch(ItemView.HOVER_OUT);
        _deliver.text = "Сделующая поставка:";

        _hunterTab.setIsSelected(_currentOwner);
        _traderTab.setIsSelected(_currentOwner);

        return;

//        switch (_currentType)
//        {
//            case _weaponsTab :
//                if (_currentOwner == _traderTab)
//                {
//                    showSellerItems(ItemVO.TYPE_WEAPON);
////                    showSellerItems(ItemTypeVO.weapon);
//                }
//                else
//                {
//                    showPlayerItems(ItemVO.TYPE_WEAPON);
////                    showPlayerItems(ItemTypeVO.weapon);
//                }
//                break;
//            case _armorTab :
//                if (_currentOwner == _traderTab)
//                {
//                    showSellerItems(ItemVO.TYPE_ARMOR);
//                }
//                else
//                {
//                    showPlayerItems(ItemVO.TYPE_ARMOR);
//                }
//                break;
//            case _magicTab :
//                if (_currentOwner == _traderTab)
//                {
//                    showSellerItems(ItemVO.TYPE_MAGIC);
//                }
//                else
//                {
//                    showPlayerItems(ItemVO.TYPE_MAGIC);
//                }
//                break;
//            case _spellsTab :
//                if (_currentOwner == _traderTab)
//                {
//                    showSellerItems(ItemVO.TYPE_SPELL);
//                }
//                else
//                {
//                    showPlayerItems(ItemVO.TYPE_SPELL);
//                }
//                break;
//        }




//        _weaponsTab.setIsSelected(_currentType);
//        _armorTab.setIsSelected(_currentType);
//        _magicTab.setIsSelected(_currentType);
//        _spellsTab.setIsSelected(_currentType);

    }

    private function showSellerItems($type : String = "") : void
//    private function showSellerItems($type : String) : void
    {

        var items : Array = Model.instance.shop.getItemsByType(ItemVO.TYPE_WEAPON);
        items = items.concat(Model.instance.shop.getItemsByType(ItemVO.TYPE_ARMOR));
        items = items.concat(Model.instance.shop.getItemsByType(ItemVO.TYPE_MAGIC));
        items = items.concat(Model.instance.shop.getItemsByType(ItemVO.TYPE_SPELL));
//        var items : Array = Model.instance.shop.getItemsByType($type);





        _container.removeChildren();
        for (var i : int = 0; i < items.length; i++)
        {
            var tile : BuyItemView = new BuyItemView(items[i]);
            _container.addChild(tile);
            tile.x = 210 * (i % 2);
            tile.y = 70 * int(i / 2);

        }
        _scroll.setScrollParams(int((_container.numChildren + 1) / 2), 5);
    }

    private function showPlayerItems($type : String = "") : void
    {

        var items : Array = _inventory.getItemsByType(ItemVO.TYPE_WEAPON);
        items = items.concat(_inventory.getItemsByType(ItemVO.TYPE_ARMOR));
        items = items.concat(_inventory.getItemsByType(ItemVO.TYPE_MAGIC));
        items = items.concat(_inventory.getItemsByType(ItemVO.TYPE_PET));

        _container.removeChildren();
        for (var i : int = 0; i < items.length; i++)
        {
            var tile : SellItemView = new SellItemView(_inventory.getItem(items[i]));
            _container.addChild(tile);
            tile.x = 210 * (i % 2);
            tile.y = 100 * int(i / 2);

        }
        _scroll.setScrollParams(int((_container.numChildren + 1) / 2), 5);

    }

    private function handleSelectItems(event : Event) : void
    {

        _currentType = event.currentTarget as TabView;

        update();

    }

    private function handleSelectTab(event : Event) : void
    {
        _currentOwner = event.currentTarget as TabView;


        update();
    }
}
}
