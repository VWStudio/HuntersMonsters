/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.ExtensionVO;
import com.agnither.hunters.data.outer.ItemVO;
import com.agnither.hunters.model.player.personage.Personage;

public class Spell extends Item {

    public function Spell(item: ItemVO, extension: Object) {
        super(item, extension);
    }

    public function useSpell(target: Personage):void {
        var damage: int = extension[ExtensionVO.damage];
        if (damage) {
            target.hit(damage, true);
        }
    }
}
}
