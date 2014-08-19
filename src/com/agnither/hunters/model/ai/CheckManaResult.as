/**
 * Created by agnither on 18.08.14.
 */
package com.agnither.hunters.model.ai {
import com.agnither.hunters.data.outer.MagicVO;
import com.agnither.hunters.model.player.ManaList;
import com.agnither.hunters.model.player.Spell;

import flash.utils.Dictionary;

public class CheckManaResult {

    private var _results: Dictionary;
    public function get results():Dictionary {
        return _results;
    }

    private var _delta: int;
    public function get delta():int {
        return _delta;
    }
    public function get enough():Boolean {
        return _delta == 0;
    }

    public function CheckManaResult(mana: ManaList, spell: Spell) {
        _results = new Dictionary();
        _delta = 0;

        var l: int = spell.mana.length;
        for (var i:int = 0; i < l; i++) {
            var manaData: Array = spell.mana[i].split(":");
            var magic: MagicVO = MagicVO.DICT[manaData[0]];
            var delta: int = manaData[1] - mana.getMana(magic.name).value;
            if (delta > 0) {
                _results[magic.name] = delta;
                _delta += delta;
            }
        }
    }
}
}
