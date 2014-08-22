/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.inventory.MagicItem;
import com.agnither.hunters.model.player.inventory.Weapon;
import com.agnither.utils.CommonRefs;

public class MagicItemView extends ItemView {

    public function get magicItem():MagicItem {
        return _item as MagicItem;
    }

    public function MagicItemView(refs:CommonRefs, magicItem: MagicItem) {
        super(refs, magicItem);
    }

    override protected function initialize():void {
        super.initialize();

        _damage.text = "";
    }
}
}
