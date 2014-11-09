/**
 * Created by mor on 08.11.2014.
 */
package com.agnither.hunters.view.ui.popups.shop
{
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.common.GoldView;
import com.agnither.hunters.view.ui.popups.trainer.*;
import com.agnither.hunters.data.outer.TrapVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.model.player.personage.Progress;
import com.agnither.hunters.view.ui.common.TabView;
import com.agnither.hunters.view.ui.popups.monsters.PetView;
import com.agnither.hunters.view.ui.popups.traps.TrapItem;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.ItemView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.ItemView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.WeaponView;
import com.agnither.ui.AbstractView;
import com.agnither.ui.Popup;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;

import flash.geom.Rectangle;

import starling.display.Sprite;

import starling.events.Event;

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
    private var _gold : GoldView;

    public function ShopPopup()
    {
        super();
    }


    override protected function initialize() : void
    {
        createFromConfig(_refs.guiConfig.shop);

        addCloseButton(_links["close_btn"]);

        _traderTab = _links["trainer"];
        _traderTab.label = "Торговец";
        _traderTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _hunterTab = _links["hunter"];
        _hunterTab.label = "Охотник";
        _hunterTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);


        _currentOwner = _hunterTab;


        _weaponsTab = _links["weapon"];
        _weaponsTab.label = "Оружие";
        _weaponsTab.addEventListener(TabView.TAB_CLICK, handleSelectItems);
        _armorTab = _links["armor"];
        _armorTab.label = "Броня";
        _armorTab.addEventListener(TabView.TAB_CLICK, handleSelectItems);
        _magicTab = _links["magic"];
        _magicTab.label = "Предметы";
        _magicTab.addEventListener(TabView.TAB_CLICK, handleSelectItems);
        _spellsTab = _links["spells"];
        _spellsTab.label = "Заклинания";
        _spellsTab.addEventListener(TabView.TAB_CLICK, handleSelectItems);

        _currentType = _weaponsTab;

        _container = new Sprite();
        addChild(_container);
        _container.x = _links.items.x;
        _container.y = _links.items.y;

        _itemsRect = _links.items.getBounds(this);
        removeChild(_links.items);
        delete _links.items;

        _inventory = Model.instance.player.inventory;

        coreAddListener(Progress.UPDATED, update);

        coreAddListener(ShopPopup.SHOW_TOOLTIP, showTooltip);
        coreAddListener(ShopPopup.HIDE_TOOLTIP, hideTip);

        _tooltip = new Sprite();
        addChild(_tooltip);

        _gold = new GoldView();
        _tooltip.addChild(_gold);
        _tooltip.visible = false;

        update();
    }

    private function showTooltip($item : AbstractView) : void
    {

        var price : Number = $item["price"];
        if(!price) return;

        var rect : Rectangle = $item.getBounds(this);

        _tooltip.visible = true;
        _gold.x = rect.x + rect.width;
        _gold.y = rect.y + rect.height;
        _gold.data = price;
        _gold.update();

    }

    private function hideTip() : void
    {
        _tooltip.visible = false;
    }


    override public function update() : void
    {

        if(App.instance.currentPopup != this) return;

        _container.removeChildren();
            switch(_currentType) {
                case _weaponsTab :
                    if(_currentOwner == _traderTab) {
                        showSellerItems(ItemTypeVO.weapon);
                    } else {
                        showPlayerItems(ItemTypeVO.weapon);
                    }
                    break;
                case _armorTab :
                    if(_currentOwner == _traderTab) {
                        showSellerItems(ItemTypeVO.armor);
                    } else {
                        showPlayerItems(ItemTypeVO.armor);
                    }
                    break;
                case _magicTab :
                    if(_currentOwner == _traderTab) {
                        showSellerItems(ItemTypeVO.magic);
                    } else {
                        showPlayerItems(ItemTypeVO.magic);
                    }
                    break;
                case _spellsTab :
                    if(_currentOwner == _traderTab) {
                        showSellerItems(ItemTypeVO.spell);
                    } else {
                        showPlayerItems(ItemTypeVO.spell);
                    }
                    break;
            }

        _hunterTab.setIsSelected(_currentOwner);
        _traderTab.setIsSelected(_currentOwner);

        _weaponsTab.setIsSelected(_currentType);
        _armorTab.setIsSelected(_currentType);
        _magicTab.setIsSelected(_currentType);
        _spellsTab.setIsSelected(_currentType);

    }

    private function showSellerItems($type : int) : void
    {

        var items : Array = Model.instance.shop.getItemsByType($type);
        _container.removeChildren();
        for (var i:int = 0; i < items.length; i++) {
            var tile : BuyItemView = new BuyItemView();
            _container.addChild(tile);
            tile.setBuyItem(items[i]);
            tile.x = 210 * (i % 3);
            tile.y = 100 * int(i / 3);

        }

    }

    private function showPlayerItems($type : int) : void
    {

        var items : Array = _inventory.getItemsByType($type);
        _container.removeChildren();
        for (var i:int = 0; i < items.length; i++) {
            var tile : SellItemView = new SellItemView();
            _container.addChild(tile);
            tile.setSellItem(_inventory.getItem(items[i]));
            tile.x = 210 * (i % 3);
            tile.y = 100 * int(i / 3);

        }


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
