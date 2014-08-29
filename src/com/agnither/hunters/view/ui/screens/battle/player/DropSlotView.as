/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.drop.DropSlot;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class DropSlotView extends AbstractView {

    private var _dropSlot: DropSlot;
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

    public function DropSlotView(refs: CommonRefs) {
        super(refs);
    }

    override protected function initialize():void {
        _icon = getChildAt(0) as Image;

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
        var touch: Touch = e.getTouch(this, TouchPhase.HOVER);
        if (touch) {
            // TODO: drop tooltip
//            dispatchEventWith(DROP_HOVER, true, _dropSlot.content)
        }
    }
}
}
