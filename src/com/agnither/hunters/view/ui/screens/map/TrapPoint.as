/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.map {
import com.agnither.hunters.App;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.view.ui.screens.battle.monster.TrapPopup;
import com.agnither.ui.AbstractView;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.utils.Formatter;
import com.cemaprjl.viewmanage.ShowPopupCmd;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class TrapPoint extends AbstractView {
    private var _back : Image;
    private var _monsterType : MonsterVO;
    private var _time : TextField;
    private var _timeleft : Number;
    private var _star : Sprite;
    private var _monsterCaught : Boolean = false;

    public function TrapPoint() {
        this.addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch(e : TouchEvent) : void {
        e.stopPropagation();
        e.stopImmediatePropagation();
        if (App.instance.trapMode)
        {
            return;
        }

        var touch : Touch = e.getTouch(this);
        if (touch)
        {
            Mouse.cursor = MouseCursor.BUTTON;
            switch (touch.phase)
            {
                case TouchPhase.HOVER :
                    break;
                case TouchPhase.BEGAN :
                    break;
                case TouchPhase.ENDED :
                    if (_timeleft > 0)
                    {
                        coreExecute(ShowPopupCmd, TrapPopup.NAME, {id: _monsterType.id, mode: TrapPopup.CHECK_MODE, marker: this});
                    }
                    else if (_monsterCaught)
                    {
                        coreExecute(ShowPopupCmd, TrapPopup.NAME, {id: _monsterType.id, mode: TrapPopup.REWARD_MODE, marker: this});
                    }
                    else
                    {
                        coreExecute(ShowPopupCmd, TrapPopup.NAME, {id: _monsterType.id, mode: TrapPopup.DELETE_MODE, marker: this});
                    }
                    break;
            }
        }
        else
        {
            Mouse.cursor = MouseCursor.AUTO;
        }

    }


    override public function destroy() : void {

        App.instance.tick.removeTickCallback(tick);

    }

    override protected function initialize() : void {
        if (!_links["bitmap_trap_back"])
        {
            createFromConfig(_refs.guiConfig.common.trapIcon);
        }


        _back = _links["bitmap_trap_back"];
        _back.touchable = true;
        this.touchable = true;

        _time = _links.time_tf;
        _time.text = "";

        _star = _links.star;
        _star.visible = false;

    }


    public function start() : void {
        if (_timeleft > 0)
        {
            App.instance.tick.addTickCallback(tick);
        }
        else
        {
            _monsterCaught = data.chance > Math.random();
            if (_monsterCaught)
            {
                _time.visible = false;
                _star.visible = true;
            }
            else
            {
                _time.visible = true;
                _time.text = "X";
            }
        }
    }

    private function tick($delta : Number) : void {

        _timeleft -= $delta;
        _time.text = Formatter.msToHHMMSS(_timeleft);
        if (_timeleft <= 0)
        {
            App.instance.tick.removeTickCallback(tick);
            start();
        }


    }

    override public function update() : void {

        _timeleft = data["time"] * 1000;
        _time.text = int(data["time"] / 3600).toString();
        start();

    }

    public function get monsterType() : MonsterVO {
        return _monsterType;
    }

    public function set monsterType(value : MonsterVO) : void {
        _monsterType = value;
    }
}
}
