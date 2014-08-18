/**
 * Created by agnither on 06.08.14.
 */
package com.agnither.hunters {
import com.agnither.hunters.model.match3.Cell;
import com.agnither.hunters.model.Game;
import com.agnither.hunters.model.player.Spell;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.screens.BattleScreen;
import com.agnither.hunters.view.ui.screens.battle.match3.FieldView;
import com.agnither.hunters.view.ui.screens.battle.player.SpellView;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.ResourcesManager;

import starling.display.Stage;
import starling.events.Event;
import starling.events.EventDispatcher;

public class GameController extends EventDispatcher {

    private var _stage: Stage;
    private var _resources: ResourcesManager;

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
        _game = new Game();

        _ui = new UI(new CommonRefs(_resources), this);
        _stage.addChildAt(_ui, 0);

        _stage.addEventListener(FieldView.SELECT_CELL, handleSelectCell);
        _stage.addEventListener(SpellView.SPELL_SELECTED, handleSelectSpell);
    }

    public function ready():void {
        _game.init();

        _ui.showScreen(BattleScreen.ID);
    }

    private function handleSelectCell(e: Event):void {
        if (_game.currentPlayer == _game.player) {
            _game.selectCell(e.data as Cell);
        }
    }

    private function handleSelectSpell(e: Event):void {
        if (_game.currentPlayer == _game.player) {
            var spell: Spell = e.data as Spell;
            if (_game.checkSpell(spell)) {
                _game.useSpell(spell);
            }
        }
    }
}
}
