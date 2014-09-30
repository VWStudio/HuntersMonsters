/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.popups.win {
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
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.viewmanage.ShowScreenCmd;

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
import starling.text.TextField;

public class WinPopup extends Popup {

    public static const NAME : String = "WinPopup.NAME";

//    public static const SELECT_MONSTER: String = "select_monster_BattleScreen";

    private var _player : LocalPlayer;

    private var _back : Image;
    private var _playButton : ButtonContainer;
    private var _monster : MonsterInfo;
    private var _closeButton : ButtonContainer;
    private var _title : TextField;

    public function WinPopup() {

        _player = App.instance.player;

        super();
    }

    override protected function initialize() : void {

        createFromConfig(_refs.guiConfig.hunt_popup);

        _back = _links["bitmap__bg"];
//        _back.touchable = true;

        _title = _links["title_tf"];

        _closeButton = _links["close_btn"];
        _closeButton.addEventListener(Event.TRIGGERED, handleClose);

        _playButton = _links["play_btn"];
        _playButton.addEventListener(Event.TRIGGERED, handleClose);
        _playButton.text = "Забрать награду";

        _monster = _links.monster;


    }

    private function handleClose(event : Event) : void {


        coreDispatch(App.UPDATE_PROGRESS, NAME);

        coreDispatch(UI.HIDE_POPUP, NAME);
        coreExecute(ShowScreenCmd, MapScreen.NAME);
    }


    override public function update() : void {

        _title.text = data.isWin ? "Победа" : "Поражение";
        _playButton.text = data.isWin ? "Забрать" : "Закрыть";

        _monster.data = App.instance.monster;
        _monster.update();


    }


}
}
