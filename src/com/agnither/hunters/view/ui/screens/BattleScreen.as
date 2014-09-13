/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens {
import com.agnither.hunters.model.Game;
import com.agnither.hunters.view.ui.screens.battle.match3.FieldView;
import com.agnither.hunters.view.ui.screens.battle.player.DropListView;
import com.agnither.hunters.view.ui.screens.battle.player.PersonageView;
import com.agnither.hunters.view.ui.screens.battle.player.ManaListView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.BattleInventoryView;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

import starling.display.Button;
import starling.events.Event;

public class BattleScreen extends Screen {

    public static const ID: String = "BattleScreen";

    public static const SELECT_MONSTER: String = "select_monster_BattleScreen";

    private var _game: Game;

    private var _player: PersonageView;
    private var _playerPet: PersonageView;
    private var _enemy: PersonageView;
    private var _enemyPet: PersonageView;

    private var _playerMana: ManaListView;
    private var _enemyMana: ManaListView;

    private var _playerSpells: BattleInventoryView;
    private var _enemySpells: BattleInventoryView;

    private var _dropList: DropListView;

    private var _summonPetBtn: Button;

    private var _field: FieldView;

    public function BattleScreen(refs:CommonRefs, game: Game) {
        _game = game;

        super(refs);
    }

    override protected function initialize():void {
        createFromConfig(_refs.guiConfig.battle_screen);

        FieldView.fieldX = _links.chip00.x;
        FieldView.fieldY = _links.chip00.y;
        FieldView.tileX = _links.chip10.x - _links.chip00.x;
        FieldView.tileY = _links.chip01.y - _links.chip00.y;

        _links.chip00.removeFromParent(true);
        _links.chip01.removeFromParent(true);
        _links.chip10.removeFromParent(true);

        _player = _links.heroPlayer;
        _player.personage = _game.player.hero;

        _playerPet = _links.petPlayer;
        _playerPet.personage = _game.player.pet;

        _enemy = _links.heroEnemy;
        _enemy.personage = _game.enemy.hero;

        _enemyPet = _links.petEnemy;
        _enemyPet.personage = _game.enemy.pet;

        _summonPetBtn = _links.pet_btn;
        _summonPetBtn.addEventListener(Event.TRIGGERED, handleClick);

        _playerMana = _links.manaPlayer;
        _playerMana.mana = _game.player.manaList;

        _enemyMana = _links.manaEnemy;
        _enemyMana.mana = _game.enemy.manaList;

        _links.slotsPlayer.visible = false;
        _playerSpells = new BattleInventoryView(_refs, _game.player.inventory);
        _playerSpells.x = _links.slotsPlayer.x;
        _playerSpells.y = _links.slotsPlayer.y;
        addChild(_playerSpells);

        _links.slotsEnemy.visible = false;
        _enemySpells = new BattleInventoryView(_refs, _game.enemy.inventory);
        _enemySpells.x = _links.slotsEnemy.x;
        _enemySpells.y = _links.slotsEnemy.y;
        addChild(_enemySpells);

        _dropList = _links.drop;
        _dropList.drop = _game.dropList;

        _field = new FieldView(_refs, _game.field);
        addChild(_field);
    }

    private function handleClick(e: Event):void {
        dispatchEventWith(SELECT_MONSTER, true);
    }
}
}
