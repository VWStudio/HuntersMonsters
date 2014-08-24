/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.ItemVO;

public class Weapon extends Item {

    override public function get icon():String {
        return "out_4.png";
    }

    private var _damage:int;
    public function get damage():int {
        return _damage;
    }

    public function Weapon(item: ItemVO, damage:int = 0) {
        super(item);
//        _damage = damage ? (damage > 0 ? damage : item.randomDamage) : item.damage;
    }
}
}
