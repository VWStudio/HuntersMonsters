/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.map {
import com.agnither.hunters.App;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.player.Mana;
import com.agnither.hunters.model.player.Territory;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.popups.hunt.HuntPopup;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.utils.Formatter;
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
    private var _monsterType : MonsterVO;
    private var _pathTime : Number = -1;
    private var _timeleft : Number = -1;
    private var _distance : Number = 0;
    private var _targetPoint : Point;
    private var _currentPoint : Point;
    private var _time : TextField;
    private var _lifetime : Number;
    public static const STARS_UPDATE : String = "MonsterPoint.STARS_UPDATE";
    private var _allowCount : Boolean = true;
    private var _territory : Territory;
    private var _territoryRect : Rectangle;
    private var _image : Image;

    public function MonsterPoint() {

        createFromConfig(_refs.guiConfig.common.monsterIcon);

        _back = _links["bitmap_monster_icon_1"];
        _back.touchable = true;
        this.touchable = true;

        _time = _links["time_tf"];
        removeChild(_time);

        _image = new Image(_refs.gui.getTexture("level_1"));
        addChild(_image);
        _image.x = 5;
        _image.y = -20;

        this.addEventListener(TouchEvent.TOUCH, handleTouch);

    }

    private function handleTouch(e : TouchEvent) : void {
        if(App.instance.trapMode || Model.instance.screenMoved) {
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
                    e.stopPropagation();
                    e.stopImmediatePropagation();
                    Model.instance.currentMonsterPoint = this;
                    coreExecute(ShowPopupCmd, HuntPopup.NAME, _monsterType);
                    break;
            }
        } else
        {
            Mouse.cursor = MouseCursor.AUTO;
        }

    }

    override public function update() : void {
        _lifetime = (_territory.area.lifemax + (_territory.area.lifemin - _territory.area.lifemax) * Math.random())*1000;



    }

    public function tick($delta : Number) : void {
        if(!_allowCount) return;
        if(_lifetime > 0) {
            _lifetime -= $delta;
//            _time.text = Formatter.msToHHMMSS(_lifetime);
        } else {
            if(Model.instance.state == MapScreen.NAME) {
                _territory.deletePoint(this);
            }
        }

        if(!Model.instance.isMap()) {
            return;
        }

        if(_monsterType.speed == 0) {
            return;
        }

        if(_timeleft <= 0) {
            _targetPoint = _territory.getPoint();
            _currentPoint = new Point(this.x, this.y);
            _distance = Point.distance(_targetPoint, _currentPoint);
            _pathTime = _distance * _monsterType.speed; // if speed = 100 means that distance in 10 px will be reached in 1 second
            _timeleft = _pathTime;
        } else {
            _timeleft -= $delta;
            var newPos : Point = Point.interpolate(_currentPoint, _targetPoint, _timeleft / _pathTime);
            this.x = newPos.x;
            this.y = newPos.y;
        }
    }


    public function get monsterType() : MonsterVO {
        return _monsterType;
    }

    public function set monsterType(value : MonsterVO) : void {
        _monsterType = value;
        _territory = Model.instance.territories[_monsterType.id];
        _territoryRect = _territory.rect;
        _back.texture = _refs.gui.getTexture(_territory.area.icon);
        _back.readjustSize();
        _back.y = -_back.height + 10;

        _image.texture = _refs.gui.getTexture("level_"+value.level);
        _image.readjustSize();

        var pt : Point = _monsterType.speed > 0 ? _territory.getPoint() : _territory.getPoint(100); // not moved point will be closer to center, max 145;
        this.x = pt.x;
        this.y = pt.y;
    }

    public function count($val : Boolean) : void {
        _allowCount = $val;
    }
}
}
