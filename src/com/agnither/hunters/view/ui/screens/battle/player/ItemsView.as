/**
 * Created by agnither on 22.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class ItemsView extends AbstractView {

    public static const ITEM_SELECTED: String = "item_selected_ItemsView";

    public static const WEAPON: String = "weapon";
    public static const ARMOR: String = "armor";
    public static const ITEMS: String = "items";
    public static const SPELLS: String = "spells";

    public static var itemX: int;
    public static var itemY: int;

    private var _inventory: Inventory;

    public function ItemsView(refs:CommonRefs, inv: Inventory) {
        _inventory = inv;
        super(refs);
    }

    override protected function initialize():void {
    }

    public function showType(type: int):void {
        updateList(_inventory.getItemsByType(type));
//        switch (type) {
//            case WEAPON:
//                break;
//            case ARMOR:
//                updateList(_inventory.armors);
//                break;
//            case ITEMS:
//                updateList(_inventory.items);
//                break;
//            case SPELLS:
//                updateList(_inventory.spells);
//                break;
//        }
    }

    private function updateList(data: Vector.<String>):void {
        while (numChildren > 0) {
            var tile: ItemView = removeChildAt(0) as ItemView;
            tile.removeEventListener(TouchEvent.TOUCH, handleTouch);
            tile.destroy();
        }

        for (var i:int = 0; i < data.length; i++) {
            tile = ItemView.getItemView(_refs, _inventory.getItem(data[i]));
            tile.addEventListener(TouchEvent.TOUCH, handleTouch);
            tile.x = itemX * (i % 3);
            tile.y = itemY * int(i / 3);
            addChild(tile);
        }
    }

    private function handleTouch(e: TouchEvent):void {
        var item: ItemView = e.currentTarget as ItemView;
        var touch: Touch = e.getTouch(item, TouchPhase.BEGAN);
        if (touch) {
            dispatchEventWith(ITEM_SELECTED, true, item.item);
        }
    }
}
}
