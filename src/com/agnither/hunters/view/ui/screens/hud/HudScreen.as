/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.hud {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.LeagueVO;
import com.agnither.hunters.data.outer.LevelVO;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.view.ui.popups.InventoryPopup;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Screen;
import com.cemaprjl1.core.coreAddListener;
import com.cemaprjl1.core.coreDispatch;
import com.cemaprjl1.core.coreExecute;
import com.cemaprjl1.viewmanage.ShowPopupCmd;

import starling.display.Button;
import starling.events.Event;

import starling.text.TextField;

public class HudScreen extends Screen {

    public static const NAME : String = "HudScreen";
    public static const UPDATE : String = "HudScreen.UPDATE";

    private var _player : LocalPlayer;
    private var _playerLevel : TextField;
    private var _playerExp : TextField;
    private var _playerLeague : TextField;
    private var _playerRating : TextField;
    private var _playerGold : TextField;
    private var _fullscreenButton : ButtonContainer;
    private var _musicButton : ButtonContainer;
    private var _soundButton : ButtonContainer;
    private var _inventoryBtn : ButtonContainer;
    private var _trapBtn : ButtonContainer;

    public function HudScreen() {
        _player = App.instance.player;
    }

    override protected function initialize() : void {
        createFromConfig(_refs.guiConfig.hud);

        _playerLevel = _links.levelVal_tf;
        _playerExp = _links.expVal_tf;
        _playerLeague = _links.leagueVal_tf;
        _playerRating = _links.ratingVal_tf;
        _playerGold = _links.goldVal_tf;
        _fullscreenButton = _links.fullscreen_btn;
        _musicButton = _links.music_btn;
        _soundButton = _links.sound_btn;

        _inventoryBtn = _links.inventory_btn;
        _inventoryBtn.text = "Инвентарь";
        _inventoryBtn.addEventListener(Event.TRIGGERED, onInventory);

        _trapBtn = _links.trap_btn;
        _trapBtn.text = "Ловушка";
        _trapBtn.addEventListener(Event.TRIGGERED, onTrap);

        coreAddListener(HudScreen.UPDATE, update)
    }

    private function onTrap(event : Event) : void {
        coreDispatch(MapScreen.START_TRAP);

    }

    private function onInventory(event : Event) : void {
        coreExecute(ShowPopupCmd, InventoryPopup.NAME);
    }


    override public function update() : void {
        _playerLevel.text = _player.hero.level.toString();
        _playerExp.text = _player.hero.exp.toString() + "/" +LevelVO.DICT[_player.hero.level.toString()].exp;
        _playerLeague.text = LeagueVO.DICT[_player.hero.league.toString()].name;
        _playerRating.text = _player.hero.rating.toString();
        _playerGold.text = _player.hero.gold.toString();
        _trapBtn.visible = !App.instance.trapMode;
    }
}
}
