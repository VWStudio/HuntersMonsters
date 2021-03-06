/**
 * Created by agnither on 22.08.14.
 */
package com.agnither.hunters.view.ui.popups.monsters {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.TrapVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.player.inventory.PetsInventory;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.popups.monsters.SelectMonsterPopup;
import com.agnither.hunters.view.ui.popups.monsters.PetView;
import com.agnither.hunters.view.ui.popups.monsters.CatchedPetsView___not_used;
import com.agnither.hunters.view.ui.popups.traps.TrapItem;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import starling.display.Sprite;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class TrapsListView extends AbstractView {

    public static const NAME : String = "com.agnither.hunters.view.ui.popups.monsters.TrapsListView";
    private var _trapsContainer : Sprite;

    public function TrapsListView() {
    }

    override protected function initialize():void {

        _trapsContainer = new Sprite();
        addChild(_trapsContainer);


    }


    override public function update() : void
    {

        _trapsContainer.removeChildren();
        var boughtTraps : Array = new Array();
        //var boughtTraps : Array = Model.instance.progress.traps;
        //trace(JSON.stringify(boughtTraps));
        for (var i : int = 0; i < boughtTraps.length; i++)
        {
            var trapObj : Object = boughtTraps[i];
            var trap : TrapVO = TrapVO.fill(new TrapVO(), trapObj);
            var trapView : TrapItem = new TrapItem(trap);
            _trapsContainer.addChild(trapView);
            trapView.x = (_trapsContainer.numChildren - 1) % 4 * 170;
            trapView.y = int(_trapsContainer.numChildren / 4) * 170;
        }


    }

    public function get itemsAmount() : Number
    {
        return int(_trapsContainer.numChildren / 4) + 1;
    }
}
}
