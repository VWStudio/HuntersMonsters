/**
 * Created by agnither on 22.08.14.
 */
package com.agnither.hunters.view.ui.common {
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import flash.ui.Mouse;

import flash.ui.MouseCursor;

import starling.display.Image;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class TabView extends AbstractView {

    public static const TAB_CLICK: String = "tab_click_TabView";

    public function get label(): String {
        return _label.text;
    }

    public function set label(value: String):void {
        _label.text = value;
    }

    private var _label: TextField;
    private var _select: Sprite;
    private var _back : Image;

    public function TabView() {
    }

    override protected function initialize():void {
        _label = _links.label_tf;

        _select = _links.select;

        _back = _links.bitmap_common_back;

        touchable = true;
        _back.touchable = true;

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch(e: TouchEvent):void {
//        trace("handleTouch TAB");
        var touch: Touch = e.getTouch(this);
//        var touch: Touch = e.getTouch(this, TouchPhase.BEGAN);
        if (touch) {
            Mouse.cursor = MouseCursor.BUTTON;
            if(touch.phase == TouchPhase.BEGAN) {
                dispatchEventWith(TAB_CLICK);
            }
        } else {
            Mouse.cursor = MouseCursor.AUTO;
        }
    }

    public function setIsSelected($tab : TabView) : void {
        _select.visible = $tab == this;
    }

}
}
