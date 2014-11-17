/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.model.match3 {
import com.agnither.hunters.model.*;

import flash.geom.Point;

import starling.events.EventDispatcher;

public class Cell extends EventDispatcher {

    public static const SELECT: String = "select_Cell";
    public static const DAMAGE: String = "damage_Cell";

    private var _x: int;
    public function get x():int {
        return _x;
    }

    private var _y: int;
    public function get y():int {
        return _y;
    }

    private var _pos: Point;
    public function get position():Point {
        return _pos;
    }

    private var _chip: Chip;
    public function get chip():Chip {
        return _chip;
    }

    public function get type():String {
        return _chip ? _chip.type : null;
    }

    public function get fillable():Boolean {
        return !_chip;
    }

    private var _selected: Boolean;
    public function get selected():Boolean {
        return _selected;
    }

    public function get matchable():Boolean {
        return chip && chip.matchable;
    }

    private var _match: Match;
    public function get match():Match {
        return _match;
    }
    public function set match(value: Match):void {
        _match = value;
    }

    public function Cell(x: int, y: int) {
        _x = x;
        _y = y;
        _pos = new Point(_x, _y);
    }

    public function setChip(chip: Chip, swap: Boolean = false, silent: Boolean = false):void {
        _chip = chip;
        if (_chip) {
            _chip.place(this);

            if (!silent) {
                _chip.move(swap);
            }
        }
    }

    public function select(value: Boolean):void {
        _selected = value;
        dispatchEventWith(SELECT);
    }

    public function swap(cell: Cell, silent: Boolean = false):void {
        var tempChip: Chip = cell.chip;
        cell.setChip(_chip, true, silent);
        setChip(tempChip, true, silent);
    }

    public function fall(cell: Cell):void {
        var tempChip: Chip = cell.chip;
        cell.setChip(_chip, false);
        setChip(tempChip, false);
    }

    public function showDamage(value: int):void {
        dispatchEventWith(DAMAGE, false, value);
    }

    public function clear():void {
        if (_chip) {
            _chip.place(null);
            _chip.kill();
            _chip = null;
        }
    }


    public function toString() : String {
        return "[Cell("+_x+":"+_y+")]";
    }
}
}
