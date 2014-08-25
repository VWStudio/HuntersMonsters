/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.ItemVO;

public class Armor extends Item {

    override public function get icon():String {
        return "out_3.png";
    }

    private var _defence: int;
    public function get defence():int {
        return _defence;
    }

    public function Armor(item: ItemVO, defence: int = 0) {
        super(item, null);
//        _defence = defence ? (defence > 0 ? defence : item.randomDefence) : item.armor;
    }
}
}
