/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.game {
import com.agnither.hunters.model.Chip;
import com.agnither.hunters.model.Field;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Sprite;
import starling.events.Event;

public class FieldView extends AbstractView {

    public static var fieldX: int;
    public static var fieldY: int;
    public static var tileX: int;
    public static var tileY: int;

    private var _field: Field;

    private var _cellsContainer: Sprite;
    private var _chipsContainer: Sprite;

    public function FieldView(refs:CommonRefs, field: Field) {
        _field = field;

        super(refs);
    }

    override protected function initialize():void {
        x = fieldX;
        y = fieldY;

        _chipsContainer = new Sprite();
        addChild(_chipsContainer);

        _cellsContainer = new Sprite();
        addChild(_cellsContainer);

        var l: int = _field.field.length;
        for (var i:int = 0; i < l; i++) {
            var chip: ChipView = new ChipView(_refs, _field.field[i].chip);
            _chipsContainer.addChild(chip);

            var cell: CellView = new CellView(_refs, _field.field[i]);
            _cellsContainer.addChild(cell);
        }

        _field.addEventListener(Field.NEW_CHIP, handleNewChip);
    }

    private function handleNewChip(e: Event):void {
        var chip: ChipView = new ChipView(_refs, e.data as Chip);
        _chipsContainer.addChild(chip);
    }
}
}
