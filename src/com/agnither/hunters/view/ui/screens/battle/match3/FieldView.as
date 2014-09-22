/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.match3 {
import com.agnither.hunters.model.match3.Chip;
import com.agnither.hunters.model.match3.Field;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class FieldView extends AbstractView {

    public static const SELECT_CELL: String = "select_cell_FieldView";

    public static var fieldX: int;
    public static var fieldY: int;
    public static var tileX: int;
    public static var tileY: int;

    private var _field: Field;

    private var _cellsContainer: Sprite;
    private var _chipsContainer: Sprite;

    private var _rollOver: CellView;

    public function FieldView(field: Field) {
        _field = field;
    }

    override protected function initialize():void {
        x = fieldX;
        y = fieldY;

        _chipsContainer = new Sprite();
        addChild(_chipsContainer);

        _cellsContainer = new Sprite();
        _cellsContainer.addEventListener(TouchEvent.TOUCH, handleTouch);
        addChild(_cellsContainer);

        var l: int = _field.field.length;
        for (var i:int = 0; i < l; i++) {
            var chip: ChipView = new ChipView(_field.field[i].chip);
            _chipsContainer.addChild(chip);

            var cell: CellView = new CellView(_field.field[i]);
            _cellsContainer.addChild(cell);
        }

        _field.addEventListener(Field.ADD_CHIP, handleNewChip);
    }

    private function handleNewChip(e: Event):void {
        var chip: ChipView = new ChipView(e.data as Chip);
        _chipsContainer.addChild(chip);
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(_cellsContainer);
        if (touch) {
            var cell: CellView = _cellsContainer.hitTest(touch.getLocation(_cellsContainer)) as CellView;
            if (cell) {
                if (touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED && _rollOver && _rollOver != cell) {
                    _rollOver = cell;
                    dispatchEventWith(SELECT_CELL, true, _rollOver.cell);

                    if (touch.phase != TouchPhase.BEGAN) {
                        _rollOver = null;
                    }
                } else if (touch.phase == TouchPhase.ENDED) {
                    _rollOver = null;
                }
            }
        }
    }
}
}
