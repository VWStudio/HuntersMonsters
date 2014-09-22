/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.hud {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.LeagueVO;
import com.agnither.hunters.data.outer.LevelVO;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Screen;

import starling.display.Button;

import starling.text.TextField;

public class HudScreen extends Screen {

    public static const ID : String = "HudScreen";

    private var _player : LocalPlayer;
    private var _playerLevel : TextField;
    private var _playerExp : TextField;
    private var _playerLeague : TextField;
    private var _playerRating : TextField;
    private var _playerGold : TextField;
    private var _fullscreenButton : ButtonContainer;
    private var _musicButton : ButtonContainer;
    private var _soundButton : ButtonContainer;

    public function HudScreen() {
        _player = App.instance.player;
    }

    override protected function initialize() : void {
        createFromConfig(_refs.guiConfig.hud);

        _playerLevel = _links.levelVal_tf;
        _playerLevel.text = _player.hero.level.toString();
        _playerExp = _links.expVal_tf;
        _playerExp.text = _player.hero.exp.toString() + "/" +LevelVO.DICT[_player.hero.level.toString()].exp;
        _playerLeague = _links.leagueVal_tf;
        _playerLeague.text = LeagueVO.DICT[_player.hero.league.toString()].name;
        _playerRating = _links.ratingVal_tf;
        _playerRating.text = _player.hero.rating.toString();
        _playerGold = _links.goldVal_tf;
        _playerGold.text = _player.hero.gold.toString();

        _fullscreenButton = _links.fullscreen_btn;
        _musicButton = _links.music_btn;
        _soundButton = _links.sound_btn;

    }
}
}
