/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.model.match3 {
public class MatchResult {

    private var _type: String;
    public function get type():String {
        return _type;
    }

    private var _amount: int;
    public function get amount():int {
        return _amount;
    }

    private var _scoreMul: int;
    public function get score():int {
        return _amount * _scoreMul;
    }

    public function MatchResult(type: String, amount: int, scoreMul: int = 1) {
        _type = type;
        _amount = amount;
        _scoreMul = scoreMul;
    }
}
}
