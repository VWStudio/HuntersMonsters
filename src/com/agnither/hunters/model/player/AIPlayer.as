/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.outer.ItemVO;
import com.agnither.hunters.data.outer.MonsterVO;
import com.agnither.hunters.model.Game;
import com.agnither.hunters.model.match3.Move;
import com.agnither.hunters.model.match3.MoveResult;

import flash.utils.Dictionary;

import starling.core.Starling;

public class AIPlayer extends Player {

    public static var game: Game;

    private var _difficulty: int;

    private var _spellResults: Dictionary;
    private var _weaponResults: Array;
    private var _otherResults: Array;

    public function AIPlayer(data: MonsterVO):void {
        _difficulty = data.difficulty;
        super(data);

        loadInventory(data);
    }

    private function loadInventory(monster: MonsterVO):void {
        var items: Object = {};
        var stock: Array = [];
        var inventory: Array = [];
        for (var i:int = 0; i < monster.items.length; i++) {
            var id: int = monster.items[i];
            items[id] = ItemVO.DICT[id];
            stock.push(id);
            inventory.push(id);
        }
        initInventory(items, stock, inventory);
    }

    override public function startMove():void {
        processSpells(_difficulty);
        processMoves();
        selectMove(_difficulty);
    }

    private function processSpells(difficulty: int):void {
        var results: Array = [];
        if (Math.random()*100 < difficulty) {
            for (var i:int = 0; i < _inventory.stockItems.length; i++) {
//                var spell: Spell = _inventory.stockItems[i] as Spell;
//                if (spell) {
//                    var result:CheckManaResult = new CheckManaResult(_manaList, spell);
//                    if (result.enough) {
//                        game.useSpell(spell);
//                    } else {
//                        results.push(result);
//                    }
//                }
            }
        }

        _spellResults = new Dictionary();
        if (results.length > 0) {
            results.sortOn("delta", Array.NUMERIC);
            for (var key: * in results[0].results) {
                _spellResults[key] = true;
            }
        }
    }

    private function processMoves():void {
        _weaponResults = [];
        _otherResults = [];
        var moves: Vector.<Move> = game.field.availableMoves;
        var l: int = moves.length;
        for (var i: int = 0; i < l; i++) {
            var result: MoveResult = game.field.checkMove(moves[i], _spellResults);
            if (result.haveWeapon) {
                _weaponResults.push(result);
            } else {
                _otherResults.push(result);
            }
        }
    }

    private function selectMove(difficulty: int):void {
        var results: Array = _weaponResults.length > 0 ? _weaponResults : _otherResults;
        results.sortOn("score", Array.NUMERIC);

        var rand: int = (100-difficulty)/100 * results.length * Math.random();
        var move: Move = results[rand].move;

        Starling.juggler.delayCall(game.selectCell, 0.5, move.cell2);
        Starling.juggler.delayCall(game.selectCell, 1, move.cell1);
    }
}
}