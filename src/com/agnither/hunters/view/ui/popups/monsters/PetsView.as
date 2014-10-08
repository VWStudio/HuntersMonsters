/**
 * Created by agnither on 22.08.14.
 */
package com.agnither.hunters.view.ui.popups.monsters {
import com.agnither.hunters.App;
import com.agnither.hunters.model.player.inventory.PetsInventory;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.popups.SelectMonsterPopup;
import com.agnither.hunters.view.ui.popups.monsters.PetView;
import com.agnither.hunters.view.ui.popups.monsters.PetsView;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class PetsView extends AbstractView {

    public static const PET_SELECTED: String = "pet_selected_MonstersView";

    public static var itemX: int;
    public static var itemY: int;

    private var _inventory: PetsInventory;

    public function PetsView() {
        _inventory = App.instance.player.pets;
    }

    override protected function initialize():void {
    }

    public function showType(type: int):void {
        updateList(_inventory.getPetsByType(type));
    }

    private function updateList(data: Array):void {
        trace(JSON.stringify(data));
        while (numChildren > 0) {
            var tile: PetView = removeChildAt(0) as PetView;
            tile.removeEventListener(TouchEvent.TOUCH, handleTouch);
            tile.destroy();
        }

        for (var i:int = 0; i < data.length; i++) {
            tile = new PetView(_inventory.getPet(data[i]));
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
            coreDispatch(PetsView.PET_SELECTED, pet.pet);
            coreDispatch(UI.HIDE_POPUP, SelectMonsterPopup.NAME);
//            dispatchEventWith(PET_SELECTED, true, pet.pet);
        }
    }
}
}
