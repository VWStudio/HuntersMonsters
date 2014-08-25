/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.popups.inventory {
import com.agnither.hunters.view.ui.screens.battle.player.inventory.*;
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class InventoryView extends AbstractView {

    public static const ITEM_SELECTED: String = "item_selected_InventoryView";

    private static var tileHeight: int;

    private var _inventory: Inventory;

    public function InventoryView(refs:CommonRefs, inventory: Inventory) {
        _inventory = inventory;

        super(refs);
    }

    override protected function initialize():void {
        createFromCommon(_refs.guiConfig.common.spellsList);

        tileHeight = _links.slot2.y - _links.slot1.y;
        _links.slot1.visible = false;
        _links.slot2.visible = false;

        _inventory.addEventListener(Inventory.UPDATE, handleUpdate);
        handleUpdate();
    }

    private function handleUpdate(e: Event = null):void {
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
            itemView = ItemView.getItemView(_refs, item);
            itemView.addEventListener(TouchEvent.TOUCH, handleTouch);
            itemView.y = i * tileHeight;
            addChild(itemView);
        }
    }

    private function handleTouch(e: TouchEvent):void {
        var target: ItemView = e.currentTarget as ItemView;
        var touch: Touch = e.getTouch(target, TouchPhase.BEGAN);
        if (touch) {
            dispatchEventWith(ITEM_SELECTED, true, target.item);
        }
    }
}
}
