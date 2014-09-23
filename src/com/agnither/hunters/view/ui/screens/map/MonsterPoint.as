/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.map {
import com.agnither.hunters.data.outer.MonsterVO;
import com.agnither.hunters.model.Match3Game;
import com.agnither.hunters.model.player.Mana;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.popups.hunt.HuntPopup;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.viewmanage.ShowPopupCmd;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.display.Image;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class MonsterPoint extends AbstractView {
    private var _back : Image;
    private var _stars : StarsBar;

//    private var _mana: Mana;
//    public function set mana(value: Mana):void {
//        if (_mana) {
//            _mana.removeEventListener(Mana.UPDATE, handleUpdate);
//        }
//        _mana = value;
//        if (_mana) {
//            _mana.addEventListener(Mana.UPDATE, handleUpdate);
//        }
//        handleUpdate();
//    }
//
//    private var _icon: Image;
//    private var _value: TextField;

    public function MonsterPoint() {
        this.addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch(e : TouchEvent) : void {
        e.stopPropagation();
        e.stopImmediatePropagation();

        var touch : Touch = e.getTouch(this);
        if(touch)
        {
            Mouse.cursor = MouseCursor.BUTTON;
            switch (touch.phase)
            {
                case TouchPhase.HOVER :
                    break;
                case TouchPhase.BEGAN :
                    break;
                case TouchPhase.ENDED :
                    coreExecute(ShowPopupCmd, HuntPopup.NAME, MonsterVO.DICT[1]);
//                    dispatchEventWith(UI.SHOW_POPUP, true, MonsterVO.DICT[1]);
//                    dispatchEventWith(UI.SHOW_POPUP, true, MonsterVO.DICT[1]);
//                    dispatchEventWith(Match3Game.START_GAME, true, MonsterVO.DICT[1]);
                    break;
            }
        } else
        {
            Mouse.cursor = MouseCursor.AUTO;
        }

    }

    override protected function initialize():void {

        _back = _links["bitmap_icon_bg.png"];
        _back.touchable = true;
        this.touchable = true;

        _stars = _links.stars;

    }


    override public function update() : void {

        _stars.setProgress(Math.random() * 4);

    }
}
}
