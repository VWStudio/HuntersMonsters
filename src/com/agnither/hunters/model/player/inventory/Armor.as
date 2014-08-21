/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.ArmorVO;

public class Armor extends Item {

    override public function get icon():String {
        return "out_3.png";
    }

    public function get armor():ArmorVO {
        return _item as ArmorVO;
    }

    private var _defence: int;
    public function get defence():int {
        return _defence;
    }

    public function Armor(item: ArmorVO, defence: int = 0) {
        super(item);
        _defence = defence ? (defence>0 ? defence : item.randomDefence) : item.armor;
    }
}
}
