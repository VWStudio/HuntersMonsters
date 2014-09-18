/**
 * Created by agnither on 06.08.14.
 */
package com.agnither.hunters {
import com.agnither.hunters.model.Match3Game;
import com.agnither.hunters.view.ui.UI;
import com.agnither.utils.ResourcesManager;

import starling.display.Stage;
import starling.events.EventDispatcher;

public class GameController extends EventDispatcher {

//    private static var _instance : GameController;
//    public static function get instance() : GameController {
//        if(!_instance) {
//            _instance = new GameController();
//        }
//        return _instance;
//    }
//
//    private var _stage: Stage;
//    private var _resources: ResourcesManager;

//    private var _player: LocalPlayer;
//


    private var _game : Match3Game;
    public function get game() : Match3Game {
        return _game;
    }

    private var _ui : UI;

    public function GameController() {

    }

    public function init(stage : Stage, resources : ResourcesManager) : void {

//        _stage = stage;
//        _resources = resources;
//
//        _player = new LocalPlayer();

//        _game = new Match3Game(_stage);
//
//        _ui = new UI(new CommonRefs(_resources), this);
//
//        _stage.addChildAt(_ui, 0);

        /**
         // inventory
         _stage.addEventListener(ItemsView.ITEM_SELECTED, handleInventoryItemSelected);
         _stage.addEventListener(InventoryView.ITEM_SELECTED, handleInventoryItemSelected);

         // monsters
         _stage.addEventListener(PetsView.PET_SELECTED, handlePetSelected);

         showMap();

         startGame(MonsterVO.DICT[1]);
         */
    }


//    private function showMap() : void {
//        _ui.showScreen(MapScreen.ID);
//        _ui.showScreen(HudScreen.ID);
//    }

//    public function startGame(monster: MonsterVO):void {
//        var enemy: Player = new AIPlayer(monster);
//        _game.init(_player, enemy, monster.drop);
//        _game.addEventListener(Match3Game.END_GAME, handleEndGame);
//
//        _ui.showScreen(BattleScreen.ID);
////
////        _ui.showPopup(InventoryPopup.ID);
//
//    }
//
//    public function endGame():void {
//        _game.removeEventListener(Match3Game.END_GAME, handleEndGame);
//
//        _ui.showPopup(InventoryPopup.ID);
//    }

//    private function handleSelectCell(e: Event):void {
//        if (_game.currentPlayer == _game.player) {
//            _game.selectCell(e.data as Cell);
//        }
//    }
//
//    private function handleSelectSpell(e: Event):void {
//        if (!(_game.currentPlayer is AIPlayer)) {
//            var spell: Spell = e.data as Spell;
//            if (spell && _game.checkSpell(spell)) {
//                _game.useSpell(spell);
//            }
//        }
//    }

//    private function handleEndGame(e: Event):void {
//        for (var i:int = 0; i < _game.dropList.list.length; i++) {
//            var drop: DropSlot = _game.dropList.list[i];
//            if (drop.content) {
//                if (drop.content is GoldDrop) {
//                    var gold: GoldDrop = drop.content as GoldDrop;
//                    _player.addGold(gold.gold);
//                } else if (drop.content is ItemDrop) {
//                    var item: ItemDrop = drop.content as ItemDrop;
//                    _player.addItem(item.item);
//                }
//            }
//        }
//        _player.save();
//
//        endGame();
//    }

//    private function handleSelectMonster(e: Event):void {
//        _ui.showPopup(SelectMonsterPopup.ID);
//    }

//    private function handleInventoryItemSelected(e: Event):void {
//        var item: Item = e.data as Item;
//        _player.selectItem(item);
//    }
//
//    private function handlePetSelected(e: Event):void {
//        var pet: Pet = e.data as Pet;
//        _player.summonPet(pet);
//
//        _ui.hidePopup();
//    }


}
}
