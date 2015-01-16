/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.popups.hunt {
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.common.MonsterInfo;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.hunters.view.ui.popups.monsters.TamedMonsterView;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Popup;
import com.cemaprjl.core.coreDispatch;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.display.Image;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class HuntPopup extends Popup {

    public static const NAME : String = "HuntPopup.NAME";

//    public static const SELECT_MONSTER: String = "select_monster_BattleScreen";

    private var _back : Image;
    private var _playButton : ButtonContainer;
    private var _title : TextField;
    private var _monster : MonsterInfo;
    private var _closeButton : ButtonContainer;
    private var _stars3 : TextField;
    private var _stars2 : TextField;
    private var _stars1 : TextField;

    public function HuntPopup() {

        super();
    }

    override protected function initialize() : void {

        createFromConfig(_refs.guiConfig.hunt_popup);

        _title = _links["title_tf"];

        _back = _links["bitmap_common_back"];
        _closeButton = _links["close_btn"];
        _closeButton.addEventListener(Event.TRIGGERED, handleClose);


        _playButton = _links["play_btn"];
        _playButton.addEventListener(Event.TRIGGERED, handlePlay);
        _playButton.text = "Охотиться";

        _stars3 = _links["stars3_tf"];
        _stars2 = _links["stars2_tf"];
        _stars1 = _links["stars1_tf"];

        _stars1.visible = false;
        _stars2.visible = false;
        _stars3.visible = false;

        _monster = _links.monster;
        _monster.addEventListener(TouchEvent.TOUCH, onTouchMonster);
        _monster.touchable = true;

    }
    private function onTouchMonster(e : TouchEvent) : void
    {
        var target: MonsterInfo = e.currentTarget as MonsterInfo;
        var touch: Touch = e.getTouch(target);
        if (touch) {
            Mouse.cursor = MouseCursor.BUTTON;
            if(touch.phase == TouchPhase.HOVER) {
                coreDispatch(ItemView.HOVER, target, target.item);
            }
        } else {
            coreDispatch(ItemView.HOVER_OUT);
            Mouse.cursor = MouseCursor.AUTO;
        }
    }
    override protected function handleClose(event : Event) : void {
        Model.instance.currentMonsterPoint = null;
        coreDispatch(UI.HIDE_POPUP, NAME);
    }

    private function handlePlay(event : Event) : void {

        Model.instance.match3mode = Match3Game.MODE_REGULAR; //
//        Model.instance.currentMonsterPoint.count(false);
        coreDispatch(UI.HIDE_POPUP, NAME);
        coreDispatch(Match3Game.START_GAME, data);
    }


    override public function update() : void {

        //_monster.data = Model.instance.monster;
        //_monster.hideInfo = true;
        //_monster.update();
        //_title.text = Locale.getString(_monster.data.id);

        _monster.data = data;
        _monster.update();
        _title.text = Locale.getString(_monster.data.id) + " "+_monster.data.level+ "ур";;
        _stars3.text = _monster.monster.stars[0];
        _stars2.text = _monster.monster.stars[1];
        _stars1.text = _monster.monster.stars[2];

    }


}
}
