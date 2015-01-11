/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.popups.house
{
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.Territory;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Popup;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.utils.Formatter;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class HousePopup extends Popup
{


    public static const NAME : String = "com.agnither.hunters.view.ui.popups.house.HousePopup";

//    public static const SELECT_MONSTER: String = "select_monster_BattleScreen";

    private var _back : Image;
    private var _getPrizeButton : ButtonContainer;
    private var _closeButton : ButtonContainer;
    private var _title : TextField;
    private var _attackButton : ButtonContainer;
    private var _owner : TextField;
    private var _itemsContainer : Sprite;
//    private var houseData : Object;
    private var _items : Array;
    private var _randomContainer : Sprite;
    private var _priceText : TextField;
    private var _item : ItemView;
    private var territory : Territory;

    public function HousePopup()
    {

        super();
    }

    override protected function initialize() : void
    {

        createFromConfig(_refs.guiConfig.house_popup);


        _back = _links["bitmap_common_back"];
        _closeButton = _links["close_btn"];
        _closeButton.addEventListener(Event.TRIGGERED, handleClose);

        _title = _links["title_tf"];
        _title.text = Locale.getString("house");
        _title.fontSize = 30;
        _owner = _links["owner_tf"];

        _attackButton = _links["play_btn"];
        _attackButton.addEventListener(Event.TRIGGERED, handlePlay);
        _attackButton.text = "Захватить";
        _attackButton.visible = false;

        _getPrizeButton = _links["attack_btn"];
        _getPrizeButton.addEventListener(Event.TRIGGERED, handleGet);
        _getPrizeButton.text = "Купить";
        _getPrizeButton.visible = false;

        _priceText = _links["price_tf"];
        _priceText.text = "";
        _priceText.visible = false;

        _itemsContainer = new Sprite();
        addChild(_itemsContainer);
        _itemsContainer.x = 210;
        _itemsContainer.y = 70;

        _randomContainer = new Sprite();
        addChild(_randomContainer);
        _randomContainer.x = 400;
        _randomContainer.y = 200;
        _randomContainer.visible = false;

        coreAddListener(Model.UPDATE_HOUSE, onHouseUpdate);


    }

    private function onHouseUpdate() : void
    {
        if (territory.isHouseOwner)
        {
            if (territory.houseTimeout > 0)
            {
                _priceText.text = "Осталось:" + Formatter.msToHHMMSS(territory.houseTimeout);
            }
            else
            {
                //update();
            }
        }
    }

    private function handleGet(event : Event) : void
    {
        if (territory.nextRandomHouseItem)
        {
            Model.instance.player.addItem(territory.nextRandomHouseItem);
            territory.generateNewHouseItem();
            update();
        }
    }

    override protected function handleClose(event : Event) : void
    {
        coreDispatch(UI.HIDE_POPUP, NAME);
    }

    private function handlePlay(event : Event) : void
    {


        Model.instance.match3mode = Match3Game.MODE_HOUSE;
        Model.instance.currentHouseTerritory = territory;
        coreDispatch(UI.HIDE_POPUP, NAME);
        coreDispatch(Match3Game.START_GAME, Model.instance.monsters.getRandomMonster());

    }


    override public function update() : void
    {

        territory = data as Territory;

        _owner.text = territory.isHouseOwner ? "Открывает новые товары для магазина:" : "Открывает новые товары для магазина:";
        //_attackButton.visible = !territory.isHouseOwner;

        _itemsContainer.removeChildren();

        if (territory.houseUnlockItems)
        {

            var houseItems : Array = territory.houseUnlockItems.slice();

            var itemsArr : Array = [];
            var i : int = 0;
            while (i < 10 && houseItems.length > 0)
            {
                var item : ItemVO = houseItems.splice(int(Math.random() * houseItems.length), 1)[0];
                itemsArr.push(Item.create(item.clone()));
            }

            itemsArr = itemsArr.sort(sortInventory);

            for (i = 0; i < itemsArr.length; i++)
            {
                var iview : ItemView = ItemView.create(itemsArr[i]);
                iview.addEventListener(TouchEvent.TOUCH, handleTouch);
                _itemsContainer.addChild(iview);

                iview.x = (iview.width + 5) * (i % 2);
                iview.y = (iview.height + 5) * int(i / 2);

//                trace(i, iview.x, iview.y);

//                iview.y = i * (iview.height + 5);
//                if (i > 2)
//                {
//                    iview.x = iview.width + 5;
//                    iview.y -= 3 * (iview.height + 5);
//                }
                iview.update();
                iview.demoMode();
            }
        }

        _randomContainer.removeChildren();

        _item = ItemView.create(territory.nextRandomHouseItem);
        _item.update();
        _randomContainer.addChild(_item);
        if (territory.isHouseOwner)
        {
            _getPrizeButton.text = "Взять";
            _getPrizeButton.visible = territory.houseTimeout <= 0;
            _priceText.text = _getPrizeButton.visible ? "Вещь готова" : "";
        }
        else
        {
            _priceText.text = "Стоимость: " + 200 + "$";
            _getPrizeButton.text = "Купить";
        }


    }

    public function sortInventory($a : Item, $b : Item) : int
    {
        var itemA : Item = $a;
        var itemB : Item = $b;

        if (itemA.slot < itemB.slot)
        {
            return -1;
        }
        else if (itemA.slot > itemB.slot)
        {
            return 1;
        }
        else
        {
            if (itemA.getDamage() > itemB.getDamage())
            {
                return -1;
            }
            else if (itemA.getDamage() < itemB.getDamage())
            {
                return 1;
            }
        }
        return 0;
    }


    private function handleTouch(e : TouchEvent) : void
    {
        var item : ItemView = e.currentTarget as ItemView;
        var touch : Touch = e.getTouch(item);
//        var touch: Touch = e.getTouch(item, TouchPhase.BEGAN);
        if (touch)
        {
            Mouse.cursor = MouseCursor.BUTTON;
            if (touch.phase == TouchPhase.BEGAN && !item.item.isPet())
            {
//                coreDispatch(LocalPlayer.ITEM_SELECTED, item.item);
//                item.update();
            }
            else if (touch.phase == TouchPhase.HOVER)
            {
                coreDispatch(ItemView.HOVER, item);
            }
        }
        else
        {
//            coreDispatch(ItemView.HOVER_OUT);
            Mouse.cursor = MouseCursor.AUTO;
        }
    }


}
}
