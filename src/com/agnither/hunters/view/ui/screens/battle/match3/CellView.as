/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.match3 {
import com.agnither.hunters.model.match3.Cell;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import flash.geom.Point;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class CellView extends AbstractView {

    private var _cell: Cell;
    public function get cell():Cell {
        return _cell;
    }

    private var _select: Sprite;
    private var _damage: TextField;

    public function CellView(refs:CommonRefs, cell: Cell) {
        _cell = cell;

        super(refs);
    }

    override protected function initialize():void {
        createFromCommon(_refs.guiConfig.common.cell);

        _select = _links.select;

        _damage = _links.damage_tf;
        _damage.visible = false;

        x = _cell.x * FieldView.tileX;
        y = _cell.y * FieldView.tileY;

        _cell.addEventListener(Cell.SELECT, handleSelect);
        handleSelect(null);
    }

    override public function hitTest(localPoint: Point, forTouch: Boolean = false):DisplayObject {
        if (getBounds(this).containsPoint(localPoint)) {
            return this;
        }
        return super.hitTest(localPoint, forTouch);
    }

    private function handleSelect(e: Event):void {
        _select.visible = _cell.selected;
    }
}
}