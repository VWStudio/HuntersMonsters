/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.hud {
import com.agnither.hunters.App;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.ui.Screen;

import starling.text.TextField;

public class HudScreen extends Screen {

    public static const ID : String = "HudScreen";

    private var _player : LocalPlayer;
    private var _playerLevel : TextField;

    public function HudScreen() {
        _player = App.instance.player;
    }

    override protected function initialize() : void {
        createFromConfig(_refs.guiConfig.hud);

        _playerLevel = _links.levelVal_tf;
        _playerLevel.text = _player.hero.level.toString();


    }
}
}
