/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.popups.hunt {
import com.agnither.hunters.data.outer.MonsterVO;
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
import starling.text.TextField;

public class HuntStepsPopup extends Popup {

    public static const NAME : String = "com.agnither.hunters.view.ui.popups.hunt.HuntStepsPopup";

//    public static const SELECT_MONSTER: String = "select_monster_BattleScreen";

    private var _player : LocalPlayer;

    private var _back : Image;
    private var _playButton : ButtonContainer;
    private var _closeButton : ButtonContainer;
    private var _monsterContainer : Sprite;
    private var _playerIcon : Image;
    private var _arrow1 : Sprite;
    private var _arrow2 : Sprite;
    private var _monsters : Vector.<MonsterVO>;
    public static const START_MODE : String = "HuntStepsPopup.START_MODE";
    public static const CONTINUE_MODE : String = "HuntStepsPopup.CONTINUE_MODE";
    public static const WIN_MODE : String = "HuntStepsPopup.WIN_MODE";
    public static const LOSE_MODE : String = "HuntStepsPopup.LOSE_MODE";
    private var _title : TextField;
    private var _rewardTF : TextField;

    public function HuntStepsPopup() {

        _player = App.instance.player;

        super();
    }

    override protected function initialize() : void {

        createFromConfig(_refs.guiConfig.hunt_steps);


        _back = _links["bitmap__bg"];
        _closeButton = _links["close_btn"];
        _closeButton.addEventListener(Event.TRIGGERED, handleClose);

        _title = _links["title_tf"];

        _playButton = _links["play_btn"];
        _playButton.addEventListener(Event.TRIGGERED, handlePlay);
        _playButton.text = "Напасть";

        _playerIcon = _links["bitmap_chip_2.png"];
        _arrow1 = _links["arrow1"];
        _arrow1.visible = false;
        _arrow2 = _links["arrow2"];
        _arrow2.visible = false;
        _playerIcon.visible = false;

        _rewardTF = _links["rewawrd_tf"];


        _monsterContainer = new Sprite();
        addChild(_monsterContainer);

    }

    private function handleClose(event : Event) : void {
        coreDispatch(UI.HIDE_POPUP, NAME);
    }

    private function handlePlay(event : Event) : void {

        switch (data.mode) {
            case START_MODE:
                coreDispatch(UI.HIDE_POPUP, NAME);
                coreDispatch(Match3Game.START_GAME, _monsters[App.instance.chestStep]);
                break;
            case CONTINUE_MODE:
                coreDispatch(UI.HIDE_POPUP, NAME);
                coreDispatch(Match3Game.START_GAME, _monsters[App.instance.chestStep]);
                break;
            case WIN_MODE:
                coreDispatch(UI.HIDE_POPUP, NAME);
                coreDispatch(MapScreen.REMOVE_CHEST, App.instance.chest);
                break;
            case LOSE_MODE:
                coreDispatch(UI.HIDE_POPUP, NAME);
                coreDispatch(MapScreen.REMOVE_CHEST, App.instance.chest);


                break;
        }



    }


    override public function update() : void {

        _monsters = App.instance.steps;
//        _monsters = data as Vector.<MonsterVO>;
        _monsterContainer.removeChildren();
        _monsterContainer.y = 70;
        for (var i : int = 0; i < _monsters.length; i++)
        {
            var mon : MonsterInfo = new MonsterInfo();
            mon.createFromCommon(_refs.guiConfig.common.monster);
            mon.data = _monsters[i];
            _monsterContainer.addChild(mon);
            mon.update();
            mon.x = i * 250;


        }
        _arrow1.visible = _monsters.length > 1;
        _arrow2.visible = _monsters.length > 2;
        _arrow1.y = 150;
        _arrow2.y = 150;
        _monsterContainer.x = (_back.getBounds(this).width - _monsterContainer.getBounds(this).width) * 0.5;

        _arrow1.x = _monsterContainer.x + 200;
        _arrow2.x = _arrow1.x + 250;

        _playerIcon.visible = true;
        _playerIcon.y = 250;
        _playerIcon.x = _monsterContainer.x + 50 + App.instance.chestStep * 250;

        _closeButton.visible = false;
        switch (data.mode) {
            case START_MODE:
                _rewardTF.text = "1000 золота";
                _closeButton.visible = true;
                _title.text = "Победи хранителей сундука";
                _playButton.text = "Напасть";
                break;
            case CONTINUE_MODE:
                _title.text = "Победи хранителей сундука";
                _playButton.text = "Следующий";
                break;
            case WIN_MODE:
                _title.text = "Ты победил";
                _playButton.text = "Забрать";
                break;
            case LOSE_MODE:
                _title.text = "Ты проиграл";
                _rewardTF.text = "Выигрыша нет";
                _playButton.text = "Выйти";
                break;
        }

    }


}
}
