/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.model.ai {
import com.agnither.hunters.model.Game;
import com.agnither.hunters.model.match3.Move;
import com.agnither.hunters.model.match3.MoveResult;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.Spell;

import flash.utils.Dictionary;

import starling.core.Starling;

public class AI {

    private static var _game: Game;

    private static var _player: Player;
    private static var _spellResults: Dictionary;
    private static var _weaponResults: Array;
    private static var _otherResults: Array;

    public static function init(game: Game):void {
        _game = game;
     }

    public static function move(player: Player):void {
        _player = player;
        var difficulty: int = 30;

        processSpells(difficulty);
        processMoves();
        selectMove(difficulty);
    }

    private static function processSpells(difficulty: int):void {
        var results: Array = [];
        if (Math.random()*100 < difficulty) {
            for (var i:int = 0; i < _player.spells.list.length; i++) {
                var spell:Spell = _player.spells.list[i];
                var result: CheckManaResult = new CheckManaResult(_player.manaList, spell);
                if (result.enough) {
                    _game.useSpell(spell);
                } else {
                    results.push(result);
                }
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

    private static function processMoves():void {
        _weaponResults = [];
        _otherResults = [];
        var moves: Vector.<Move> = _game.field.availableMoves;
        var l: int = moves.length;
        for (var i: int = 0; i < l; i++) {
            var result: MoveResult = _game.field.checkMove(moves[i], _spellResults);
            if (result.haveWeapon) {
                _weaponResults.push(result);
            } else {
                _otherResults.push(result);
            }
        }
    }

    private static function selectMove(difficulty: int):void {
        var results: Array = _weaponResults.length > 0 ? _weaponResults : _otherResults;
        results.sortOn("score", Array.NUMERIC);

        var rand: int = (100-difficulty)/100 * results.length * Math.random();
        var move: Move = results[rand].move;

        Starling.juggler.delayCall(_game.selectCell, 0.5, move.cell2);
        Starling.juggler.delayCall(_game.selectCell, 1, move.cell1);
    }
}
}
