/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 05.06.13
 * Time: 13:06
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.ui {
import com.agnither.hunters.view.ui.UI;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import starling.display.DisplayObject;
import starling.events.Event;

public class Popup extends AbstractView {

    public static const OPEN: String = "open_Popup";
    public static const CLOSE: String = "close_Popup";

    private var _darkened: Boolean = true;
    private var _popup_closeButton : DisplayObject;
    public function get darkened():Boolean {
        return _darkened;
    }

    public var isActive : Boolean = false;

    public function Popup() {
        super();
    }

    public function handleCloseButton($cb : DisplayObject):void {
        if($cb == null) return;

        _popup_closeButton = $cb;
        _popup_closeButton.touchable = true;
        _popup_closeButton.addEventListener(Event.TRIGGERED, handleClose);

    }

    protected function handleClose(e: Event):void {
        coreDispatch(UI.HIDE_POPUP, (this as Object).constructor["NAME"]);
    }

//    override public function open():void {
//        dispatchEventWith(OPEN);
//    }

//    public function forceClose():void {
//
//    }

    override public function destroy():void {
        super.destroy();
    }

    public function set darkened(value : Boolean) : void {
        _darkened = value;
    }
}
}
