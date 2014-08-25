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

    private var _icon: Image;

    public function DropSlotView(refs: CommonRefs, dropSlot: DropSlot) {
        _dropSlot = dropSlot;
        super(refs);
    }

    override protected function initialize():void {
        createFromCommon(_refs.guiConfig.common.drop);

        _icon = getChildAt(0) as Image;

        _dropSlot.addEventListener(DropSlot.UPDATE, handleUpdate);
        handleUpdate();

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleUpdate(e: Event = null):void {
        if (_dropSlot.content) {
            _icon.visible = true;
            _icon.texture = _refs.gui.getTexture(_dropSlot.content.icon);
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
