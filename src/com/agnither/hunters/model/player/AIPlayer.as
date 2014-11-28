/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player
{
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.match3.Move;
import com.agnither.hunters.model.match3.MoveResult;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.ai.CheckManaResult;
import com.agnither.hunters.model.player.inventory.Item;

import flash.utils.Dictionary;

import starling.core.Starling;

public class AIPlayer extends Player
{

    public static var game : Match3Game;

    private var _difficulty : int;

//    private var _spellResults : Dictionary;
    private var _damageResults : Array;
    private var _otherResults : Array;
//    private var _spellMovesResults : Array;
    private var _currentSpellsObj : Object = {};
    private var _currentSpellsMana : Array = [];

    public function AIPlayer(data : MonsterVO) : void
    {
        _difficulty = data.difficulty;
        super();

        init(data);
        _hero.damageType = data.damagetype;
        loadInventory(data);
    }

    private function loadInventory(monster : MonsterVO) : void
    {
        var items : Object = {};
        var inventory : Array = [];
        for (var i : int = 0; i < monster.items.length; i++)
        {
            var id : int = monster.items[i];
            items[id] = Model.instance.items.getItemVO(id);
            inventory.push(id);
        }
        initInventory(items, inventory);
    }

    override public function startMove() : void
    {
        processSpells(_difficulty);
        processMoves();
        selectMove(_difficulty);
    }

    private function processSpells(difficulty : int) : Boolean
    {
        for (var key : String in _inventory.spells)
        {
            var spellItem : Item = _inventory.spells[key];
            var result : CheckManaResult = new CheckManaResult(_manaList, spellItem);
            if (result.enough)
            {
                game.useSpell(spellItem);
                return processSpells(difficulty);
            }
        }
        return false;

//        var results : Array = [];
//        if (Math.random() * 100 < difficulty)
//        {
//            for (var i : int = 0; i < _inventory.length; i++)
//            {
//
//                var spellItem : Item = _inventory.getItem(_inventory.inventoryItems[i]);
////                var spell: Spell = _inventory.getItem(_inventory.inventoryItems[i]) as Spell;
//                if (spellItem.isSpell())
//                {
//                    var result : CheckManaResult = new CheckManaResult(_manaList, spellItem);
//                    if (result.enough)
//                    {
//
//                        game.useSpell(spellItem);
//                    }
////                    else
////                    {
////                        results.push(result);
////                    }
//                }
//            }
////        }

//        _spellResults = new Dictionary();
//        if (results.length > 0)
//        {
//            results.sortOn("delta", Array.NUMERIC);
//            for (var key : * in results[0].results)
//            {
//                _spellResults[key] = true;
//            }
//        }
    }

    private function processMoves() : void
    {
        _damageResults = [];
        _currentSpellsMana = hero.inventory.manaPriority;
        _currentSpellsObj = {};
        _otherResults = [];



//        _spellMovesResults = [];


        var currentType : String = hero.damageType;

        var moves : Vector.<Move> = game.field.availableMoves;
        var l : int = moves.length;
        for (var i : int = 0; i < l; i++)
        {
            var result : MoveResult = game.field.checkMove(moves[i], new Dictionary());
//            var result : MoveResult = game.field.checkMove(moves[i], _spellResults);

            if (result.isHaveResultType(currentType))
            {
                _damageResults.push(result);
            }
            else
            {
                var used : Boolean = false;
                for (var ii : int = 0; ii < _currentSpellsMana.length; ii++)
                {
                    if(result.isHaveResultType(_currentSpellsMana[ii]))
                    {
//                        _spellMovesResults.push(result);
                        if(!_currentSpellsObj[_currentSpellsMana[ii]]) {
                            _currentSpellsObj[_currentSpellsMana[ii]] = [];
                        }
                        _currentSpellsObj[_currentSpellsMana[ii]].push(result);
                        used = true;
                    }
                }
                if(!used) {
                    _otherResults.push(result);
                }
            }
        }

//        _spellMovesResults.sort(sortSpellMoves);
//        function sortSpellMoves($a : MoveResult, $b : MoveResult) : Number
//        {
//            for (var i : int = 0; i < currentSpellsMana.length; i++)
//            {
//                var haveA : Boolean =
//
//                if($a.isHaveResultType(currentSpellsMana[i]))
//
//            }
//
//
//
//        }

    }


    private function selectMove(difficulty : int) : void
    {
        var results : Array;
        if(_damageResults.length > 0) {
            results = _damageResults;
        }
        else
        {
            for (var i : int = 0; i < _currentSpellsMana.length; i++)
            {
                var manaID : String = _currentSpellsMana[i];
                if(_currentSpellsObj[manaID] && _currentSpellsObj[manaID].length > 0) {
                    results = _currentSpellsObj[manaID];
                }
            }
            if(!results) {
                results = _otherResults;
            }
//            if(_spellMovesResults.length > 0)
//            results = _spellMovesResults;
        }

        results.sortOn("score", Array.NUMERIC);

        var rand : int = (100 - difficulty) / 100 * results.length * Math.random();
        var move : Move = results[rand].move;

        Starling.juggler.delayCall(game.selectCell, 0.5, move.cell2);
        Starling.juggler.delayCall(game.selectCell, 1, move.cell1);
    }
}
}
