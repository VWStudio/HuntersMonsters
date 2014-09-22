/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player.inventory {
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class BattleInventoryView extends AbstractView {

    public static const ITEM_SELECTED: String = "item_selected_BattleInventoryView";

    private static var tileHeight: int;

    private var _inventory: Inventory;

    public function BattleInventoryView(inventory: Inventory) {
        _inventory = inventory;
    }

    override protected function initialize():void {
        createFromCommon(_refs.guiConfig.common.spellsList);

        tileHeight = _links.slot2.y - _links.slot1.y;
        _links.slot1.visible = false;
        _links.slot2.visible = false;

        var l: int = _inventory.inventoryItems.length;
        for (var i:int = 0; i < l; i++) {
            var item: Item = _inventory.getItem(_inventory.inventoryItems[i]);
            var itemView: ItemView = ItemView.getItemView(item);
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
