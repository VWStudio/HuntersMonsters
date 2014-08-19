/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens {
import com.agnither.hunters.model.Game;
import com.agnither.hunters.view.ui.screens.battle.match3.FieldView;
import com.agnither.hunters.view.ui.screens.battle.player.DropListView;
import com.agnither.hunters.view.ui.screens.battle.player.HeroView;
import com.agnither.hunters.view.ui.screens.battle.player.ManaListView;
import com.agnither.hunters.view.ui.screens.battle.player.SpellsListView;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

public class BattleScreen extends Screen {

    public static const ID: String = "BattleScreen";

    private var _game: Game;

    private var _player: HeroView;
    private var _enemy: HeroView;

    private var _playerMana: ManaListView;
    private var _enemyMana: ManaListView;

    private var _playerSpells: SpellsListView;
    private var _enemySpells: SpellsListView;

    private var _dropList: DropListView;

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
        _player = new HeroView(_refs, _game.player.personage);
        _player.x = _links.heroPlayer.x;
        _player.y = _links.heroPlayer.y;
        addChild(_player);

        _links.heroEnemy.visible = false;
        _enemy = new HeroView(_refs, _game.enemy.personage);
        _enemy.x = _links.heroEnemy.x;
        _enemy.y = _links.heroEnemy.y;
        addChild(_enemy);

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

        _links.spellsPlayer.visible = false;
        _playerSpells = new SpellsListView(_refs, _game.player.spells);
        _playerSpells.x = _links.spellsPlayer.x;
        _playerSpells.y = _links.spellsPlayer.y;
        addChild(_playerSpells);

        _links.spellsEnemy.visible = false;
        _enemySpells = new SpellsListView(_refs, _game.enemy.spells);
        _enemySpells.x = _links.spellsEnemy.x;
        _enemySpells.y = _links.spellsEnemy.y;
        addChild(_enemySpells);

        _links.drop.visible = false;
        _dropList = new DropListView(_refs, _game.dropList);
        _dropList.x = _links.drop.x;
        _dropList.y = _links.drop.y;
        addChild(_dropList);

        _field = new FieldView(_refs, _game.field);
        addChild(_field);
    }
}
}
