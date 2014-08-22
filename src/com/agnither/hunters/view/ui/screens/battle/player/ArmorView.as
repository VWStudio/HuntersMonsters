/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.inventory.Armor;
import com.agnither.utils.CommonRefs;

public class ArmorView extends ItemView {

    public function get armor():Armor {
        return _item as Armor;
    }

    public function ArmorView(refs:CommonRefs, armor: Armor) {
        super(refs, armor);
    }

    override protected function initialize():void {
        super.initialize();

        _damage.text = String(armor.defence);
    }
}
}
