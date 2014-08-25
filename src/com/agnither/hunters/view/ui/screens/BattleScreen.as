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
        createFromConfig(_refs.guiConfig.battleScreen);

        FieldView.fieldX = _links.chip00.x;
        FieldView.fieldY = _links.chip00.y;
        FieldView.tileX = _links.chip10.x - _links.chip00.x;
        FieldView.tileY = _links.chip01.y - _links.chip00.y;

        _links.chip00.removeFromParent(true);
        _links.chip01.removeFromParent(true);
        _links.chip10.removeFromParent(true);

        _links.heroPlayer.visible = false;
        _player = new PersonageView(_refs, _game.player.hero);
        _player.x = _links.heroPlayer.x;
        _player.y = _links.heroPlayer.y;
        addChild(_player);

        _links.petPlayer.visible = false;
        _playerPet = new PersonageView(_refs, _game.player.pet);
        _playerPet.x = _links.petPlayer.x;
        _playerPet.y = _links.petPlayer.y;
        addChild(_playerPet);

        _links.heroEnemy.visible = false;
        _enemy = new PersonageView(_refs, _game.enemy.hero);
        _enemy.x = _links.heroEnemy.x;
        _enemy.y = _links.heroEnemy.y;
        addChild(_enemy);

        _links.petEnemy.visible = false;
        _enemyPet = new PersonageView(_refs, _game.enemy.pet);
        _enemyPet.x = _links.petEnemy.x;
        _enemyPet.y = _links.petEnemy.y;
        addChild(_enemyPet);

        _summonPetBtn = _links.pet_btn;
        _summonPetBtn.addEventListener(Event.TRIGGERED, handleClick);

        _links.manaPlayer.visible = false;
        _playerMana = new ManaListView(_refs, _game.player.manaList);
        _playerMana.x = _links.manaPlayer.x;
        _playerMana.y = _links.manaPlayer.y;
        addChild(_playerMana);

        _links.manaEnemy.visible = false;
        _enemyMana = new ManaListView(_refs, _game.enemy.manaList);
        _enemyMana.x = _links.manaEnemy.x;
        _enemyMana.y = _links.manaEnemy.y;
        addChild(_enemyMana);

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

        _links.drop.visible = false;
        _dropList = new DropListView(_refs, _game.dropList);
        _dropList.x = _links.drop.x;
        _dropList.y = _links.drop.y;
        addChild(_dropList);

        _field = new FieldView(_refs, _game.field);
        addChild(_field);
    }

    private function handleClick(e: Event):void {
        dispatchEventWith(SELECT_MONSTER, true);
    }
}
}
