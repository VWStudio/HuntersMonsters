/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.MagicItemVO;

public class MagicItem extends Item {

    override public function get icon():String {
        return "out_2.png";
    }

    public function get magicItem():MagicItemVO {
        return _item as MagicItemVO;
    }

    public function MagicItem(item: MagicItemVO) {
        super(item);
    }
}
}
