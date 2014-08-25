/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.ItemVO;

public class MagicItem extends Item {

    override public function get icon():String {
        return "out_2.png";
    }

    public function MagicItem(item: ItemVO) {
        super(item, null);
    }
}
}
