/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player.inventory {
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.utils.CommonRefs;

public class MagicItemView extends ItemView {

    public function MagicItemView(refs:CommonRefs, item: Item) {
        super(refs, item);
    }

    override protected function initialize():void {
        super.initialize();

        _damage.text = "";
    }
}
}
