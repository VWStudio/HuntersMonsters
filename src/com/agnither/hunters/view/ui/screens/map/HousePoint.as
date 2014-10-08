/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.map {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.MonsterVO;
import com.agnither.hunters.model.Match3Game;
import com.agnither.hunters.model.player.Mana;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.popups.house.HousePopup;
import com.agnither.hunters.view.ui.popups.hunt.HuntPopup;
import com.agnither.hunters.view.ui.popups.hunt.HuntStepsPopup;
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

public class HousePoint extends AbstractView {
    private var _back : Image;
    public var territory : String;


    public function HousePoint() {
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
                    coreExecute(ShowPopupCmd, HousePopup.NAME, {id : territory, point : this});
                    break;
            }
        } else
        {
            Mouse.cursor = MouseCursor.AUTO;
        }

    }

    override protected function initialize():void {
        if(!_links["bitmap_icon_bg.png"]) {
            createFromConfig(_refs.guiConfig.common.houseIcon);
        }


        _back = _links["bitmap_icon_bg.png"];
        _back.touchable = true;
        this.touchable = true;

    }


    override public function update() : void {

    }

}
}
