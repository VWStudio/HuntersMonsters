/**
 * Created by agnither on 22.08.14.
 */
package com.agnither.hunters.view.ui.popups.inventory {
import com.agnither.hunters.App;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.hunters.view.ui.common.items.SpellView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.*;
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

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
        while (numChildren > 0) {
            var tile: ItemView = removeChildAt(0) as ItemView;
            tile.removeEventListener(TouchEvent.TOUCH, handleTouch);
            tile.destroy();
        }

        for (var i:int = 0; i < $data.length; i++) {
            tile = ItemView.create(_inventory.getItem($data[i]));
            tile.addEventListener(TouchEvent.TOUCH, handleTouch);
            addChild(tile);
            tile.x = itemX * (i % 3);
            tile.y = itemY * int(i / 3);
            tile.update();
        }

        _itemsAmount = int(numChildren / 3);
    }

    private function handleTouch(e: TouchEvent):void {
        var item: ItemView = e.currentTarget as ItemView;
        var touch: Touch = e.getTouch(item);
//        var touch: Touch = e.getTouch(item, TouchPhase.BEGAN);
        if (touch) {
            Mouse.cursor = MouseCursor.BUTTON;
            if(touch.phase == TouchPhase.BEGAN) {
                coreDispatch(LocalPlayer.ITEM_SELECTED, item.item);
                item.update();
            }
            else if(touch.phase == TouchPhase.HOVER)
            {
                coreDispatch(ItemView.HOVER, item);
            }
        } else {
            coreDispatch(ItemView.HOVER_OUT);
            Mouse.cursor = MouseCursor.AUTO;
        }
    }

    public function get itemsAmount() : int
    {
        return _itemsAmount;
    }

    public function showThings() : void
    {

//        var items : Array = _inventory.getItemsByType(type);

        updateList(_inventory.getItemsForView());
    }

    private function clearList():void {
        while (numChildren > 0) {
            var tile: ItemView = removeChildAt(0) as ItemView;
            tile.removeEventListener(TouchEvent.TOUCH, handleTouch);
            tile.destroy();
        }
    }

    public function showSpells() : void
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

    }

    public function showPets() : void
    {
        updateList([]);
    }
}
}
