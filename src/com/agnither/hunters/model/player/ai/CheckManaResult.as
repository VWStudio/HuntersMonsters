/**
 * Created by agnither on 18.08.14.
 */
package com.agnither.hunters.model.player.ai {
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.model.player.Mana;
import com.agnither.hunters.model.player.ManaList;
import com.agnither.hunters.model.player.inventory.Spell;

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

        var manaAmount: Object = spell.extension_drop;
        for (var key: * in manaAmount) {
            var magic: DamageTypeVO = DamageTypeVO.DICT[key];
            var manaItem : Mana = mana.getMana(magic.name);
            var delta: int = manaItem ? manaAmount[key] - manaItem.value : 0;
            if (delta > 0) {
                _results[magic.name] = delta;
                _delta += delta;
            }
        }
    }
}
}
