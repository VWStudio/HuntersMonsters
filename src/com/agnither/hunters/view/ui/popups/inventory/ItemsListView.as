/**
 * Created by agnither on 22.08.14.
 */
package com.agnither.hunters.view.ui.popups.inventory {
import com.agnither.hunters.App;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.hunters.view.ui.common.items.SpellView;
import com.agnither.hunters.view.ui.popups.monsters.TamedMonsterView;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.*;
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import flash.geom.Point;

import flash.geom.Point;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.display.DisplayObject;

import starling.display.DisplayObjectContainer;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class ItemsListView extends AbstractView {



    public static var itemX: int;
    public static var itemY: int;

    private var _inventory: Inventory;
    private var _itemsAmount : int = 0;

    public function ItemsListView() {
        _inventory = Model.instance.player.inventory;
    }

    override protected function initialize():void {
    }

//    public function showType(type: String):void {
//        updateList(_inventory.getItemsByType(type));
////        updateList(_inventory.getItemsByType(type).concat(_inventory.getItemsByType(type)).concat(_inventory.getItemsByType(type)).concat(_inventory.getItemsByType(type)));
//    }

    private function updateList($data: Array):void {
//        while (numChildren > 0) {
//            var tile: ItemView = removeChildAt(0) as ItemView;
//            tile.removeEventListener(TouchEvent.TOUCH, handleTouch);
//            tile.destroy();
//        }

        clearList();
        var tile: ItemView;
        var arr : Array = $data;

        var pt : Point;
        for (var i:int = 0; i < arr.length; i++) {
            var item : Item = _inventory.getItem(arr[i]);

            if(item.type == "pet")
            {
                item.updateSlot();
            }

//            if(item.type == "tamed_pet") continue;
            tile = ItemView.create(item);
            if(!pt) pt = new Point(tile.width + 5, tile.height + 5);
            tile.addEventListener(TouchEvent.TOUCH, handleTouch);
            addChild(tile);
            tile.x = pt.x * (i % 3);
            tile.y = pt.y * int(i / 3);
            tile.update();
        }

        _itemsAmount = int(numChildren / 3);
    }

    /*public function showPets() : void
     {

     clearList();

     var catchedPets : Vector.<String> = MonsterAreaVO.NAMES_LIST;
     removeChildren();


     for (var i:int = 0; i < catchedPets.length; i++) {
     var tile: TamedMonsterView = new TamedMonsterView(catchedPets[i]);
     tile.addEventListener(TouchEvent.TOUCH, onTouchPet);
     addChild(tile);
     //            tile.allowToTame(false);
     tile.x = 180 * (i % 3);
     tile.y = 180 * int(i / 3);
     }

     _itemsAmount = int(numChildren / 3);
     } */

    private function handleTouch(e: TouchEvent):void {

        var item: ItemView = e.currentTarget as ItemView;
        var touch: Touch = e.getTouch(item);
//        var touch: Touch = e.getTouch(item, TouchPhase.BEGAN);
        if (touch) {
            Mouse.cursor = MouseCursor.BUTTON;
            if(touch.phase == TouchPhase.BEGAN) {
                //if (item.item.isPet()) coreDispatch(LocalPlayer.PET_SELECTED, item.item);
                item.update();
                coreDispatch(LocalPlayer.ITEM_SELECTED, item.item);

            }
            else if(touch.phase == TouchPhase.HOVER)
            {
                coreDispatch(ItemView.HOVER, item, item.item);
            }
        } else {
//            coreDispatch(ItemView.HOVER_OUT);
            Mouse.cursor = MouseCursor.AUTO;
        }
    }

    public function get itemsAmount() : int
    {
        return _itemsAmount;
    }

    private function clearList():void {
        while (numChildren > 0) {
            var dobj : DisplayObject = removeChildAt(0);
            if(dobj is ItemView) {
                var tile: ItemView = dobj as ItemView;
                tile.removeEventListener(TouchEvent.TOUCH, handleTouch);
                tile.destroy();
            }
        }
    }

    public function showThings() : void
    {
        updateList(_inventory.getItemsForView());
    }

    public function showSpells() : void
    {
        updateList(_inventory.getSpellsForView());
    }

    /*public function showSpells() : void
    {
        clearList();


        var spellsBaseArr :Vector.<ItemVO> = ItemVO.SPELLS;
        for (var i : int = 0; i < spellsBaseArr.length; i++)
        {
            var vo : ItemVO = spellsBaseArr[i];
            var spellItem : Item = _inventory.getSpell(vo.id);
            var tile : SpellView;
            if(spellItem) {
                tile = new SpellView(spellItem);
            } else {
                tile = new SpellView(Item.create(vo));
                tile.isExample = true;
            }
            tile.addEventListener(TouchEvent.TOUCH, handleTouch);
            addChild(tile);
            tile.x = itemX * (i % 3);
            tile.y = itemY * int(i / 3);
            tile.update();
        }

        _itemsAmount = int(numChildren / 3);

    }*/

    public function showPets() : void
    {
        updateList(_inventory.getPetsForView());
    }



    private function onTouchPet(e: TouchEvent):void {
        var item: TamedMonsterView = e.currentTarget as TamedMonsterView;
        var touch: Touch = e.getTouch(item);
//        var touch: Touch = e.getTouch(item, TouchPhase.BEGAN);
        if (touch) {
            Mouse.cursor = MouseCursor.BUTTON;
//            if(touch.phase == TouchPhase.BEGAN && !item.item.isPet()) {
//                coreDispatch(LocalPlayer.ITEM_SELECTED, item.item);
//                item.update();
//            }
//            else
            if(touch.phase == TouchPhase.HOVER)
            {
                coreDispatch(ItemView.HOVER, item, item.item);
            }
        } else {
            coreDispatch(ItemView.HOVER_OUT, item);
//            coreDispatch(ItemView.HOVER_OUT);
            Mouse.cursor = MouseCursor.AUTO;
        }
    }

}
}
