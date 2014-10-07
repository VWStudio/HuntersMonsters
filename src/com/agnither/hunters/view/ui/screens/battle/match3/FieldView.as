/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.match3 {
import com.agnither.hunters.model.match3.Chip;
import com.agnither.hunters.model.match3.Field;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.cemaprjl1.core.coreAddListener;

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
    private var _initializedField : Boolean = false;

    public function FieldView() {
    }

    override protected function initialize():void {
        x = fieldX;
        y = fieldY;

//        /*
//         hack to avoid an exception in
//         handleNewChip -> new ChipView(e.data as Chip) -> initialize on addedToStage;
//         there is no cell in chip
//         FIXED by _initializeField flag
//         */
//        _field.removeEventListener(Field.ADD_CHIP, handleNewChip);




        _chipsContainer = new Sprite();
        addChild(_chipsContainer);

        _cellsContainer = new Sprite();
        _cellsContainer.addEventListener(TouchEvent.TOUCH, handleTouch);
        addChild(_cellsContainer);


    }

    private function handleNewChip(chip : Chip):void {
        if(!_initializedField) return;

        var chipView: ChipView = new ChipView(chip);
        _chipsContainer.addChild(chipView);
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

    public function set field(value : Field) : void {


        _field = value;

        _initializedField = false;
        var l: int = _field.field.length;
        for (var i:int = 0; i < l; i++) {
            var chip: ChipView = new ChipView(_field.field[i].chip);
            _chipsContainer.addChild(chip);

            var cell: CellView = new CellView(_field.field[i]);
            _cellsContainer.addChild(cell);
        }
        _initializedField = true;
        coreAddListener(Field.ADD_CHIP, handleNewChip);
    }

    public function clear() : void {

        removeEventListener(Field.ADD_CHIP, handleNewChip);

        while(_chipsContainer.numChildren) {
            var chip : ChipView = _chipsContainer.removeChildAt(0) as ChipView;
            chip.destroy();
        }

        while(_cellsContainer.numChildren) {
            var cell : CellView = _cellsContainer.removeChildAt(0) as CellView;
            chip.destroy();
        }

    }
}
}
