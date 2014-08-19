/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.inner.PersonageVO;
import com.agnither.hunters.data.outer.SpellVO;

import starling.events.EventDispatcher;

public class Player extends EventDispatcher {

    private var _personage: Personage;
    public function get personage():Personage {
        return _personage;
    }

    private var _manaList: ManaList;
    public function get manaList():ManaList {
        return _manaList;
    }

    private var _spells: SpellsList;
    public function get spells():SpellsList {
        return _spells;
    }

    public function Player() {
        _personage = new Personage();

        _manaList = new ManaList();
        _spells = new SpellsList();
    }

    public function init(data: PersonageVO):void {
        _personage.init(data);

        _manaList.init();
        _manaList.addManaCounter(_personage.magic.name);

        _spells.init();

        for (var i:int = 0; i < _personage.spells.length; i++) {
            _spells.addSpell(SpellVO.DICT[_personage.spells[i]].name);
        }
    }

    public function checkSpell(name: String):Boolean {
        var spell: Spell = _spells.getSpell(name);
        return _manaList.checkSpell(spell);
    }

    public function useSpell(name: String, target: Personage):void {
        var spell: Spell = _spells.getSpell(name);
        spell.useSpell(target);
        _manaList.useSpell(spell);
    }
}
}
