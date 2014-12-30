/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.personage {
import com.agnither.hunters.model.player.inventory.Inventory;

public class Hero extends Personage {

    private var _inventory: Inventory;
    public var isPlayer : Boolean = false;



    public function get inventory():Inventory {
        return _inventory;
    }

    override public function get damage():int {
        return isPlayer ? _inventory.damage : super.damage;
//        return isPlayer ? _inventory.damage : damage;
    }

    override public function get defence():int {
        return isPlayer ? _inventory.defence : super.defence;
    }

    public function Hero(inventory: Inventory) {
        _inventory = inventory;
    }

    public function healMax() : void {
        heal(maxHP);
    }
}
}
