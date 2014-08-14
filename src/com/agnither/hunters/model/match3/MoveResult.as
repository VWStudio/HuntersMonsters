/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.model.match3 {
public class MoveResult {

    private var _move: Move;
    public function get move():Move {
        return _move;
    }

    private var _results: Vector.<MatchResult>;

    private var _score: int;
    public function get score():int {
        return _score;
    }

    public function MoveResult(move: Move) {
        _move = move;
        _results = new <MatchResult>[];
        _score = 0;
    }

    public function addResult(result: MatchResult):void {
        _score += result.score;
        _results.push(result);
    }

    public function destroy():void {
        _move = null;
        _results = null;
    }
}
}
