/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.hud {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.LeagueVO;
import com.agnither.hunters.data.outer.LevelVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.view.ui.popups.InventoryPopup;
import com.agnither.hunters.view.ui.popups.SelectMonsterPopup;
import com.agnither.hunters.view.ui.popups.monsters.PetsView;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Screen;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.viewmanage.ShowPopupCmd;

import flash.external.ExternalInterface;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import starling.events.Event;

import starling.text.TextField;

public class HudScreen extends Screen {

    public static const NAME : String = "HudScreen";
    public static const UPDATE : String = "HudScreen.UPDATE";

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
    private var _resetBtn : ButtonContainer;
    private var _monstersBtn : ButtonContainer;

    public function HudScreen() {
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

        _resetBtn = _links.reset_btn;
        _resetBtn.text = "Сбросить все";
        _resetBtn.addEventListener(Event.TRIGGERED, onReset);

        _monstersBtn = _links.monsters_btn;
        _monstersBtn.text = "Монстры";
        _monstersBtn.addEventListener(Event.TRIGGERED, onMonster);

        coreAddListener(HudScreen.UPDATE, update)
    }

    private function onMonster(event : Event) : void {

        coreExecute(ShowPopupCmd, SelectMonsterPopup.NAME);
    }

    private function onTrap(event : Event) : void {
        coreDispatch(MapScreen.START_TRAP);

    }

    private function onInventory(event : Event) : void {
        coreExecute(ShowPopupCmd, InventoryPopup.NAME);
    }


    override public function update() : void {
        var player :  LocalPlayer = Model.instance.player;
        _playerLevel.text = player.hero.level.toString();
        _playerExp.text = player.hero.exp.toString() + "/" +LevelVO.DICT[player.hero.level.toString()].exp;
        _playerLeague.text = LeagueVO.DICT[player.hero.league.toString()].name;
        _playerRating.text = player.hero.rating.toString();
        _playerGold.text = player.hero.gold.toString();
        _trapBtn.visible = !App.instance.trapMode;
    }

    private function onReset(event : Event) : void {

        Model.instance.player.reset();

        var url:String = ExternalInterface.call("window.location.href.toString");
        navigateToURL(new URLRequest(url))

    }
}
}
