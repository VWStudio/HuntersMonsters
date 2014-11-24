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

    private var _spellResults : Dictionary;
    private var _weaponResults : Array;
    private var _otherResults : Array;
    private var _spellMovesResults : Array;

    public function AIPlayer(data : MonsterVO) : void
    {
        _difficulty = data.difficulty;
        super();

        init(data);
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

    private function processSpells(difficulty : int) : void
    {
        var results : Array = [];
        if (Math.random() * 100 < difficulty)
        {
            for (var i : int = 0; i < _inventory.inventoryItems.length; i++)
            {

                var spellItem : Item = _inventory.getItem(_inventory.inventoryItems[i]);
//                var spell: Spell = _inventory.getItem(_inventory.inventoryItems[i]) as Spell;
                if (spellItem.isSpell())
                {
                    var result : CheckManaResult = new CheckManaResult(_manaList, spellItem);
                    if (result.enough)
                    {

                        game.useSpell(spellItem);
                    }
                    else
                    {
                        results.push(result);
                    }
                }
            }
        }

        _spellResults = new Dictionary();
        if (results.length > 0)
        {
            results.sortOn("delta", Array.NUMERIC);
            for (var key : * in results[0].results)
            {
                _spellResults[key] = true;
            }
        }
    }

    private function processMoves() : void
    {
        _weaponResults = [];
        _otherResults = [];
        _spellMovesResults = [];
        var moves : Vector.<Move> = game.field.availableMoves;
        var l : int = moves.length;
        for (var i : int = 0; i < l; i++)
        {
            var result : MoveResult = game.field.checkMove(moves[i], _spellResults);
            if (result.haveWeapon)
            {
                _weaponResults.push(result);
            }
            else
            {
                _otherResults.push(result);
            }
        }
    }

    private function selectMove(difficulty : int) : void
    {
        var results : Array = _weaponResults.length > 0 ? _weaponResults : _otherResults;
        results.sortOn("score", Array.NUMERIC);

        var rand : int = (100 - difficulty) / 100 * results.length * Math.random();
        var move : Move = results[rand].move;

        Starling.juggler.delayCall(game.selectCell, 0.5, move.cell2);
        Starling.juggler.delayCall(game.selectCell, 1, move.cell1);
    }
}
}
