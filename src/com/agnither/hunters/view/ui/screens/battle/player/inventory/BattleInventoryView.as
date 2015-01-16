/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player.inventory {
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.ManaList;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;

import starling.display.Sprite;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class BattleInventoryView extends AbstractView {

    public static const ITEM_SELECTED: String = "item_selected_BattleInventoryView";

    private static var tileHeight: int;

    private var _inventory: Inventory;
    private var _itemsContainer : Sprite;
    public var player : Player;

    public function BattleInventoryView() {
    }


    override protected function initialize():void {
        // XXXCOMMON
//        createFromCommon(_refs.guiConfig.common.spellsList);
        createFromConfig(_refs.guiConfig.common.spellsList);

        tileHeight = _links.slot2.y - _links.slot1.y;
        _links.slot1.visible = false;
        _links.slot2.visible = false;

        _itemsContainer = new Sprite();
        addChild(_itemsContainer);

        coreAddListener(ManaList.MANA_ADDED, onManaAdded);

    }

    private function onManaAdded() : void
    {
        for (var i : int = 0; i < _itemsContainer.numChildren; i++)
        {
            var item : ItemView= _itemsContainer.getChildAt(i) as ItemView;
            if(item.item.isSpell()) {
                item.selected = player.manaList.checkSpell(item.item);
            }
        }
    }

    private function handleTouch(e: TouchEvent):void {
        var target: ItemView = e.currentTarget as ItemView;
        var touch: Touch = e.getTouch(target, TouchPhase.BEGAN);
        if (touch) {
            dispatchEventWith(ITEM_SELECTED, true, target.item);
        }
        var touchHover: Touch = e.getTouch(target, TouchPhase.HOVER);
        if(touchHover) {
            coreDispatch(ItemView.HOVER, target, target.item, 0 ,false, true);
        } else {
//            coreDispatch(ItemView.HOVER_OUT)
        }
    }

    public function set inventory(value : Inventory) : void {
        _inventory = value;
        var l: int = _inventory.inventoryItems.length;

        clearItems();

        for (var i:int = 0; i < l; i++) {
            var item: Item = _inventory.getItem(_inventory.inventoryItems[i]);
            var itemView: ItemView = ItemView.create(item);
            itemView.addEventListener(TouchEvent.TOUCH, handleTouch);
            _itemsContainer.addChild(itemView);
            itemView.y = i * tileHeight;
            itemView.noSelection();
            itemView.update();
        }
    }

    private function clearItems() : void {

        while(_itemsContainer.numChildren > 0) {
            var item : ItemView = _itemsContainer.getChildAt(0) as ItemView;
            _itemsContainer.removeChild(item);
            item.removeEventListener(TouchEvent.TOUCH, handleTouch);
            item.destroy();
        }


    }


}
}
