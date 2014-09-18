/**
 * Created by agnither on 22.08.14.
 */
package com.agnither.hunters.view.ui.common {
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class TabView extends AbstractView {

    public static const TAB_CLICK: String = "tab_click_TabView";

    public function set label(value: String):void {
        _label.text = value;
    }

    private var _label: TextField;
    private var _select: Sprite;

    public function TabView() {
    }

    override protected function initialize():void {
        _label = _links.label_tf;

        _select = _links.select;

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(this, TouchPhase.BEGAN);
        if (touch) {
            dispatchEventWith(TAB_CLICK);
        }
    }
}
}
