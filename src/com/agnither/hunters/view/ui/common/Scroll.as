/**
 * Created by mor on 12.11.2014.
 */
package com.agnither.hunters.view.ui.common
{
import com.agnither.ui.ButtonContainer;

import flash.events.EventDispatcher;

import flash.events.MouseEvent;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.core.Starling;

import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class Scroll extends EventDispatcher
{
    private var _scrollItems : Sprite;
    private var _knob : Sprite;
    private var _up : ButtonContainer;
    private var _down : ButtonContainer;
    private var _back : Sprite;
    private var _hei : Number;
    private var _max : Number;
    private var _visibleArea : Number;
    private var _lines : Number;
    private var _stepPx : Number;
    private var _currentLine : Number = 0;
    private var _total : Number;
    private var _position : Number;
    private var _startPos : Number;
    private var _knobContainer : Sprite;
    private var _maxKnobPosition : Number;
    private var _knobStart : Number;
    public var onChange : Function;
    public function Scroll($scroll : Sprite)
    {
        _scrollItems = $scroll;

        _knob = _scrollItems.getChildByName("handle") as Sprite;
        _up = _scrollItems.getChildByName("up_btn") as ButtonContainer;
        _down = _scrollItems.getChildByName("down_btn") as ButtonContainer;
        _back = _scrollItems.getChildAt(0) as Sprite;
        _back.visible = false;

        _up.touchable = true;
        _up.addEventListener(Event.TRIGGERED, onButton);
        _down.touchable = true;
        _down.addEventListener(Event.TRIGGERED, onButton);
        _knob.touchable = true;
        _knob.getChildAt(0).touchable = true;

        _knob.addEventListener(TouchEvent.TOUCH, onKnob);

        _knobContainer = new Sprite();
        _scrollItems.addChild(_knobContainer);
        _knobContainer.x = _knob.x;
        _knobContainer.y = _knob.y;
        _knobContainer.addChild(_knob);
        _knob.x = _knob.y = 0;

        setHeight(_back.height);
    }

    private function onKnob(event : TouchEvent) : void
    {
        var touchNorm : Touch = event.getTouch(_knob);
        if(touchNorm) {
            Mouse.cursor = MouseCursor.HAND;
        } else {
            Mouse.cursor = MouseCursor.AUTO;
        }


        var touch  : Touch = event.getTouch(_knob, TouchPhase.BEGAN);
        var touchEnd  : Touch = event.getTouch(_knob, TouchPhase.ENDED);
        if(touch) {
            _position = touch.globalY;
            _knobStart = _knob.y;
            startDrag();
        }
        if(touchEnd) {
            _position = touchEnd.globalY;
            endDrag();
        }

    }

    private function endDrag() : void
    {
        _knob.stage.removeEventListener(TouchEvent.TOUCH, onMove);
        var delta : Number = _position - _startPos;
        _currentLine = int((_knobStart + delta) / _stepPx);
        scrollTo(_currentLine);
    }

    private function startDrag() : void
    {
        _startPos = _position;
        _knob.stage.addEventListener(TouchEvent.TOUCH, onMove);
    }

    private function onMove(event : TouchEvent) : void
    {
        var touch : Touch = event.getTouch(_knob.stage, TouchPhase.MOVED);
        if(touch) {
            _position = touch.globalY;
            var delta : Number = _position - _startPos;
            _currentLine = int((_knobStart + delta) / _stepPx);
            scrollTo(_currentLine);
        }
    }

    private function onButton(event : Event) : void
    {
        var btn : ButtonContainer  = event.currentTarget as ButtonContainer;
        if(!btn)  return;
        if(btn) {
            if(btn == _up) {
                scrollTo(_currentLine - 1);
            } else if (btn == _down) {
                scrollTo(_currentLine + 1);
            }
        }
    }

    public function setHeight($val : Number):void {

        _hei = $val;
        _back.height = $val;
        _down.y = _hei - _down.height;
        _maxKnobPosition = _down.y - _knobContainer.y - _knob.height - _down.height;

    }

    public function setScrollParams($total : Number, $visible : Number):void {

        _scrollItems.visible = $total > $visible;

        if(_scrollItems.visible) {
            _total = $total;
            _visibleArea = $visible;
            _max = $total - $visible + 1;

        } else {
            _total = 1;
            _visibleArea = 1;
            _max = 1;
        }


        _stepPx = (_maxKnobPosition) / (_max);

        scrollTo(0);

    }

    private function scrollTo($val : Number) : void
    {


        _currentLine = $val;

        if(_currentLine <= 0) {
            _currentLine = 0;
        }
        if(_currentLine >= _max) {
            _currentLine = _max;
        }

        var newY : Number = _stepPx * _currentLine;
        Starling.juggler.tween(_knob, 0.2, {y : newY /*,onComplete: onEndTween */});


        if(onChange != null) {
            onChange(_currentLine);
        }

    }

}
}
