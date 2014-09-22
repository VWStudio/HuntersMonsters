/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.match3 {
import com.agnither.hunters.model.match3.Chip;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import flash.geom.Rectangle;

import starling.core.Starling;
import starling.display.Image;
import starling.events.Event;

public class ChipView extends AbstractView {

    public static const KILL: String = "kill_GemView";

    private var _chip: Chip;

    private var _view: Image;

    private var _falling: int;

    public function ChipView(chip: Chip) {
        _chip = chip;
    }

    override protected function initialize():void {
        _view = new Image(_refs.gui.getTexture(_chip.icon));
        _view.pivotX = _view.width/2;
        _view.pivotY = _view.height/2;
        _view.x = _view.pivotX;
        _view.y = _view.pivotY;
        addChildAt(_view, 0);

        x = _chip.cell.x * FieldView.tileX;
        y = _chip.cell.y * FieldView.tileY;
        _falling = 0;

        if (_chip.fall) {
            clipRect = new Rectangle(0, 0, FieldView.tileX, FieldView.tileY);
            innerFall();
        }

        _chip.addEventListener(Chip.MOVE, handleMove);
        _chip.addEventListener(Chip.HINT, handleHint);
        _chip.addEventListener(Chip.KILL, handleKill);
    }

    private function innerFall():void {
        _view.y -= FieldView.tileY;
        _falling++;
        Starling.juggler.tween(_view, 0.05, {y: _view.y+FieldView.tileY, onComplete: handleFall});
    }

    private function handleMove(e: Event = null):void {
        var newX: int = _chip.cell.x * FieldView.tileX;
        var newY: int = _chip.cell.y * FieldView.tileY;
        if (e) {
            if (e.data) {
                parent.addChild(this);
                Starling.juggler.tween(this, 0.15, {x: newX, y: newY});
            } else if (newY > y) {
                _falling++;
                Starling.juggler.tween(this, 0.06, {x: newX, y: newY, onComplete: handleFall});
            }
        }
    }

    private function handleFall():void {
        if (clipRect) {
            clipRect = null;
        }

        _falling--;
    }

    private function handleHint(e: Event):void {
        parent.addChild(this);
    }

    private function handleKill(e: Event):void {
        dispatchEventWith(KILL, false, _chip);

        Starling.juggler.tween(_view, 0.25, {scaleX: 0, scaleY: 0, onComplete: destroy});
    }

    override public function destroy():void {
        Starling.juggler.removeTweens(_view);

        removeEventListeners(KILL);

        if (_chip) {
            _chip.removeEventListener(Chip.MOVE, handleMove);
            _chip.removeEventListener(Chip.HINT, handleHint);
            _chip.removeEventListener(Chip.KILL, handleKill);
            _chip = null;
        }

        removeChild(_view, true);
        _view = null;

        removeFromParent(true);

        super.destroy();
    }
}
}
