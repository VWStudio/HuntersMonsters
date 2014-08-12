/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens {
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

public class BattleScreen extends Screen {

    public static const ID: String = "BattleScreen";

    public function BattleScreen(refs:CommonRefs) {
        super(refs);
    }

    override protected function initialize():void {
        createFromConfig(_refs.guiConfig.battleScreen);
    }
}
}
