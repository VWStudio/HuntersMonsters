/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.ItemVO;
import com.agnither.hunters.model.player.personage.Personage;

public class Spell extends Item {

    public function get damage():int {
        return 0;
    }

    public function get mana():Object {
        return _item.extension_drop;
    }

    public function Spell(item: ItemVO) {
        super(item, null);
    }

    public function useSpell(target: Personage):void {
        target.hit(damage, true);
    }
}
}
