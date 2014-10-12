/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player.inventory {
import com.agnither.hunters.view.ui.screens.battle.player.*;
import com.agnither.hunters.data.outer.ExtensionVO;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.utils.CommonRefs;

public class ArmorView extends ItemView {

    public function ArmorView(item: Item) {
        super(item);
    }

    override protected function initialize():void {
        super.initialize();

        _damage.text = item.extension[ExtensionVO.defence].toString();
    }
}
}
