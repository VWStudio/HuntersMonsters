/**
 * Created by agnither on 22.08.14.
 */
package com.agnither.hunters.view.ui.common {
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;

public class TabView extends AbstractView {

    public static const TAB_CLICK: String = "tab_click_TabView";

    public function set label(value: String):void {
        _tab.text = value;
    }

    private var _tab: Button;
    private var _select: Sprite;

    public function TabView(refs:CommonRefs) {
        super(refs);
    }

    override protected function initialize():void {
        _tab = _links.tab_btn;
        _tab.addEventListener(Event.TRIGGERED, handleClick);

        _select = _links.select;
    }

    private function handleClick(e: Event):void {
        dispatchEventWith(TAB_CLICK);
    }
}
}
