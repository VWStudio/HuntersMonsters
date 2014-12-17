/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.hud {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.LeagueVO;
import com.agnither.hunters.data.outer.LevelVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.personage.Progress;
import com.agnither.hunters.view.ui.popups.inventory.InventoryPopup;
import com.agnither.hunters.view.ui.popups.monsters.SelectMonsterPopup;
import com.agnither.hunters.view.ui.popups.monsters.CatchedPetsView;
import com.agnither.hunters.view.ui.popups.skills.SkillsPopup;
import com.agnither.hunters.view.ui.screens.camp.CampScreen;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Screen;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.viewmanage.ShowPopupCmd;
import com.cemaprjl.viewmanage.ShowScreenCmd;

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
//    private var _trapBtn : ButtonContainer;
    private var _resetBtn : ButtonContainer;
    private var _monstersBtn : ButtonContainer;
    private var _modeBtn : ButtonContainer;
    private var _skillsButton : ButtonContainer;

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

        _links.trap_btn.visible = false;
//        _trapBtn.text = "Убрать ловушку";
//        _trapBtn.addEventListener(Event.TRIGGERED, onTrap);

        _resetBtn = _links.reset_btn;
        _resetBtn.text = "Сбросить все";
//        _resetBtn.addEventListener(Event.TRIGGERED, onReset);
        _resetBtn.visible = false;

        _monstersBtn = _links.monsters_btn;
        _monstersBtn.visible = false;
//        _monstersBtn.text = "Монстры";
//        _monstersBtn.addEventListener(Event.TRIGGERED, onMonster);

        _skillsButton = _links.skills_btn;
        _skillsButton.text = "Навыки";
        _skillsButton.addEventListener(Event.TRIGGERED, onSkills);

        _modeBtn = _links.mode_btn;

        _modeBtn.addEventListener(Event.TRIGGERED, onMode);

        coreAddListener(HudScreen.UPDATE, update);
        coreAddListener(Progress.UPDATED, update);
        coreAddListener(Model.RESET_GAME, onReset);
    }

    private function onSkills(event : Event) : void
    {
        coreExecute(ShowPopupCmd, SkillsPopup.NAME);
    }

    private function onMode(event : Event) : void {
        switch (Model.instance.state) {
            case MapScreen.NAME :
                coreExecute(ShowScreenCmd, CampScreen.NAME);
                break;
            case CampScreen.NAME :
                coreExecute(ShowScreenCmd, MapScreen.NAME);
                break;

        }
    }

//    private function onMonster(event : Event) : void {
//
//        coreExecute(ShowPopupCmd, SelectMonsterPopup.NAME);
//    }

//    private function onTrap(event : Event) : void {
//        coreDispatch(MapScreen.STOP_TRAP);
//    }

    private function onInventory(event : Event) : void {
        coreExecute(ShowPopupCmd, InventoryPopup.NAME);
    }


    override public function update() : void {
        var progress :  Progress = Model.instance.progress;
        _playerLevel.text = progress.level.toString();
//        trace("EXP", progress.level, progress.fullExp, LevelVO.DICT[progress.level.toString()].exp, progress.exp);
        _playerExp.text = progress.fullExp.toString() + "/" +LevelVO.DICT[progress.level.toString()].exp;
        _playerLeague.text = LeagueVO.DICT[progress.league.toString()].name;
        _playerRating.text = progress.rating.toString();
        _playerGold.text = progress.gold.toString();
//        _trapBtn.visible = App.instance.trapMode;

        _modeBtn.text = Model.instance.state == MapScreen.NAME ? "Лагерь" : "Карта";
    }

    /*

     */

    private function onReset(event : Event = null) : void {

        Model.instance.progress.reset();

        var url:String;
        if(Model.instance.flashvars && Model.instance.flashvars["api_id"] != null) {
            url = "app"+Model.instance.flashvars["api_id"];
        } else {
            url = ExternalInterface.call("window.location.href.toString");
        }

        navigateToURL(new URLRequest(url))
    }
}
}
