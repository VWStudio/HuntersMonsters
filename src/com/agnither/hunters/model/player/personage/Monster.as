/**
 * Created by agnither on 25.08.14.
 */
package com.agnither.hunters.model.player.personage {
import com.agnither.hunters.model.player.inventory.Pet;

public class Monster extends Personage {

    private var _pet: Pet;

    public function summon(pet: Pet):void {
        _pet = pet;
        init(_pet.params);
        update();
    }

    public function unsummon():void {
        _pet = null;
    }
}
}
