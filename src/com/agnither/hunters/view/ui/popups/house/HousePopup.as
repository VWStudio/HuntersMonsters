/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.popups.house {
import com.agnither.hunters.data.inner.InventoryVO;
import com.agnither.hunters.data.outer.ItemVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.personage.Monster;
import com.agnither.hunters.view.ui.popups.hunt.*;
import com.agnither.hunters.data.outer.MonsterVO;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.screens.battle.monster.MonsterInfo;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.ItemView;
import com.agnither.hunters.view.ui.screens.map.*;
import com.agnither.hunters.App;
import com.agnither.hunters.model.Match3Game;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Popup;
import com.agnither.ui.Screen;
import com.cemaprjl.core.coreDispatch;

import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.utils.Dictionary;

import starling.display.Button;

import starling.display.DisplayObject;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class HousePopup extends Popup {


    public static const NAME : String = "com.agnither.hunters.view.ui.popups.house.HousePopup";

//    public static const SELECT_MONSTER: String = "select_monster_BattleScreen";

    private var _player : LocalPlayer;

    private var _back : Image;
    private var _getPrizeButton : ButtonContainer;
    private var _closeButton : ButtonContainer;
    private var _title : TextField;
    private var _attackButton : ButtonContainer;
    private var _owner : TextField;
    private var _itemsContainer : Sprite;
    private var houseData : Object;
    private var _isOwner : Boolean;
    private var _items : Array;
    private var _randomContainer : Sprite;
    private var _currentItem : ItemVO;

    public function HousePopup() {

        _player = App.instance.player;

        super();
    }

    override protected function initialize() : void {

        createFromConfig(_refs.guiConfig.house_popup);


        _back = _links["bitmap__bg"];
        _closeButton = _links["close_btn"];
        _closeButton.addEventListener(Event.TRIGGERED, handleClose);

        _title = _links["title_tf"];
        _owner = _links["owner_tf"];

        _attackButton = _links["play_btn"];
        _attackButton.addEventListener(Event.TRIGGERED, handlePlay);
        _attackButton.text = "Захватить";

        _getPrizeButton = _links["attack_btn"];
        _getPrizeButton.addEventListener(Event.TRIGGERED, handleGet );
        _getPrizeButton.text = "Купить";

        _itemsContainer = new Sprite();
        addChild(_itemsContainer);
        _itemsContainer.x = 100;
        _itemsContainer.y = 100;

        _randomContainer = new Sprite();
        addChild(_randomContainer);
        _randomContainer.x = 400;
        _randomContainer.y = 200;

    }

    private function handleGet(event : Event) : void {
        if(_currentItem) {
            App.instance.player.addItem(Item.createItem(_currentItem, _currentItem.extension));
            _currentItem = null;
            _randomContainer.removeChildren();
        }
    }

    private function handleClose(event : Event) : void {
        coreDispatch(UI.HIDE_POPUP, NAME);
    }

    private function handlePlay(event : Event) : void {


        Model.instance.match3mode = Match3Game.MODE_HOUSE;
        Model.instance.currentHousePoint = data["point"];
        coreDispatch(UI.HIDE_POPUP, NAME);
        coreDispatch(Match3Game.START_GAME, Model.instance.getRandomMonster());

    }


    override public function update() : void {

        houseData = Model.instance.houses[data["id"]];
        _isOwner = (houseData.owner && houseData.owner == App.instance.player.id);
        _owner.text = _isOwner ? "Вы владеете этим домом" : "Дом принадлежит не вам";
        _attackButton.visible = !_isOwner;

        _itemsContainer.removeChildren();
//        _items = [];
        if(houseData.unlockItems) {
            for (var i : int = 0; i < houseData.unlockItems.length; i++)
            {
                    var id: int = houseData.unlockItems[i];
                    var item : ItemVO = ItemVO.DICT[id];
//                    _items.push(item);
                    var iview : ItemView = ItemView.getItemView(Item.createItem(item, item.extension));
                    _itemsContainer.addChild(iview);
                    iview.y = i * 70;
            }
        }

        _randomContainer.removeChildren();


        _currentItem = houseData.nextRandomItem = ItemVO.THINGS[int(ItemVO.THINGS.length * Math.random())];
        var iview1 : ItemView = ItemView.getItemView(Item.createItem(_currentItem, _currentItem.extension));
        _randomContainer.addChild(iview1);


    }


}
}