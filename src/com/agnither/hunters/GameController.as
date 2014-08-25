/**
 * Created by agnither on 06.08.14.
 */
package com.agnither.hunters {
import com.agnither.hunters.data.outer.MonsterVO;
import com.agnither.hunters.model.match3.Cell;
import com.agnither.hunters.model.Game;
import com.agnither.hunters.model.player.AIPlayer;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.drop.DropSlot;
import com.agnither.hunters.model.player.drop.GoldDrop;
import com.agnither.hunters.model.player.drop.ItemDrop;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.inventory.Spell;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.popups.InventoryPopup;
import com.agnither.hunters.view.ui.popups.InventoryView;
import com.agnither.hunters.view.ui.screens.BattleScreen;
import com.agnither.hunters.view.ui.screens.battle.match3.FieldView;
import com.agnither.hunters.view.ui.popups.ItemsView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.BattleInventoryView;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.ResourcesManager;

import starling.display.Stage;
import starling.events.Event;
import starling.events.EventDispatcher;

public class GameController extends EventDispatcher {

    private var _stage: Stage;
    private var _resources: ResourcesManager;

    private var _player: LocalPlayer;
    public function get player():LocalPlayer {
        return _player;
    }

    private var _game: Game;
    public function get game():Game {
        return _game;
    }

    private var _ui: UI;

    public function GameController(stage: Stage, resources: ResourcesManager) {
        _stage = stage;
        _resources = resources;
    }

    public function init():void {
        _player = new LocalPlayer();

        _game = new Game();

        _ui = new UI(new CommonRefs(_resources), this);
        _stage.addChildAt(_ui, 0);

        // battle
        _stage.addEventListener(FieldView.SELECT_CELL, handleSelectCell);
        _stage.addEventListener(BattleInventoryView.ITEM_SELECTED, handleSelectSpell);

        // inventory
        _stage.addEventListener(ItemsView.ITEM_SELECTED, handleInventoryItemSelected);
        _stage.addEventListener(InventoryView.ITEM_SELECTED, handleInventoryItemSelected);

        startGame(MonsterVO.DICT[1]);
    }

    public function startGame(monster: MonsterVO):void {
        var enemy: Player = new AIPlayer(monster);
        _game.init(_player, enemy, monster.drop);
        _game.addEventListener(Game.END_GAME, handleEndGame);

        _ui.showScreen(BattleScreen.ID);

        _ui.showPopup(InventoryPopup.ID);
    }

    public function endGame():void {
        _game.removeEventListener(Game.END_GAME, handleEndGame);

        _ui.showPopup(InventoryPopup.ID);
    }

    private function handleSelectCell(e: Event):void {
        if (_game.currentPlayer == _game.player) {
            _game.selectCell(e.data as Cell);
        }
    }

    private function handleSelectSpell(e: Event):void {
        if (!(_game.currentPlayer is AIPlayer)) {
            var spell: Spell = e.data as Spell;
            if (spell && _game.checkSpell(spell)) {
                _game.useSpell(spell);
            }
        }
    }

    private function handleEndGame(e: Event):void {
        for (var i:int = 0; i < _game.dropList.list.length; i++) {
            var drop: DropSlot = _game.dropList.list[i];
            if (drop.content) {
                if (drop.content is GoldDrop) {
                    var gold: GoldDrop = drop.content as GoldDrop;
                    _player.addGold(gold.gold);
                } else if (drop.content is ItemDrop) {
                    var item: ItemDrop = drop.content as ItemDrop;
                    _player.addItem(item.item);
                }
            }
        }
        _player.save();

        endGame();
    }

    private function handleInventoryItemSelected(e: Event):void {
        var item: Item = e.data as Item;
        _player.selectItem(item);
    }
}
}
