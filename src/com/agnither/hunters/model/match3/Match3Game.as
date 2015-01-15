/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.model.match3
{
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.AIPlayer;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.drop.DropList;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.personage.Personage;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.hunters.view.ui.screens.battle.match3.FieldView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.BattleInventoryView;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;

import starling.display.Stage;
import starling.events.Event;
import starling.events.EventDispatcher;

public class Match3Game extends EventDispatcher
{

    public static const END_GAME : String = "Match3Game.END_GAME";
//    public static const END_GAME: String = "end_game_Game";
    public static const START_GAME : String = "Match3Game.START_GAME";

    public static const MODE_HOUSE : String = "Match3Game.MODE_HOUSE";
    public static const MODE_REGULAR : String = "Match3Game.MODE_REGULAR";
    public static const MODE_BOSS : String = "Match3Game.MODE_BOSS";
    public static const MODE_STEP : String = "Match3Game.MODE_STEP";

    public static var ignoreGraphic : Boolean = false;
//    public static var ignoreGraphic : Boolean = true;

    private var _player : Player;
    public static const CONTINUE : String = "Match3Game.CONTINUE";
    public function get player() : Player
    {
        return _player;
    }

    private var _enemy : Player;
    public function get enemy() : Player
    {
        return _enemy;
    }

    private var _currentPlayer : Player;
    public function get currentPlayer() : Player
    {
        return _currentPlayer;
    }

    public function get currentEnemy() : Player
    {
        return _currentPlayer == _player ? _enemy : _player;
    }

    private var _field : Field;
    public function get field() : Field
    {
        return _field;
    }

    private var _drop : DropList;
    private var _stage : Stage;
    private var _allowPlay : Boolean = true;
    private var _totalMoves : int = 0;
    private var _lastMatch : Match;

    public function get dropList() : DropList
    {
        return _drop;
    }

    public function Match3Game($stage : Stage)
    {

        _stage = $stage;
        _stage.addEventListener(FieldView.SELECT_CELL, handleSelectCell);
        _stage.addEventListener(BattleInventoryView.ITEM_SELECTED, handleSelectSpell);


        _drop = new DropList();

        coreAddListener(Match3Game.CONTINUE, onContinue)
    }

    private function onContinue() : void
    {
        _allowPlay = true;
    }

    private function handleSelectCell(e : Event) : void
    {
        if (currentPlayer == player)
        {
            selectCell(e.data as Cell);
        }
    }

    private function handleSelectSpell(e : Event) : void
    {
        if (!(currentPlayer is AIPlayer))
        {
            var item : Item = e.data as Item;
            if (item && item.isSpell() && checkSpell(item))
            {
                useSpell(item);
            }
        }
    }

    public function init(player : Player, enemy : Player, dropSet : int) : void
    {
        AIPlayer.game = this;
        _allowPlay = true;
        _totalMoves = 0;
        if (_field)
        {
            _field.clear();
        }
        else
        {
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

    }

    public function selectCell(cell : Cell) : void
    {
        _field.selectCell(cell);
    }

    public function checkSpell($spell : Item) : Boolean
    {
        return currentPlayer.checkSpell($spell.uniqueId);
    }

    public function useSpell($item : Item) : void
    {
        if ($item.isSpell())
        {
            currentPlayer.useSpell($item.uniqueId, currentEnemy);
        }

    }

    public function nextMove(player : Player) : void
    {
        if (_currentPlayer)
        {
            _currentPlayer.isCurrent = false;
        }
        _currentPlayer = player;
        _currentPlayer.isCurrent = true;

        if (_currentPlayer is LocalPlayer)
        {
            _totalMoves++;
        }
        if (_allowPlay)
        {
            _currentPlayer.startMove();
            if(_currentPlayer.dealDmgOnMove > 0) {
                var anEnemy : Player = (_currentPlayer == player) ? enemy : player;
                anEnemy.hero.hit(_currentPlayer.dealDmgOnMove);
            }
        }
    }

    private function handleMatch(e : Event) : void
    {
        var attacker : Personage;

        var match : Match = e.data as Match;

        _lastMatch = match;

        var dmg : Number = 0;
        var hitPercent : Number = 0;
        var aim : Personage;

        switch (match.type)
        {
            case MagicTypeVO.CHEST:  // SKULL
                if (!ignoreGraphic)
//                if (currentPlayer is LocalPlayer && !ignoreGraphic)
                {
//                    attacker = currentPlayer.hero;
                    aim = currentEnemy.hero;
                    dmg = currentEnemy.hero.maxHP * (match.amount * 2) / 100;

                    if(currentPlayer.incDmgPercent > 0) {
                        dmg = dmg + dmg * currentPlayer.incDmgPercent;
                    }


//                    match.showDamage(dmg / match.amount);
                    match.showDamage(dmg);
                    hitPercent = aim.hit(dmg, true); // required for calculate drop
//                    trace("CHEST HIT", aim, dmg, hitPercent);
                }
                break;
            default:
                //if (!currentPlayer.pet.isDead && currentPlayer.pet.magic.name == match.type)
                //{
                //    attacker = currentPlayer.pet;
                //} else
                if (match.type == currentPlayer.damageType) {
                    attacker = currentPlayer.hero;
                }

                currentPlayer.manaList.addMana(match.type, match.amount);
                if (!ignoreGraphic)
//                if (currentPlayer is LocalPlayer && !ignoreGraphic)
                {
                    coreDispatch(BattleScreen.PLAY_MANA_FLY, match);
                }
                break;
        }


//        trace("attacker", attacker);
        if (attacker) // we have attacker when its not a skull
        {
            aim = currentEnemy.hero;
//            aim = !currentEnemy.pet.isDead ? currentEnemy.pet : currentEnemy.hero;
            dmg = attacker.damage / 3;
//            if (attacker == Model.instance.player.hero)
//            {
                dmg = dmg * (attacker.damageType == MagicTypeVO.WEAPON ? Model.instance.progress.getSkillMultiplier("2") : Model.instance.progress.getSkillMultiplier("3"));
//            } else {

            if(currentPlayer.incDmgPercent > 0) {
                dmg = dmg + dmg * currentPlayer.incDmgPercent;
            }

                if(currentEnemy.mirrorDamage) {
                    if(currentEnemy.mirrorDamage.isLucky()) {
                        attacker.hit(match.amount * dmg * currentEnemy.mirrorDamage.percent, true);
                    }
                }
//            }
            if(dmg > 0) {
                match.showDamage(match.amount * dmg);
//                match.showDamage(dmg);
                hitPercent = aim.hit(match.amount * dmg);
//                trace("OTHER HIT", aim, dmg, hitPercent);
            }
        }


        if (currentPlayer is LocalPlayer && hitPercent > 0) {
            // drop from monster
            coreDispatch(DropList.GENERATE_DROP, hitPercent, currentEnemy.hero.hp);
        }

    }

    private function handleMove(e : Event) : void
    {
        if(_lastMatch.amount == 5 && currentPlayer.moveAgainOn5) {
            nextMove(currentPlayer);
            return;
        }

        nextMove(currentEnemy);
    }

    private function handlePlayerDead(e : Event) : void
    {
        _allowPlay = false;
        Model.instance.movesAmount = _totalMoves;
        coreDispatch(END_GAME, false);
    }

    private function handleEnemyDead(e : Event) : void
    {
        _allowPlay = false;
        Model.instance.movesAmount = _totalMoves;
        coreDispatch(END_GAME, true);
    }


}
}
