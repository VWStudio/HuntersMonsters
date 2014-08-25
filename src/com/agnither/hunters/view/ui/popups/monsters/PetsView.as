/**
 * Created by agnither on 22.08.14.
 */
package com.agnither.hunters.view.ui.popups.monsters {
import com.agnither.hunters.model.player.inventory.PetsInventory;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class PetsView extends AbstractView {

    public static const PET_SELECTED: String = "pet_selected_MonstersView";

    public static var itemX: int;
    public static var itemY: int;

    private var _inventory: PetsInventory;

    public function PetsView(refs:CommonRefs, pets: PetsInventory) {
        _inventory = pets;
        super(refs);
    }

    override protected function initialize():void {
    }

    public function showType(type: int):void {
        updateList(_inventory.getPetsByType(type));
    }

    private function updateList(data: Array):void {
        while (numChildren > 0) {
            var tile: PetView = removeChildAt(0) as PetView;
            tile.removeEventListener(TouchEvent.TOUCH, handleTouch);
            tile.destroy();
        }

        for (var i:int = 0; i < data.length; i++) {
            tile = new PetView(_refs, _inventory.getPet(data[i]));
            tile.addEventListener(TouchEvent.TOUCH, handleTouch);
            tile.x = itemX * (i % 4);
            tile.y = itemY * int(i / 4);
            addChild(tile);
        }
    }

    private function handleTouch(e: TouchEvent):void {
        var pet: PetView = e.currentTarget as PetView;
        var touch: Touch = e.getTouch(pet, TouchPhase.BEGAN);
        if (touch) {
            dispatchEventWith(PET_SELECTED, true, pet.pet);
        }
    }
}
}
