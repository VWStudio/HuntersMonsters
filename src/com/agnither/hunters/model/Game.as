/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.model {
import com.agnither.hunters.data.outer.ChipVO;
import com.agnither.hunters.model.match3.Cell;
import com.agnither.hunters.model.match3.Field;
import com.agnither.hunters.model.match3.Match;
import com.agnither.hunters.model.player.AIPlayer;
import com.agnither.hunters.model.player.drop.DropList;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.inventory.Spell;
import com.agnither.hunters.model.player.personage.Personage;

import starling.events.Event;
import starling.events.EventDispatcher;

public class Game extends EventDispatcher {

    public static const END_GAME: String = "end_game_Game";

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

    private var _drop: DropList;
    public function get dropList():DropList {
        return _drop;
    }

    public function Game() {
        _field = new Field();
        _field.addEventListener(Field.MATCH, handleMatch);
        _field.addEventListener(Field.MOVE, handleMove);

        _drop = new DropList();
    }

    public function init(player: Player, enemy: Player, dropSet: int):void {
        AIPlayer.game = this;

        _player = player;
        _player.hero.addEventListener(Personage.DEAD, handlePlayerDead);

        _enemy = enemy;
        _enemy.hero.addEventListener(Personage.DEAD, handleEnemyDead);

        _field.initChips(_player.hero.magic.name, _enemy.hero.magic.name);
        _field.init();

        _drop.init(dropSet);

        nextMove(_player);
    }

    public function selectCell(cell: Cell):void {
        _field.selectCell(cell);
    }

    public function checkSpell(spell: Spell):Boolean {
        return currentPlayer.checkSpell(spell.uniqueId);
    }

    public function useSpell(spell: Spell):void {
        currentPlayer.useSpell(spell.uniqueId, currentEnemy.hero);
    }

    private function nextMove(player: Player):void {
        _currentPlayer = player;
        _currentPlayer.startMove();
    }

    private function handleMatch(e: Event):void {
        var attacker: Personage;

        var match: Match = e.data as Match;
        switch (match.type) {
            case ChipVO.CHEST:
                _drop.drop();
                break;
            case ChipVO.WEAPON:
                attacker = currentPlayer.hero;
                break;
            default:
                if (!currentPlayer.pet.dead && currentPlayer.pet.magic.name == match.type) {
                    attacker = currentPlayer.pet;
                }
                currentPlayer.manaList.addMana(match.type, match.amount);
                break;
        }

        if (attacker) {
            var aim:Personage = !currentEnemy.pet.dead ? currentEnemy.pet : currentEnemy.hero;
            match.showDamage(attacker.damage);
            aim.hit(match.amount * attacker.damage);
        }
    }

    private function handleMove(e: Event):void {
        nextMove(currentEnemy);
    }

    private function handlePlayerDead(e: Event):void {
        dispatchEventWith(END_GAME, false, false);
    }

    private function handleEnemyDead(e: Event):void {
        dispatchEventWith(END_GAME, false, true);
    }
}
}
