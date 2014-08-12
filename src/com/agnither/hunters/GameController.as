/**
 * Created by agnither on 06.08.14.
 */
package com.agnither.hunters {
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.screens.BattleScreen;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.ResourcesManager;

import starling.display.Stage;
import starling.events.EventDispatcher;

public class GameController extends EventDispatcher {

    private var _stage: Stage;
    private var _resources: ResourcesManager;

    private var _ui: UI;

    public function GameController(stage: Stage, resources: ResourcesManager) {
        _stage = stage;
        _resources = resources;
    }

    public function init():void {
        _ui = new UI(new CommonRefs(_resources), this);
        _stage.addChildAt(_ui, 0);
    }

    public function ready():void {
        _ui.showScreen(BattleScreen.ID);
    }
}
}
