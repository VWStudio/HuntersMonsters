/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.model.match3 {
import com.agnither.hunters.data.ChipVO;
import com.agnither.hunters.data.ChipVO;

import starling.events.EventDispatcher;

public class Chip extends EventDispatcher {

    public static const UPDATE: String = "update_Chip";
    public static const MOVE: String = "move_Chip";
    public static const HINT: String = "hint_Chip";
    public static const KILL: String = "kill_Chip";

    private var _data: ChipVO;
    public function get type():String {
        return _data.name;
    }

    public function get icon():String {
        return _data.picture;
    }

    private var _cell: Cell;
    public function get cell():Cell {
        return _cell;
    }

    private var _fall: Boolean;
    public function get fall():Boolean {
        return _fall;
    }

    public function get matchable():Boolean {
        return true;
    }

    public function get movable():Boolean {
        return true;
    }

    public function get allowShuffle():Boolean {
        return movable;
    }

    public function Chip(type: String, fall: Boolean) {
        _data = ChipVO.DICT[type];
        _fall = fall;
    }

    public function place(cell: Cell):void {
        _cell = cell;
    }

    public function move(swap: Boolean = false):void {
        dispatchEventWith(MOVE, false, swap);
    }

    public function kill():void {
        dispatchEventWith(KILL);
    }

    public function hint():void {
        dispatchEventWith(HINT);
    }

    private function update():void {
        dispatchEventWith(UPDATE);
    }
}
}