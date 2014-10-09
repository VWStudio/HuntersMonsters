/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.drop.DropSlot;
import com.agnither.hunters.model.player.drop.GoldDrop;
import com.agnither.hunters.model.player.drop.ItemDrop;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import flash.geom.Point;

import starling.display.Image;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class DropSlotView extends AbstractView {

    private var _dropSlot: DropSlot;
    public static const SHOW_TOOLTIP : String = "DropSlotView.SHOW_TOOLTIP";
    public static const HIDE_TOOLTIP : String = "DropSlotView.HIDE_TOOLTIP";
    public function set drop(value: DropSlot):void {
        if (_dropSlot) {
            _dropSlot.removeEventListener(DropSlot.UPDATE, handleUpdate);
        }
        _dropSlot = value;
        if (_dropSlot) {
            _dropSlot.addEventListener(DropSlot.UPDATE, handleUpdate);
        }
        handleUpdate();
    }

    private var _icon: Image;
    private var _touched : Boolean = false;

    public function DropSlotView() {
    }

    override protected function initialize():void {
        _icon = getChildAt(0) as Image;
        this.touchable = true;
        _icon.touchable = true;
        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleUpdate(e: Event = null):void {
        if (_dropSlot.content) {
            _icon.texture = _refs.gui.getTexture(_dropSlot.content.icon);
            _icon.visible = true;
        } else {
            _icon.visible = false;
        }
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(this);


        if (touch == null) {
            _touched = false;
            coreDispatch(DropSlotView.HIDE_TOOLTIP);
        } else if(touch.phase == TouchPhase.HOVER) {
            if(!_touched) {
                coreDispatch(DropSlotView.SHOW_TOOLTIP, {content : _dropSlot.content, item : this, pos : new Point(touch.globalX, touch.globalY)});
                _touched = true;
            }
        }
    }
}
}
