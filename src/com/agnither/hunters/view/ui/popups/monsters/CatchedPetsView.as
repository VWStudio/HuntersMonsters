/**
 * Created by agnither on 22.08.14.
 */
package com.agnither.hunters.view.ui.popups.monsters {
import com.agnither.hunters.App;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.model.player.inventory.PetsInventory;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.popups.monsters.SelectMonsterPopup;
import com.agnither.hunters.view.ui.popups.monsters.PetView;
import com.agnither.hunters.view.ui.popups.monsters.CatchedPetsView;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class CatchedPetsView extends AbstractView {

    public static const PET_SELECTED: String = "pet_selected_MonstersView";

    public static var itemX: int = 180;
    public static var itemY: int = 180;

    private var _pets: PetsInventory;

    public function CatchedPetsView() {
        _pets = Model.instance.player.pets;
    }

    override public function update() : void {
//        var catchedPets : Array = _inventory.getPetsByType(0);
        var catchedPets : Vector.<Pet> = _pets.petsList;
//        var catchedPets : Array = _pets.catchedPets;

        removeChildren();

        var tile: PetView;
        for (var i:int = 0; i < catchedPets.length; i++) {
            tile = new PetView(_pets.getPet(catchedPets[i].uniqueId));
//            tile.addEventListener(TouchEvent.TOUCH, handleTouch);
            addChild(tile);
            tile.x = itemX * (i % 4);
            tile.y = itemY * int(i / 4);
        }

    }

    private function handleTouch(e: TouchEvent):void {
        if(Model.instance.state == MapScreen.NAME) {
            return;
        }

        var pet: PetView = e.currentTarget as PetView;
        var touch: Touch = e.getTouch(pet, TouchPhase.BEGAN);
        if (touch) {
            coreDispatch(CatchedPetsView.PET_SELECTED, pet.pet);
            coreDispatch(UI.HIDE_POPUP, SelectMonsterPopup.NAME);
        }
    }
    public function showTamedMonsters() : void {


        var catchedPets : Vector.<String> = MonsterAreaVO.NAMES_LIST;

        removeChildren();

//        while (numChildren > 0) {
//            var tile: PetView = removeChildAt(0) as PetView;
//            tile.removeEventListener(TouchEvent.TOUCH, handleTouch);
//            tile.destroy();
//        }


        for (var i:int = 0; i < catchedPets.length; i++) {
            var tile: TamedMonsterView = new TamedMonsterView(catchedPets[i]);
//            tile.addEventListener(TouchEvent.TOUCH, handleTouch);
            tile.x = itemX * (i % 4);
            tile.y = itemY * int(i / 4);
            addChild(tile);
        }


    }
}
}
