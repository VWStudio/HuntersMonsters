/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.model.match3 {
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.cemaprjl.core.coreDispatch;

import flash.geom.Point;
import flash.utils.Dictionary;

import starling.animation.Juggler;
import starling.core.Starling;
import starling.events.EventDispatcher;

public class Field extends EventDispatcher {

//    public static const INIT: String = "init_Field";
    public static const ADD_CHIP: String = "add_chip_Field";
    public static const MOVE: String = "move_Field";
    public static const MATCH: String = "match_Field";
    public static const UPDATE: String = "update_Field";
//    public static const CLEAR: String = "clear_Field";

    public static var cols: int = 8;
    public static var rows: int = 8;

    private static var _chipTypes: Vector.<String> = new <String>[];
    private static function getRandomChip(fall: Boolean):Chip {
        var rand: int = _chipTypes.length * Math.random();
        return new Chip(_chipTypes[rand], fall);
    }

    private var _fieldObj: Object;
    private var _field: Vector.<Cell>;
    public function get field():Vector.<Cell> {
        return _field;
    }

    private var _availableMoves: Vector.<Move>;
    public function get availableMoves():Vector.<Move> {
        return _availableMoves;
    }

    private var _matches: Vector.<Match>;

    private var _selectedCell: Cell;

    private var _hintTime: Number;
    private var _hintMatch: Vector.<Chip>;

    private var _juggler: Juggler;

    private var _delayedCalls: int;
    public function get busy():Boolean {
        return _delayedCalls>0;
    }

    private var _started: Boolean;
    public function get started():Boolean {
        return _started;
    }

    public function Field() {
        _juggler = new Juggler();
    }

    public function initChips(special1: String, special2: String):void {
        _chipTypes.length = 0;

        var allTypes : Array = [MagicTypeVO.NATURE, MagicTypeVO.DARK, MagicTypeVO.STONE, MagicTypeVO.ADD3];

        _chipTypes.push(MagicTypeVO.CHEST);
        _chipTypes.push(MagicTypeVO.WEAPON);
        _chipTypes.push(MagicTypeVO.WATER);
        _chipTypes.push(MagicTypeVO.FIRE);

//        _chipTypes.push(MagicTypeVO.NATURE);

        var index : int = -1;
        if (_chipTypes.indexOf(special1) < 0) {
            _chipTypes.push(special1);
            index = allTypes.indexOf(special1);
            if(index >= 0) {
                allTypes.splice(index, 1)
            }
        }
        if (_chipTypes.indexOf(special2) < 0) {
            _chipTypes.push(special2);
//            index = allTypes.indexOf(special1);
//            if(index >= 0) {
//                allTypes.splice(index, 1)
//            }
        } else {
            _chipTypes.push(allTypes[int(Math.random()*allTypes.length)]);
        }
    }

    public function init():void {
        _hintTime = 0;
        _hintMatch = new <Chip>[];

        _delayedCalls = 0;

        _matches = new <Match>[];

        createField();

        fillGems();

        findMatches();
        while (_matches.length>0) {
            fixMatches();
            findMatches();
        }

        clearMatches();

        findMoves();

        _started = true;

//        dispatchEventWith(INIT);

        Starling.juggler.add(_juggler);
    }

    public function clear():void {
//        dispatchEventWith(CLEAR);

        _fieldObj = null;

        while (_field.length>0) {
            var cell: Cell = _field.pop();
            cell.clear();
        }
        _field = null;

        _availableMoves = null;
        _matches = null;
        _selectedCell = null;

        _started = false;

        Starling.juggler.remove(_juggler);
        _juggler.purge();
    }

    private function delayedCall(call: Function, delay: Number, ...params):void {
        _delayedCalls++;
        _juggler.delayCall(delayedCallFinal, delay, call, params);
    }

    private function delayedCallFinal(call: Function, params: Array):void {
        _delayedCalls--;
        if (params.length>0) {
            call.apply(this, params);
        } else {
            call();
        }
    }

    private function createField():void {
        _field = new <Cell>[];
        _fieldObj = {};

        for (var j:int = 0; j < cols; j++) {
            for (var i:int = 0; i < rows; i++) {
                var cell: Cell = new Cell(i, j);
//                cell.setChip(getRandomChip(false));
                _field.push(cell);
                _fieldObj[i+"."+j] = cell;
            }
        }
    }

    private function findMoves():void {
        _availableMoves = new <Move>[];
        for (var i:int = 0; i < _field.length; i++) {
            var cell: Cell = _field[i];
            if (cell.x < cols-2) {
                _availableMoves = _availableMoves.concat(checkTriple([cell, getCell(cell.x+1, cell.y), getCell(cell.x+2, cell.y)]));
            }
            if (cell.y < rows-2) {
                _availableMoves = _availableMoves.concat(checkTriple([cell, getCell(cell.x, cell.y+1), getCell(cell.x, cell.y+2)]));
            }
        }
    }

    private function checkTriple(cells: Array):Vector.<Move> {
        var moves: Vector.<Move> = new <Move>[];

        if (!cells[0].type || !cells[1].type || !cells[2].type) {
            return moves;
        }

        cells.sortOn("type");

        if (!cells[1].matchable) {
            return moves;
        }

        var excess: Cell;
        if (cells[0].type != cells[1].type) {
            excess = cells[0];
        }
        if (cells[1].type != cells[2].type) {
            if (!excess) {
                excess = cells[2];
            } else {
                excess = null;
            }
        }

        if (excess) {
            var neighbours: Vector.<Cell> = getNeighbours(excess);
            for (var i:int = 0; i < neighbours.length; i++) {
                var neighbour: Cell = neighbours[i];
                if (cells.indexOf(neighbour)<0 && cells[1].type==neighbour.type) {
                    moves.push(new Move(excess, neighbour));
                }
            }
        }
        return moves;
    }

    private function showHint():void {
        while (_hintMatch.length == 0) {
            var rand:int = Math.random() * _availableMoves.length;
            var move:Move = _availableMoves[rand];

            move.trySwap();
            findMatches();
            if (_matches.length>0) {
                var match:Match = _matches[0];
                for (var i:int = 0; i < match.cells.length; i++) {
                    _hintMatch.push(match.cells[i].chip);
                }
            }
            clearMatches();
            move.trySwap();
        }

        for (i = 0; i < _hintMatch.length; i++) {
            Starling.juggler.delayCall(_hintMatch[i].hint, Math.random() * 0.3);
        }

        _hintTime = 0;
    }

    public function checkMove(move: Move, scoreMuls: Dictionary):MoveResult {
        move.trySwap();
        findMatches();
        move.trySwap();
        var result: MoveResult = new MoveResult(move);
        while (_matches.length > 0) {
            var match: Match = _matches.pop();
            result.addResult(new MatchResult(match.type, match.amount, scoreMuls[match.type] ? 2 : 1));
            match.destroy();
        }
        return result;
    }

    public function selectCell(cell: Cell):void {
        if (busy) {
            return;
        }

        if (!cell) {
            if (_selectedCell) {
                _selectedCell.select(false);
                _selectedCell = null;
            }
            return;
        }

        if (!cell.chip) {
            return;
        }

        if (_selectedCell) {
            _selectedCell.select(false);

            var distance: Number = Point.distance(_selectedCell.position, cell.position);
            if (distance > 1) {
                _selectedCell = cell;
                _selectedCell.select(true);
            } else if (distance == 1) {
                checkSwap(_selectedCell, cell);
                _selectedCell = null;
            } else {
                _selectedCell = null;
            }
        } else {
            _selectedCell = cell;
            _selectedCell.select(true);
        }
    }

    private function checkSwap(cell1: Cell, cell2: Cell):void {
        for (var i:int = 0; i < _availableMoves.length; i++) {
            var move: Move = _availableMoves[i];
            if (move.check(cell1, cell2)) {
                cell1.swap(cell2);
//                delayedCall(checkField, TimingVO.swap+TimingVO.feedback, move);
                delayedCall(checkField, 0.25, move);
                return;
            }
        }

        cell1.swap(cell2);
//        delayedCall(cell2.swap, TimingVO.swap+TimingVO.feedback, cell1);
        delayedCall(cell2.swap, 0.25, cell1);
    }

    private function checkField(move: Move = null):void {
        findMatches();
        if (_matches.length>0) {
            _matches.sort(sortOnAmount);
            removeMatches();
        } else {
            findMoves();

            if (_availableMoves.length==0) {
//                delayedCall(shuffleField, TimingVO.kill);
                delayedCall(shuffleField, 0.35);
//                delayedCall(checkField, TimingVO.kill+TimingVO.swap+TimingVO.feedback);
                delayedCall(checkField, 0.6);
            } else {
                _hintTime = 0;
                _hintMatch.length = 0;

                if (_delayedCalls == 0) {
                    dispatchEventWith(MOVE);
                }
            }
        }
    }

    private var _iteration: int = 0;
    private function findMatches():void {
        clearMatches();

        _iteration++;

        // check vertical matches
        var match: Match;
        for (var i:int = 0; i < cols; i++) {
            for (var j:int = 0; j < rows; j++) {
                var cell: Cell = getCell(i, j);
                if (match && !match.addCell(cell)) {
                    if (match.amount >= 3) {
                        _matches.push(match);
                    } else {
                        match.destroy();
                    }
                    match = null;
                }
                if (!match) {
                    match = new Match(_iteration);
                    match.addCell(cell);
                }
            }
            if (match.amount >= 3) {
                _matches.push(match);
            } else {
                match.destroy();
            }
            match = null;
        }

        // check horizontal matches
        for (j = 0; j < rows; j++) {
            for (i = 0; i < cols; i++) {
                cell = getCell(i, j);
                if (match && !match.addCell(cell)) {
                    if (match.amount >= 3) {
                        _matches.push(match);
                    } else {
                        match.destroy();
                    }
                    match = null;
                }
                if (!match) {
                    match = new Match(_iteration);
                    match.addCell(cell);
                }
            }
            if (match.amount >= 3) {
                _matches.push(match);
            } else {
                match.destroy();
            }
            match = null;
        }

        var l: int = _matches.length;
        for (i = 0; i < l; i++) {
            match = _matches[i];
            if (match.toConcat) {
                match.toConcat.concat(match);
                match.destroy();
                _matches.splice(i--, 1);
                l--;
            }
        }
    }

    private function clearMatches():void {
        while (_matches.length > 0) {
            _matches.pop().destroy();
        }
    }

    private function fixMatches():void {
        while (_matches.length>0) {
            var match: Match = _matches.pop();
            var change: Cell = match.random;
            if (change) {
                change.clear();
                change.setChip(getRandomChip(false));
            }
            match.destroy();
        }
    }

    private function sortOnAmount(match1: Match, match2: Match):int {
        if (match1.baseLength > match2.baseLength) {
            return -1;
        }
        if (match1.baseLength < match2.baseLength) {
            return 1;
        }
        return 0;
    }

    private function removeMatches():void {
        while (_matches.length>0) {
            var match: Match = _matches.pop();
            dispatchEventWith(MATCH, false, match);
            delayedCall(clearCells, 0, match.cells);
            match.destroy();
        }
    }

    private function clearCells(cells: Vector.<Cell>):void {
        while (cells.length > 0) {
            var cell: Cell = cells.shift();
            if (cell.chip) {
                cell.clear();
            }
        }

//        delayedCall(fallGems, TimingVO.kill);
        delayedCall(fallGems, 0.35);
    }

    private function fillGems():void {
        for (var i:int = 0; i < cols; i++) {
            for (var j:int = 0; j < rows; j++) {
                var cell: Cell = getCell(i, j);
                if (cell) {
                    var chip: Chip = getRandomChip(false);
                    cell.setChip(chip);
                    coreDispatch(ADD_CHIP, chip);
//                    dispatchEventWith(ADD_CHIP, false, chip);
                }
            }
        }
    }

    private function fallGems():void {
        var refill: Boolean = false;

        for (var j:int = 1; j <= rows; j++) {
            for (var i:int = 0; i < cols; i++) {
                var cell: Cell = getCell(i, rows-j);
                if (cell) {
                    if (cell.fillable) {
                        var upper: Cell = getCell(cell.x, cell.y-1);
                        if (upper && upper.chip) {
                            cell.fall(upper);
                            refill = true;
                        }
                    }
                }
            }
        }


        refillGems(refill);
    }

    private function refillGems(forceFall: Boolean = false):void {
        var refill: Boolean;

        var l: int = cols;
        for (var i:int = 0; i < l; i++) {
            var cell: Cell = getCell(i, 0);
            if (cell && cell.fillable) {
                var chip: Chip = getRandomChip(true);
                cell.setChip(chip);
                coreDispatch(ADD_CHIP, chip);
//                dispatchEventWith(ADD_CHIP, false, chip);

                refill = true;
            }
        }

        if (refill || forceFall) {
//            delayedCall(fallGems, TimingVO.fall);
            delayedCall(fallGems, 0.05);
        } else {
//            delayedCall(checkField, TimingVO.fall);
            delayedCall(checkField, 0.05);
        }
    }

    private function shuffleField():void {
        var chips: Vector.<Chip> = new <Chip>[];

        var l: int = _field.length;
        for (var i:int = 0; i < l; i++) {
            var cell: Cell = _field[i];
            if (cell.chip && cell.chip.allowShuffle) {
                if (Math.random()<0.5) {
                    chips.push(cell.chip);
                } else {
                    chips.unshift(cell.chip);
                }
            }
        }

        for (i = 0; i < l; i++) {
            cell = _field[i];
            if (cell.chip && cell.chip.allowShuffle) {
                if (Math.random()<0.5) {
                    cell.setChip(chips.pop(), true);
                } else {
                    cell.setChip(chips.shift(), true);
                }
            }
        }
    }

    private function getCell(x: int, y: int):Cell {
        return _fieldObj[x+"."+y];
    }

    private function getNeighbours(cell: Cell):Vector.<Cell> {
        var neighbours: Vector.<Cell> = new <Cell>[];
        for (var i:int = -1; i <= 1; i++) {
            for (var j:int = -1; j <= 1; j++) {
                if (Math.abs(i)+Math.abs(j)==1) {
                    var neighbour: Cell = getCell(cell.x+i, cell.y+j);
                    if (neighbour) {
                        neighbours.push(neighbour);
                    }
                }
            }
        }
        return neighbours;
    }

    public function step(delta: Number):void {
        if (!_started) {
            return;
        }

        if (_delayedCalls==0) {
            _hintTime += delta;

//            if (_hintTime >= TimingVO.hint) {
            if (_hintTime >= 2) {
                showHint();
            }
        }

        dispatchEventWith(UPDATE);
    }
}
}
