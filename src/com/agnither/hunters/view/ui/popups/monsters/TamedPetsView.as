/**
 * Created by agnither on 22.08.14.
 */
package com.agnither.hunters.view.ui.popups.monsters {
import com.agnither.hunters.App;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.player.inventory.PetsInventory;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.popups.monsters.SelectMonsterPopup;
import com.agnither.hunters.view.ui.popups.monsters.PetView;
import com.agnither.hunters.view.ui.popups.monsters.CatchedPetsView;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class TamedPetsView extends AbstractView {

    public static var itemX: int = 175;
    public static var itemY: int = 175;

    public function TamedPetsView() {
    }


    override public function update() : void {

        var catchedPets : Vector.<String> = MonsterAreaVO.NAMES_LIST;

        removeChildren();

        var isBattle : Boolean = Model.instance.state == BattleScreen.NAME;

        for (var i:int = 0; i < catchedPets.length; i++) {

            if(isBattle && Model.instance.progress.tamedMonsters.indexOf(catchedPets[i]) == -1 ) {
                continue;
            }

            var tile: TamedMonsterView = new TamedMonsterView(catchedPets[i]);
            addChild(tile);
            tile.x = 180 * (i % 4);
            tile.y = 180 * int(i / 4);
        }

    }

}
}
