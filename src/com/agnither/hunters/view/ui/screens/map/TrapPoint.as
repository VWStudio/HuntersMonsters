/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.map {
import com.agnither.hunters.App;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.view.ui.popups.traps.TrapSetPopup;
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
                        coreExecute(ShowPopupCmd, TrapSetPopup.NAME, {id: _monsterType.id, level:_monsterType.level, mode: TrapSetPopup.CHECK_MODE, marker: this});
                    }
                    else if (_monsterCaught)
                    {
                        coreExecute(ShowPopupCmd, TrapSetPopup.NAME, {id: _monsterType.id, level:_monsterType.level, mode: TrapSetPopup.REWARD_MODE, marker: this});
                    }
                    else
                    {
                        coreExecute(ShowPopupCmd, TrapSetPopup.NAME, {id: _monsterType.id, level : null, mode: TrapSetPopup.DELETE_MODE, marker: this});
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
        if (!_links["bitmap_common_trap_back"])
        {
            createFromConfig(_refs.guiConfig.common.trapIcon);
        }


        _back = _links["bitmap_common_trap_back"];
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
            App.instance.tick.removeTickCallback(tick);
            var chances : Array = data["chances"];
            var chanceAdd : Number = data["chanceAdd"];

            var max : Number = Math.max.apply(this, chances);
            var chanceToCatch : Number = Math.random() * 100;
            _monsterCaught = (max + chanceAdd) > chanceToCatch;
//            var isCaught : Boolean = Math.random() * (max + chanceAdd);
            trace("max chance", max, chanceAdd, _monsterCaught, chanceToCatch, max + chanceAdd);

            if(_monsterCaught) {

                var chanceSum : Number = chances[0] + chances[1] + chances[2] + chanceAdd * 3;
                var randomVal : Number = Math.random() * chanceSum;
                var caughtMonster : int = -1;
                trace(randomVal, chanceSum);
                for (var i : int = 0; i < chances.length; i++)
                {
                    var ch : Number = chances[i] + chanceAdd;
                    if(ch > randomVal) {
                        caughtMonster = i + 1;
                        break;
                    } else {
                        randomVal -= ch;
                    }
                }
                trace(i, caughtMonster, chances[i], randomVal, chanceSum);

                _monsterCaught = caughtMonster >= 0;
            }

            if (_monsterCaught)
            {
                _time.visible = false;
                _star.visible = true;
                _monsterType = Model.instance.monsters.getMonster(data["id"], caughtMonster)

            }
            else
            {
                _monsterType = Model.instance.monsters.getMonster(data["id"], 1)
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

}
}
