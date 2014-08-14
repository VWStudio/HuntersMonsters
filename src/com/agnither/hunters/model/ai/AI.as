/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.model.ai {
import com.agnither.hunters.model.Game;
import com.agnither.hunters.model.match3.Move;
import com.agnither.hunters.model.match3.MoveResult;
import com.agnither.hunters.model.player.Player;

import starling.core.Starling;

public class AI {

    private static var _game: Game;

    private static var _player: Player;
    private static var _results: Vector.<MoveResult>;

    public static function init(game: Game):void {
        _game = game;
     }

    public static function move(player: Player):void {
        _player = player;

        // TODO: сначала проверка на возможность скастовать заклинание

        _results = new <MoveResult>[];
        var moves: Vector.<Move> = _game.field.availableMoves;
        var l: int = moves.length;
        for (var i:int = 0; i < l; i++) {
            _results.push(_game.field.checkMove(moves[i]));
        }
        _results.sort(sortResults);

//        var rand: int = moves.length * Math.random();
//        var move: Move = moves[rand];
        var move: Move = _results[0].move;

        Starling.juggler.delayCall(_game.selectCell, 0.5, move.cell2);
        Starling.juggler.delayCall(_game.selectCell, 1, move.cell1);
    }

    private static function sortResults(res1: MoveResult, res2: MoveResult):int {
        if (res1.score < res2.score) {
            return 1;
        } else if (res1.score > res2.score) {
            return -1;
        }
        return 0;
    }
}
}
