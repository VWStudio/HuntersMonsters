/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.inventory.Weapon;
import com.agnither.utils.CommonRefs;

public class WeaponView extends ItemView {

    public function get weapon():Weapon {
        return _item as Weapon;
    }

    public function WeaponView(refs:CommonRefs, weapon: Weapon) {
        super(refs, weapon);
    }

    override protected function initialize():void {
        super.initialize();

        _damage.text = String(weapon.damage);
    }
}
}
