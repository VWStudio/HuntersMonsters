/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.map {
import com.agnither.hunters.App;
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

import flash.geom.Point;
import flash.geom.Rectangle;

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
    private var _monsterType : MonsterVO;
    private var _pathTime : Number = -1;
    private var _timeleft : Number = -1;
    private var _distance : Number = 0;
    private var _targetPoint : Point;
    private var _currentPoint : Point;

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
        if(App.instance.trapMode) {
            return;
        }

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
                    coreExecute(ShowPopupCmd, HuntPopup.NAME, _monsterType);
//                    coreExecute(ShowPopupCmd, HuntPopup.NAME, MonsterVO.DICT[1]);
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
        if(!_links["bitmap_icon_bg.png"]) {
            createFromConfig(_refs.guiConfig.common.monsterIcon);
        }


        _back = _links["bitmap_icon_bg.png"];
        _back.touchable = true;
        this.touchable = true;

        _stars = _links.stars;

    }


    override public function update() : void {

        _stars.setProgress(App.instance.monstersResults[_monsterType.id]);

        App.instance.tick.addTickCallback(tick);

    }

    private function tick($delta : Number) : void {
        if(_timeleft <= 0) {
            var area : Rectangle = App.instance.monsterAreas[_monsterType.id];
            _targetPoint = new Point(area.x + area.width * Math.random(), area.y + area.height * Math.random());
            _currentPoint = new Point(this.x, this.y);
            _distance = Point.distance(_targetPoint, _currentPoint);
            _pathTime = _distance * 75; // distance in 10 px will be reached in 1 second
            _timeleft = _pathTime;
        } else {
            _timeleft -= $delta;
            var newPos : Point = Point.interpolate(_currentPoint, _targetPoint, _timeleft / _pathTime);
            this.x = newPos.x;
            this.y = newPos.y;
        }

    }


    override public function destroy() : void {
        App.instance.tick.removeTickCallback(tick)
    }

    public function get monsterType() : MonsterVO {
        return _monsterType;
    }

    public function set monsterType(value : MonsterVO) : void {
        _monsterType = value;
    }
}
}
