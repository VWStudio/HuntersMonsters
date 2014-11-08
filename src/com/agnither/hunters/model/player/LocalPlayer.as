/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.personage.Progress;
import com.cemaprjl.core.coreAddListener;

public class LocalPlayer extends Player {

    public static const ITEM_SELECTED : String = "LocalPlayer.ITEM_SELECTED";


    private var _progress : Progress;


    public function LocalPlayer() {
        id = "player user";
        super();
        coreAddListener(LocalPlayer.ITEM_SELECTED, selectItem);
    }


    override public function init($data : Object) : void {
        super.init($data);
        initInventory($data.items, $data.inventory);
        initPets($data.pets);
    }


//    public function addGold(amount : int) : void {
//        _hero.gold += amount;
//    }

    public function addItem(item : Item) : void {
        _inventory.addItem(item);
    }


    private function selectItem(item : Item) : void {
        if (item.isWearing)
        {
            _inventory.unwearItem(item);
        }
        else
        {
            _inventory.wearItem(item);
        }
    }

//    public function get progress() : Progress {
//        return _progress;
//    }

    public function resetToBattle() : void {
        hero.healMax();
        pet.unsummon();
    }
}
}
