/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.popups.inventory {
import com.agnither.hunters.App;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.*;
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class InventoryView extends AbstractView {

    private static var tileHeight: int;

    private var _inventory: Inventory;

    public function InventoryView() {
        _inventory = Model.instance.player.inventory;
    }

    override protected function initialize():void {
        // XXXCOMMON
        createFromConfig(_refs.guiConfig.common.spellsList);
//        createFromCommon(_refs.guiConfig.common.spellsList);

        tileHeight = _links.slot2.y - _links.slot1.y;
        _links.slot1.visible = false;
        _links.slot2.visible = false;

        _inventory.addEventListener(Inventory.UPDATE, handleUpdate);
        handleUpdate();
    }

    private function handleUpdate(e: Event = null):void {

        if(!this.stage) return;

        while (numChildren > 0) {
            var itemView: ItemView = removeChildAt(0) as ItemView;
            if (itemView) {
                itemView.removeEventListener(TouchEvent.TOUCH, handleTouch);
                itemView.destroy();
            }
        }

        var l: int = _inventory.inventoryItems.length;
        for (var i:int = 0; i < l; i++) {
            var item: Item = _inventory.getItem(_inventory.inventoryItems[i]);
            itemView = ItemView.create(item);
            itemView.addEventListener(TouchEvent.TOUCH, handleTouch);
            addChild(itemView);
            itemView.y = i * tileHeight;
            itemView.update();
//            itemView.noSelection();
        }
    }

    private function handleTouch(e: TouchEvent):void {
        var target: ItemView = e.currentTarget as ItemView;
        var touch: Touch = e.getTouch(target);
        if (touch) {
            Mouse.cursor = MouseCursor.BUTTON;
            if(touch.phase == TouchPhase.BEGAN) {
                coreDispatch(LocalPlayer.ITEM_SELECTED,  target.item);
            }
        } else {
            Mouse.cursor = MouseCursor.AUTO;
        }
    }
}
}
