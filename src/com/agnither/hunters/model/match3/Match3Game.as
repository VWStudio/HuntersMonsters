/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.model.match3 {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.ChipVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.match3.Cell;
import com.agnither.hunters.model.match3.Field;
import com.agnither.hunters.model.match3.Match;
import com.agnither.hunters.model.player.AIPlayer;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.drop.DropList;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.drop.DropSlot;
import com.agnither.hunters.model.player.drop.GoldDrop;
import com.agnither.hunters.model.player.drop.ItemDrop;
import com.agnither.hunters.model.player.inventory.Spell;
import com.agnither.hunters.model.player.personage.Personage;
import com.agnither.hunters.view.ui.screens.battle.match3.FieldView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.BattleInventoryView;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.viewmanage.ShowScreenCmd;

import starling.display.Stage;

import starling.events.Event;
import starling.events.EventDispatcher;

public class Match3Game extends EventDispatcher {

    public static const END_GAME: String = "Match3Game.END_GAME";
//    public static const END_GAME: String = "end_game_Game";
    public static const START_GAME : String = "Match3Game.START_GAME";

    public static const MODE_HOUSE : String = "Match3Game.MODE_HOUSE";
    public static const MODE_REGULAR : String = "Match3Game.MODE_REGULAR";
    public static const MODE_BOSS : String = "Match3Game.MODE_BOSS";
    public static const MODE_STEP : String = "Match3Game.MODE_STEP";

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
    private var _stage : Stage;
    private var _allowPlay : Boolean = true;
    private var _totalMoves : int = 0;
    public function get dropList():DropList {
        return _drop;
    }

    public function Match3Game($stage : Stage) {

        _stage = $stage;
        _stage.addEventListener(FieldView.SELECT_CELL, handleSelectCell);
        _stage.addEventListener(BattleInventoryView.ITEM_SELECTED, handleSelectSpell);





        _drop = new DropList();
    }

    private function handleSelectCell(e: Event):void {
        if (currentPlayer == player) {
            selectCell(e.data as Cell);
        }
    }

    private function handleSelectSpell(e: Event):void {
        if (!(currentPlayer is AIPlayer)) {
            var spell: Spell = e.data as Spell;
            if (spell && checkSpell(spell)) {
                useSpell(spell);
            }
        }
    }

    public function init(player: Player, enemy: Player, dropSet: int):void {
        AIPlayer.game = this;
        _allowPlay = true;
        _totalMoves = 0;
        if(_field) {
            _field.clear();
        } else {
            _field = new Field();
            _field.addEventListener(Field.MATCH, handleMatch);
            _field.addEventListener(Field.MOVE, handleMove);
        }


        _player = player;
        _player.hero.addEventListener(Personage.DEAD, handlePlayerDead);

        _enemy = enemy;
        _enemy.hero.addEventListener(Personage.DEAD, handleEnemyDead);

        _field.initChips(_player.hero.magic.name, _enemy.hero.magic.name);
        _field.init();

        _drop.clearList();
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
        trace("USE SPELL");
        currentPlayer.useSpell(spell.uniqueId, currentEnemy.hero);
    }

    private function nextMove(player: Player):void {
        _currentPlayer = player;
        if(_currentPlayer is LocalPlayer) {
            _totalMoves++;
        }
        if(_allowPlay) {
            _currentPlayer.startMove();
        }
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
                if (!currentPlayer.pet.isDead && currentPlayer.pet.magic.name == match.type) {
                    attacker = currentPlayer.pet;
                }
                currentPlayer.manaList.addMana(match.type, match.amount);
                break;
        }

        if (attacker) {
            var aim:Personage = !currentEnemy.pet.isDead ? currentEnemy.pet : currentEnemy.hero;
            match.showDamage(attacker.damage);
            aim.hit(match.amount * attacker.damage);
        }
    }

    private function handleMove(e: Event):void {
        nextMove(currentEnemy);
    }

    private function handlePlayerDead(e: Event):void {
        _allowPlay = false;
        Model.instance.movesAmount = _totalMoves;
        coreDispatch(END_GAME, false);
    }

    private function handleEnemyDead(e: Event):void {
        _allowPlay = false;
        Model.instance.movesAmount = _totalMoves;
        coreDispatch(END_GAME, true);
    }



}
}
