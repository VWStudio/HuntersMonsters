/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.game {
import com.agnither.hunters.model.Cell;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import flash.geom.Point;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class CellView extends AbstractView {

    public static const SELECT: String = "select_ChipView";

    private var _cell: Cell;

    private var _select: Sprite;

    public function CellView(refs:CommonRefs, cell: Cell) {
        _cell = cell;

        super(refs);
    }

    override protected function initialize():void {
        createFromCommon(_refs.guiConfig.common.chip);

        _select = _links.select;

        x = _cell.x * FieldView.tileX;
        y = _cell.y * FieldView.tileY;

        _cell.addEventListener(Cell.SELECT, handleSelect);
        handleSelect(null);

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    override public function hitTest(localPoint: Point, forTouch: Boolean = false):DisplayObject {
        if (forTouch && getBounds(this).containsPoint(localPoint)) {
            return this;
        }
        return super.hitTest(localPoint, forTouch);
    }

    private function handleSelect(e: Event):void {
        _select.visible = _cell.selected;
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(this, TouchPhase.BEGAN);
        if (touch) {
            dispatchEventWith(SELECT, true, _cell);
        }
    }
}
}
