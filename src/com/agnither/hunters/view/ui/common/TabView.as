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

    private var _name: String;

    private var _tab: Button;
    private var _select: Sprite;

    public function TabView(refs:CommonRefs, name: String) {
        _name = name;
        super(refs);
    }

    override protected function initialize():void {
        createFromCommon(_refs.guiConfig.common.tab1);

        _tab = _links.tab_btn;
        _tab.addEventListener(Event.TRIGGERED, handleClick);
        _tab.text = _name;

        _select = _links.select;
    }

    private function handleClick(e: Event):void {
        dispatchEventWith(TAB_CLICK);
    }
}
}
