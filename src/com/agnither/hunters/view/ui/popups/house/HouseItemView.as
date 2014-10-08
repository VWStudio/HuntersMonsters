/**
 * Created by agnither on 22.08.14.
 */
package com.agnither.hunters.view.ui.popups.house {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.ItemVO;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.inventory.Item;
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

public class HouseItemView extends AbstractView {

    public function HouseItemView() {
    }

    override protected function initialize():void {
    }

    private function updateList(data: Array):void {
        while (numChildren > 0) {
            var tile: ItemView = removeChildAt(0) as ItemView;
            tile.removeEventListener(TouchEvent.TOUCH, handleTouch);
            tile.destroy();
        }

            tile = ItemView.getItemView(Item.createItem(data as ItemVO));
            addChild(tile);
    }

    private function handleTouch(e: TouchEvent):void {
        var item: ItemView = e.currentTarget as ItemView;
        var touch: Touch = e.getTouch(item);
//        var touch: Touch = e.getTouch(item, TouchPhase.BEGAN);
        if (touch) {
            Mouse.cursor = MouseCursor.BUTTON;
            if(touch.phase == TouchPhase.BEGAN) {
                coreDispatch(LocalPlayer.ITEM_SELECTED, item.item);
//                dispatchEventWith(ITEM_SELECTED, true, item.item);
            }
        } else {
            Mouse.cursor = MouseCursor.AUTO;
        }
    }
}
}
