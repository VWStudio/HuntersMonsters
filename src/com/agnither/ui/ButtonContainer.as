/**
 * Created by agnither on 08.06.14.
 */
package com.agnither.ui {
import starling.display.Button;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class ButtonContainer extends Button {

    private var _icon: Sprite;
    public function set icon(value: Sprite):void {
        _icon = value;
    }

    override public function set x(value: Number):void {
        if (_icon) {
            _icon.x += value - x;
        }
        super.x = value;
    }
    override public function set y(value: Number):void {
        if (_icon) {
            _icon.y += value - y;
        }
        super.y = value;
    }

    override public function set visible(value: Boolean):void {
        super.visible = value;
        if (_icon) {
            _icon.visible = value;
        }
    }

    private var _enabledState: Texture;
    private var _disabledState: Texture;
    override public function set enabled(value: Boolean):void {
        upState = value ? _enabledState : _disabledState;
        super.enabled = value;
    }

    public function ButtonContainer(enabledState:Texture, text:String = "", downState:Texture = null, disabledState: Texture = null) {
        _enabledState = enabledState;
        _disabledState = disabledState;
        super(_enabledState, text, downState);
        scaleWhenDown = 1;
        alphaWhenDisabled = 1;

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(this, TouchPhase.BEGAN);
        if (touch) {
//            dispatchEventWith(AppController.COMMAND, true, [ButtonPressCommand, enabled]);
        }
    }
}
}
