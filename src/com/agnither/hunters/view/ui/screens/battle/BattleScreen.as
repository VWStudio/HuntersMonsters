/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle
{
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.player.Territory;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.personage.Personage;
import com.agnither.hunters.view.ui.common.GoldView;
import com.agnither.hunters.view.ui.popups.house.HousePopup;
import com.agnither.hunters.view.ui.popups.hunt.HuntStepsPopup;
import com.agnither.hunters.view.ui.popups.monsters.SelectMonsterPopup;
import com.agnither.hunters.view.ui.popups.win.WinPopup;
import com.agnither.hunters.view.ui.screens.battle.match3.FieldView;
import com.agnither.hunters.view.ui.screens.battle.player.DropListView;
import com.agnither.hunters.view.ui.screens.battle.player.DropSlotView;
import com.agnither.hunters.view.ui.screens.battle.player.ManaListView;
import com.agnither.hunters.view.ui.screens.battle.player.PersonageView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.BattleInventoryView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.ItemView;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.ui.Screen;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.core.coreRemoveListener;
import com.cemaprjl.viewmanage.ShowPopupCmd;
import com.cemaprjl.viewmanage.ShowScreenCmd;

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import starling.core.Starling;
import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

public class BattleScreen extends Screen
{

    public static const NAME : String = "BattleScreen";

    public static const SELECT_MONSTER : String = "select_monster_BattleScreen";

    private var _game : Match3Game;

    private var _player : PersonageView;
    private var _playerPet : PersonageView;
    private var _enemy : PersonageView;
    private var _enemyPet : PersonageView;

    private var _playerMana : ManaListView;
    private var _enemyMana : ManaListView;

    private var _playerSpells : BattleInventoryView;
    private var _enemySpells : BattleInventoryView;

    private var _dropList : DropListView;

    private var _summonPetBtn : Button;

    private var _field : FieldView;
    private var _tooltip : Sprite;
    public static const PLAY_CHEST_FLY : String = "BattleScreen.PLAY_CHEST_FLY";
    private var _effects : Sprite;
    public static const PLAY_MANA_FLY : String = "BattleScreen.PLAY_MANA_FLY";
    private var _timeout : uint;

    public function BattleScreen()
    {
    }


    override public function onRemove() : void
    {

        coreRemoveListener(DropSlotView.SHOW_TOOLTIP, onShowTooltip);
        coreRemoveListener(DropSlotView.HIDE_TOOLTIP, onHideTooltip);

    }

    override protected function initialize() : void
    {


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
        addChild(_playerSpells);
        _playerSpells.x = _links.slotsPlayer.x;
        _playerSpells.y = _links.slotsPlayer.y;

        _enemySpells = new BattleInventoryView();
        addChild(_enemySpells);
        _enemySpells.x = _links.slotsEnemy.x;
        _enemySpells.y = _links.slotsEnemy.y;


        _dropList = _links.drop;

        _field = new FieldView();
        addChild(_field);

        _links.slotsPlayer.visible = false;
        _links.slotsEnemy.visible = false;

        _tooltip = new Sprite();

        _effects = new Sprite();
    }

    public function clear() : void
    {
        _field.clear();


    }

    override public function update() : void
    {

        if (!_game)
        {
            _game = new Match3Game(stage);
        }
        _game.init(Model.instance.player, Model.instance.enemy, Model.instance.drop);

        _field.clear();
        _field.field = _game.field;

        _playerSpells.inventory = _game.player.inventory;
        _enemySpells.inventory = _game.enemy.inventory;

        _player.personage = _game.player.hero;
        _playerPet.personage = _game.player.pet;
//        _game.player.pet.addEventListener(Personage.DEAD, handlePetDead);
        _enemy.isStandRight = true;
        _enemy.personage = _game.enemy.hero;
        _enemyPet.personage = _game.enemy.pet;

        _game.player.resetMana();
        _game.enemy.resetMana();
        _playerMana.mana = _game.player.manaList;
        _enemyMana.mana = _game.enemy.manaList;

        _dropList.drop = _game.dropList;


        addChild(_tooltip);
        _tooltip.visible = false;

        addChild(_effects);

        coreAddListener(Match3Game.END_GAME, handleEndGame);
        coreAddListener(BattleScreen.PLAY_CHEST_FLY, onDropFly);
        coreAddListener(BattleScreen.PLAY_MANA_FLY, onManaFly);
        coreAddListener(DropSlotView.SHOW_TOOLTIP, onShowTooltip);
        coreAddListener(DropSlotView.HIDE_TOOLTIP, onHideTooltip);

        /**
         * call nextMove after all view init add first time mana from magic item it exists
         */
        _game.nextMove(_game.player);
    }

    private function handlePetDead(event : Personage) : void
    {

    }

    private function onManaFly($data : Object) : void
    {

        var magicType : MagicTypeVO = MagicTypeVO.DICT[$data.type];
        var pictureUrl : String = magicType.picturedamage;
        var img : Image = new Image(App.instance.refs.gui.getTexture(pictureUrl));
        _effects.addChild(img);
        var position : Point = $data.position;
        img.x = position.x * FieldView.tileX + FieldView.fieldX;
        img.y = position.y * FieldView.tileY + FieldView.fieldY;
        img.scaleX = img.scaleY = 2;

        Starling.juggler.tween(img, 0.5, {x: img.x, y: img.y - 50, onComplete: onEndTween, alpha: 0.5});

        function onEndTween() : void
        {
            _effects.removeChild(img);
        }

    }

    private function onDropFly($data : Object) : void
    {

        var drop : Item = $data.drop as Item;
        var position : Point = $data.position;
        var pictureUrl : String = drop.icon;
        var img : Image = new Image(App.instance.refs.gui.getTexture(pictureUrl));
        _effects.addChild(img);
        img.x = position.x * FieldView.tileX + FieldView.fieldX;
        img.y = position.y * FieldView.tileY + FieldView.fieldY;

        Starling.juggler.tween(img, 0.5, {x: img.x, y: img.y - 50, onComplete: onEndTween, alpha: 0.5});

        function onEndTween() : void
        {
            _effects.removeChild(img);
        }

    }

    private function onHideTooltip() : void
    {
        _tooltip.visible = false;
        _tooltip.removeChildren();
    }

    private function onShowTooltip($data : Object) : void
    {

        var item : Item = $data.content;

        if (item.isGold())
        {
            var gv : GoldView = new GoldView();
            _tooltip.addChild(gv);
            gv.data = item.amount;
            gv.update();

        }
        else
        {
            _tooltip.addChild(ItemView.getItemView(item));
            _tooltip.visible = true;
        }
        _tooltip.visible = true;
        var rect : Rectangle = ($data.item as Sprite).getBounds(this);
        _tooltip.x = rect.x + rect.width + 5;
        _tooltip.y = rect.y + rect.height + 5;
    }


    private function handleEndGame($isWin : Boolean) : void
    {

        coreRemoveListener(Match3Game.END_GAME, handleEndGame);
        _timeout = setTimeout(gameEnds, 2500, $isWin);


    }

    private function gameEnds($isWin : Boolean) : void
    {

        clearTimeout(_timeout);
        coreExecute(ShowScreenCmd, MapScreen.NAME);

        switch (Model.instance.match3mode)
        {
            case Match3Game.MODE_STEP:
                if (App.instance.chestStep >= 0)
                {
                    if ($isWin)
                    {
                        if (App.instance.chestStep + 1 < App.instance.steps.length)
                        {
                            App.instance.chestStep++;
                            coreExecute(ShowPopupCmd, HuntStepsPopup.NAME, {mode: HuntStepsPopup.CONTINUE_MODE});
                        }
                        else
                        {
                            coreExecute(ShowPopupCmd, HuntStepsPopup.NAME, {mode: HuntStepsPopup.WIN_MODE});
                        }
                    }
                    else
                    {
                        coreExecute(ShowPopupCmd, HuntStepsPopup.NAME, {mode: HuntStepsPopup.LOSE_MODE});
                    }
                    return;
                }
                else
                {
                    coreExecute(ShowPopupCmd, WinPopup.NAME, {isWin: $isWin});
                }
                break;

            case Match3Game.MODE_REGULAR:
                coreExecute(ShowPopupCmd, WinPopup.NAME, {isWin: $isWin, drops: _game.dropList});
                break;
            case Match3Game.MODE_HOUSE:
                var territory : Territory = Model.instance.currentHouseTerritory;
                if ($isWin)
                {
                    Model.instance.progress.areaStars[territory.area.area] = 1;
                    Model.instance.progress.sets.push(territory.area.area);
                    Model.instance.progress.houses.push(territory.area.area);
                    Model.instance.progress.saveProgress();
                    territory.updateStars();
                    territory.updateHouseData();
                }
                else
                {

                }

                coreExecute(ShowPopupCmd, HousePopup.NAME, territory);
                break;
        }


    }


    private function handleClick(e : Event) : void
    {
        coreExecute(ShowPopupCmd, SelectMonsterPopup.NAME);
    }


}
}
