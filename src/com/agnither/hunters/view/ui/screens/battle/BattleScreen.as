/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle {
import com.agnither.hunters.App;
import com.agnither.hunters.GameController;
import com.agnither.hunters.model.Match3Game;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.popups.SelectMonsterPopup;
import com.agnither.hunters.view.ui.screens.battle.match3.FieldView;
import com.agnither.hunters.view.ui.screens.battle.player.DropListView;
import com.agnither.hunters.view.ui.screens.battle.player.PersonageView;
import com.agnither.hunters.view.ui.screens.battle.player.ManaListView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.BattleInventoryView;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;

public class BattleScreen extends Screen {

    public static const ID: String = "BattleScreen";

    public static const SELECT_MONSTER: String = "select_monster_BattleScreen";

    private var _game: Match3Game;

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

    public function BattleScreen() {
    }

    override protected function initialize():void {
        _game = App.instance.game;

        createFromConfig(_refs.guiConfig.battle_screen);

        FieldView.fieldX = _links.chip00.x;
        FieldView.fieldY = _links.chip00.y;
        FieldView.tileX = _links.chip10.x - _links.chip00.x;
        FieldView.tileY = _links.chip01.y - _links.chip00.y;

        _links.chip00.removeFromParent(true);
        _links.chip01.removeFromParent(true);
        _links.chip10.removeFromParent(true);

        _player = _links.heroPlayer;
        _playerPet = _links.petPlayer;
        _enemy = _links.heroEnemy;
        _enemyPet = _links.petEnemy;
        _summonPetBtn = _links.pet_btn;
        _summonPetBtn.addEventListener(Event.TRIGGERED, handleClick);

        _playerMana = _links.manaPlayer;
        _enemyMana = _links.manaEnemy;

        _playerSpells = new BattleInventoryView();
        _playerSpells.x = _links.slotsPlayer.x;
        _playerSpells.y = _links.slotsPlayer.y;
        addChild(_playerSpells);

        _enemySpells = new BattleInventoryView();
        _enemySpells.x = _links.slotsEnemy.x;
        _enemySpells.y = _links.slotsEnemy.y;
        addChild(_enemySpells);


        _dropList = _links.drop;

        _field = new FieldView();
        addChild(_field);

        _links.slotsPlayer.visible = false;
        _links.slotsEnemy.visible = false;

    }


    override public function update() : void {

        _field.clear();

        _field.field = _game.field;

        _playerSpells.inventory = _game.player.inventory;
        _enemySpells.inventory = _game.enemy.inventory;

        _player.personage = _game.player.hero;
        _playerPet.personage = _game.player.pet;
        _enemy.personage = _game.enemy.hero;
        _enemyPet.personage = _game.enemy.pet;

        _game.player.resetMana();
        _game.enemy.resetMana();
        _playerMana.mana = _game.player.manaList;
        _enemyMana.mana = _game.enemy.manaList;

        _dropList.drop = _game.dropList;
    }

    private function handleClick(e: Event):void {
        dispatchEventWith(UI.SHOW_POPUP, true, SelectMonsterPopup.ID);
    }



}
}
