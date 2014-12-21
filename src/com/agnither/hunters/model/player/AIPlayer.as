/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player
{
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.match3.Move;
import com.agnither.hunters.model.match3.MoveResult;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.ai.CheckManaResult;
import com.agnither.hunters.model.player.inventory.Item;
import com.cemaprjl.utils.Util;

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
    private var _chestResults : Array = [];

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
        var petItem : ItemVO = ItemVO.createPetItemVO(monster);
        petItem.id = 24;
        petItem.slot = 1;
        items[petItem.id] = petItem;


        inventory.unshift(petItem.id.toString());
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


    }

    private function processMoves() : void
    {
        _damageResults = [];
        _chestResults = [];
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
//                if(_damageResults.indexOf(result) == -1) {
                    _damageResults.push(result);
//                }
            }
            else if(result.isHaveResultType(MagicTypeVO.CHEST))
            {
                    _chestResults.push(result);
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
//                        if(_currentSpellsObj[_currentSpellsMana[ii]].indexOf(result) == -1) {
                            _currentSpellsObj[_currentSpellsMana[ii]].push(result);
//                        }
                        used = true;
                    }
                }
                if(!used) {
//                    if(_otherResults.indexOf(result) == -1) {
                        _otherResults.push(result);
//                    }
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
//                , spells:_currentSpellsObj, mana : _currentSpellsMana, other : _otherResults} ));
        if(_damageResults.length > 0) {
//            trace(JSON.stringify(_damageResults));
//            trace("DAMAGE RES");
            results = _damageResults;
        }
        else if(_chestResults.length > 0)
        {
            results = _chestResults;
        }
        else
        {
//            trace(JSON.stringify(_currentSpellsObj));
//            trace(JSON.stringify(_currentSpellsMana));
            for (var i : int = 0; i < _currentSpellsMana.length; i++)
            {
                var manaID : String = _currentSpellsMana[i];
                if(_currentSpellsObj[manaID] && _currentSpellsObj[manaID].length > 0) {
                    results = _currentSpellsObj[manaID];
//                    trace("SPELLS RES", manaID);
                }
            }
            if(!results) {
//                trace(JSON.stringify(_otherResults));
//                trace("OTHER RES");
                results = _otherResults;
            }
//            if(_spellMovesResults.length > 0)
//            results = _spellMovesResults;
        }

        results.sort(sortResults);
//        results.sortOn("score", Array.NUMERIC);

        var rand : int = (100 - difficulty) / 100 * results.length * Math.random();
//        trace(rand, difficulty, JSON.stringify(results));
        var move : Move = results[rand].move;

        Starling.juggler.delayCall(game.selectCell, 0.5, move.cell2);
        Starling.juggler.delayCall(game.selectCell, 1, move.cell1);
    }

    private function sortResults($a : MoveResult, $b : MoveResult) : Number
    {
        if($a.score > $b.score) return -1;
        if($a.score < $b.score) return 1;
        return 0;
    }
}
}
