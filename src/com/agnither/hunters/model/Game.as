/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.model {
import com.agnither.hunters.data.ChipVO;
import com.agnither.hunters.model.ai.AI;
import com.agnither.hunters.model.match3.Cell;
import com.agnither.hunters.model.match3.Field;
import com.agnither.hunters.model.match3.Match;
import com.agnither.hunters.model.player.Player;

import starling.events.Event;
import starling.events.EventDispatcher;

public class Game extends EventDispatcher {

    private var _player: Player;
    public function get player():Player {
        return _player;
    }

    private var _enemy: Player;
    public function get enemy():Player {
        return _enemy;
    }

    private var _currentPlayer: Player;
    public function get currentPlayer():Player {
        return _currentPlayer;
    }
    public function get currentEnemy():Player {
        return _currentPlayer == _player ? _enemy : _player;
    }

    private var _field: Field;
    public function get field():Field {
        return _field;
    }

    public function Game() {
        _player = new Player();
        _enemy = new Player();

        _field = new Field();
        _field.addEventListener(Field.MATCH, handleMatch);
        _field.addEventListener(Field.MOVE, handleMove);
    }

    public function init():void {
        AI.init(this);

        _player.init({hp: 200, armor: 5, damage: 10});
        _enemy.init({hp: 100, armor: 3, damage: 5});

        _field.init();

        nextMove(_player);
    }

    public function selectCell(cell: Cell):void {
        _field.selectCell(cell);
    }

    private function nextMove(player: Player):void {
        _currentPlayer = player;

        if (_currentPlayer == _enemy) {
            AI.move(_currentPlayer);
        }
    }

    private function handleMatch(e: Event):void {
        var match: Match = e.data as Match;
        switch (match.type) {
            case ChipVO.CHEST:
                break;
            case ChipVO.WEAPON:
                currentEnemy.personage.hit(match.amount * currentPlayer.personage.damage);
                break;
            case ChipVO.NATURE:
            case ChipVO.WATER:
            case ChipVO.FIRE:
                currentPlayer.manaList.addMana(match.type, match.amount);
                break;
        }
    }

    private function handleMove(e: Event):void {
        nextMove(currentEnemy);
    }
}
}
