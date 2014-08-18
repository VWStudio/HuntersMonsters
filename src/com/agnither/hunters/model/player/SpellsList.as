/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player {
import flash.utils.Dictionary;

import starling.events.EventDispatcher;

public class SpellsList extends EventDispatcher {

    private var _list: Vector.<Spell>;
    public function get list():Vector.<Spell> {
        return _list;
    }

    private var _dict: Dictionary;
    public function getSpell(name: String):Spell {
        return _dict[name];
    }

    public function SpellsList() {
        _list = new <Spell>[];
        _dict = new Dictionary();
    }

    public function init():void {
    }

    public function addSpell(name: String):void {
        var spell: Spell = new Spell(name);
        _list.push(spell);
        _dict[name] = spell;
    }

    public function clearList():void {
        while (_list.length > 0) {
            var spell: Spell = _list.shift();
            spell.destroy();
            delete _dict[spell.name];
        }
    }
}
}
