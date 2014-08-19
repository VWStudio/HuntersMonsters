/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.model {
import com.agnither.hunters.data.outer.ArmorVO;
import com.agnither.hunters.data.outer.ChipVO;
import com.agnither.hunters.data.outer.DropVO;
import com.agnither.hunters.data.outer.GoldDropVO;
import com.agnither.hunters.data.outer.ItemVO;
import com.agnither.hunters.data.outer.MonsterVO;
import com.agnither.hunters.data.outer.PlayerVO;
import com.agnither.hunters.data.outer.WeaponVO;
import com.agnither.hunters.model.ai.AI;
import com.agnither.hunters.model.match3.Cell;
import com.agnither.hunters.model.match3.Field;
import com.agnither.hunters.model.match3.Match;
import com.agnither.hunters.model.player.DropList;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.Spell;

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

    private var _drop: DropList;
    public function get dropList():DropList {
        return _drop;
    }

    public function Game() {
        _player = new Player();
        _enemy = new Player();

        _field = new Field();
        _field.addEventListener(Field.MATCH, handleMatch);
        _field.addEventListener(Field.MOVE, handleMove);

        _drop = new DropList();
    }

    public function init():void {
        AI.init(this);

        var pl: PlayerVO = PlayerVO.DICT[1];
        pl.magic = 5;
        pl.spells = [1,2];
        _player.init(pl);

        _enemy.init(MonsterVO.DICT[1]);

        _field.initChips(_player.personage.magic.name, _enemy.personage.magic.name);
        _field.init();

        nextMove(_player);
    }

    public function selectCell(cell: Cell):void {
        _field.selectCell(cell);
    }

    public function checkSpell(spell: Spell):Boolean {
        return currentPlayer.checkSpell(spell.name);
    }

    public function selectSpell(spell: Spell):void {
//        currentPlayer.checkSpell(spell.name);
    }

    public function useSpell(spell: Spell):void {
        currentPlayer.useSpell(spell.name, currentEnemy.personage);
    }

    private function nextMove(player: Player):void {
        _currentPlayer = player;

        if (_currentPlayer == _enemy) {
            AI.move(_currentPlayer);
        }
    }

    private function drop():void {
        var monster: MonsterVO = _enemy.personage.data as MonsterVO;
        var drop: DropVO = DropVO.getRandomDrop(monster.drop);
        switch (drop.item_type) {
            case DropVO.WEAPON:
                _drop.addContent(WeaponVO.DICT[drop.item_id]);
                break;
            case DropVO.ARMOR:
                _drop.addContent(ArmorVO.DICT[drop.item_id]);
                break;
            case DropVO.ITEM:
                _drop.addContent(ItemVO.DICT[drop.item_id]);
                break;
            case DropVO.GOLD:
                _drop.addContent(GoldDropVO.DICT[drop.item_id]);
                break;
        }
    }

    private function handleMatch(e: Event):void {
        var match: Match = e.data as Match;
        switch (match.type) {
            case ChipVO.CHEST:
                drop();
                break;
            case ChipVO.WEAPON:
                currentEnemy.personage.hit(match.amount * currentPlayer.personage.damage);
                break;
            default:
                currentPlayer.manaList.addMana(match.type, match.amount);
                break;
        }


        // TODO: переделать нанесение урона (проверка типа урона и сравнение с типом матча)
    }

    private function handleMove(e: Event):void {
        nextMove(currentEnemy);
    }
}
}
