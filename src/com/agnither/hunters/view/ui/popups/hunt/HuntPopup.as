/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.popups.hunt {
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.screens.battle.monster.MonsterInfo;
import com.agnither.hunters.view.ui.screens.map.*;
import com.agnither.hunters.App;
import com.agnither.hunters.model.Match3Game;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Popup;
import com.agnither.ui.Screen;
import com.cemaprjl.core.coreDispatch;

import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.utils.Dictionary;

import starling.display.Button;

import starling.display.DisplayObject;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class HuntPopup extends Popup {

    public static const NAME : String = "HuntPopup.NAME";

//    public static const SELECT_MONSTER: String = "select_monster_BattleScreen";

    private var _player : LocalPlayer;

    private var _back : Image;
    private var _playButton : ButtonContainer;
    private var _monster : MonsterInfo;
    private var _closeButton : ButtonContainer;

    public function HuntPopup() {

        _player = App.instance.player;

        super();
    }

    override protected function initialize() : void {

        createFromConfig(_refs.guiConfig.hunt_popup);

        _back = _links["bitmap__bg"];
//        _back.touchable = true;
        _closeButton = _links["close_btn"];
        _closeButton.addEventListener(Event.TRIGGERED, handleClose);


        _playButton = _links["play_btn"];
        _playButton.addEventListener(Event.TRIGGERED, handlePlay);
        _playButton.text = "Напасть";

        _monster = _links.monster;


    }

    private function handleClose(event : Event) : void {
        coreDispatch(UI.HIDE_POPUP, NAME);
    }

    private function handlePlay(event : Event) : void {

        coreDispatch(UI.HIDE_POPUP, NAME);
        coreDispatch(Match3Game.START_GAME, data);
    }


    override public function update() : void {

        _monster.data = data;
        _monster.update();

        /**
         * kinda progress
         */

//        var player : LocalPlayer = _player as LocalPlayer;
//        for (var i : int = 0; i < player.progress.regions.length; i++)
//        {
//            var regionID : String = player.progress.regions[i];
//            if(_clouds[regionID]) {
//                _clouds[regionID].visible = false;
//            }
//        }
//
//        _playerPositions["00"].visible = true;
//        _clouds["01"].visible = false;

    }


}
}
