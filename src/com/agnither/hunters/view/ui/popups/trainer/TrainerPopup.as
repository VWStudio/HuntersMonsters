/**
 * Created by mor on 08.11.2014.
 */
package com.agnither.hunters.view.ui.popups.trainer
{
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.TrapVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.model.player.personage.Progress;
import com.agnither.hunters.view.ui.common.TabView;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.hunters.view.ui.popups.monsters.PetView;
import com.agnither.hunters.view.ui.popups.monsters.TamedMonsterView;
import com.agnither.hunters.view.ui.popups.traps.TrapItem;
import com.agnither.ui.Popup;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;

import flash.geom.Rectangle;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.display.Sprite;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class TrainerPopup extends Popup
{

    public static const NAME : String = "com.agnither.hunters.view.ui.popups.trainer.TrainerPopup";

    private var _trainerTab : TabView;
    private var _hunterTab : TabView;
    private var _monstersTab : TabView;
    private var _trapsTab : TabView;
    private var _currentOwner : TabView;
    private var _currentType : TabView;
    private var _container : Sprite;
    private var _itemsRect : Rectangle;

    public function TrainerPopup()
    {
        super();
    }


    override protected function initialize() : void
    {
        createFromConfig(_refs.guiConfig.trainerPopup);

        handleCloseButton(_links["close_btn"]);

        _trainerTab = _links["trainer"];
        _trainerTab.label = "Торговец";
        _trainerTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);

        _hunterTab = _links["hunter"];
        _hunterTab.label = "Охотник";
        _hunterTab.addEventListener(TabView.TAB_CLICK, handleSelectTab);


        _currentOwner = _trainerTab;


        _monstersTab = _links["monsters"];
        _monstersTab.label = "Монстры";
//        _monstersTab.addEventListener(TabView.TAB_CLICK, handleSelectItems);
        _trapsTab = _links["traps"];
        _trapsTab.label = "Ловушки";
        _trapsTab.visible = false;
//        _trapsTab.addEventListener(TabView.TAB_CLICK, handleSelectItems);

        _currentType = _monstersTab;

        _container = new Sprite();
        addChild(_container);
        _container.x = _links.items.x;
        _container.y = _links.items.y;

        _itemsRect = _links.items.getBounds(this);
        removeChild(_links.items);
        delete _links.items;

        coreAddListener(Progress.UPDATED, update);

        update();
    }


    override public function update() : void
    {

        if(App.instance.currentPopup != this) return;


        _container.removeChildren();
        if (_currentOwner == _trainerTab)
        {
//            _currentType = _trapsTab;  // XXX hack
//            if (_currentType == _monstersTab)
//            {
//
//
//            }
//            else if (_currentType == _trapsTab)
//            {
////                for (var i : int = 0; i < TrapVO.LIST.length; i++)
////                {
////                    var trap : TrapVO = TrapVO.LIST[i].clone();
////                    var trapView : TrapItem = new TrapItem(trap);
////                    _container.addChild(trapView);
////                    trapView.x = (_container.numChildren - 1) % 4 * 170;
////                    trapView.y = int(_container.numChildren / 4) * 170;
////                    trapView.buyMode(true);
////                }
//            }
        }
        else if (_currentOwner == _hunterTab)
        {
            _currentType = _monstersTab; // XXX hack
            if (_currentType == _monstersTab)
            {

                var catchedPets : Vector.<Pet> = Model.instance.player.pets.petsList;

                var tile: PetView;
                for (var j:int = 0; j < catchedPets.length; j++) {
                    tile = new PetView(Model.instance.player.pets.getPet(catchedPets[j].uniqueId));
//                    tile.addEventListener(TouchEvent.TOUCH, onTouchPet);
                    _container.addChild(tile);
                    tile.x = 180 * (j % 4);
                    tile.y = 180 * int(j / 4);
                    tile.setBuyable(true);
                }

            }
            else if (_currentType == _trapsTab)
            {

            }
        }


        _hunterTab.setIsSelected(_currentOwner);
        _trainerTab.setIsSelected(_currentOwner);
        _monstersTab.setIsSelected(_currentType);
//        _trapsTab.setIsSelected(_currentType);

    }


//    private function onTouchPet(e: TouchEvent):void {
//        var item: PetView = e.currentTarget as PetView;
//        var touch: Touch = e.getTouch(item);
////        var touch: Touch = e.getTouch(item, TouchPhase.BEGAN);
//        if (touch) {
//            Mouse.cursor = MouseCursor.BUTTON;
////            if(touch.phase == TouchPhase.BEGAN && !item.item.isPet()) {
////                coreDispatch(LocalPlayer.ITEM_SELECTED, item.item);
////                item.update();
////            }
////            else
//            if(touch.phase == TouchPhase.HOVER)
//            {
//                coreDispatch(ItemView.HOVER, item);
//            }
//        } else {
////            coreDispatch(ItemView.HOVER_OUT);
//            Mouse.cursor = MouseCursor.AUTO;
//        }
//    }


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
