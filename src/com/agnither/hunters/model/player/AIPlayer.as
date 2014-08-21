/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.inner.InventoryVO;
import com.agnither.hunters.data.inner.PersonageVO;
import com.agnither.hunters.data.outer.MagicVO;
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.hunters.model.player.inventory.Spell;
import com.agnither.hunters.model.player.personage.Hero;
import com.agnither.hunters.model.player.personage.Personage;

import starling.events.EventDispatcher;

public class AIPlayer extends Player {

    private var _difficulty: int;
    public function get difficulty():int {
        return _difficulty;
    }

    public function AIPlayer(difficulty: int):void {
        _difficulty = difficulty;
    }
}
}
