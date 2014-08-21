/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.drop {
public class GoldDrop extends Drop {

    private var _gold: int;
    public function get gold():int {
        return _gold;
    }

    override public function get icon():String {
        return "out_1.png";
    }

    public function GoldDrop(amount: int) {
        _gold = amount;
    }

    override public function stack(drop: Drop):Boolean {
        if (drop is GoldDrop) {
            _gold += (drop as GoldDrop).gold;
            return true;
        }
        return false;
    }
}
}
