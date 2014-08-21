/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.SpellVO;
import com.agnither.hunters.model.player.personage.Personage;

public class Spell extends Item {

    public function get spell():SpellVO {
        return _item as SpellVO;
    }

    public function get damage():int {
        return spell.damage;
    }

    public function get mana():Array {
        return spell.mana;
    }

    public function Spell(item: SpellVO) {
        super(item);
    }

    public function useSpell(target: Personage):void {
        target.hit(damage, true);
    }
}
}
