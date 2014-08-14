/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.model.match3 {
import com.agnither.hunters.data.ChipVO;

public class MatchResult {

    private var _type: String;
    public function get type():String {
        return _type;
    }

    private var _amount: int;
    public function get amount():int {
        return _amount;
    }

    public function get score():int {
        var typeScore: int = _type == ChipVO.WEAPON ? 10 : 1;
        return _amount * typeScore;
    }

    public function MatchResult(type: String, amount: int) {
        _type = type;
        _amount = amount;
    }
}
}
