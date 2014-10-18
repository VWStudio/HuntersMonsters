/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle {
import com.agnither.hunters.App;
import com.agnither.hunters.App;
import com.agnither.hunters.App;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.drop.DropSlot;
import com.agnither.hunters.model.player.drop.GoldDrop;
import com.agnither.hunters.model.player.drop.GoldDrop;
import com.agnither.hunters.model.player.drop.ItemDrop;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.common.GoldView;
import com.agnither.hunters.view.ui.popups.SelectMonsterPopup;
import com.agnither.hunters.view.ui.popups.house.HousePopup;
import com.agnither.hunters.view.ui.popups.hunt.HuntStepsPopup;
import com.agnither.hunters.view.ui.popups.win.WinPopup;
import com.agnither.hunters.view.ui.screens.battle.match3.FieldView;
import com.agnither.hunters.view.ui.screens.battle.player.DropListView;
import com.agnither.hunters.view.ui.screens.battle.player.DropSlotView;
import com.agnither.hunters.view.ui.screens.battle.player.PersonageView;
import com.agnither.hunters.view.ui.screens.battle.player.ManaListView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.BattleInventoryView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.ItemView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.ItemView;
import com.agnither.hunters.view.ui.screens.map.HousePoint;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.core.coreRemoveListener;
import com.cemaprjl.viewmanage.ShowPopupCmd;
import com.cemaprjl.viewmanage.ShowScreenCmd;

import flash.geom.Rectangle;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;

public class BattleScreen extends Screen {

    public static const NAME: String = "BattleScreen";

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
    private var _tooltip : Sprite;

    public function BattleScreen() {
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

    public function clear():void {
        _field.clear();


    }

    override public function update() : void {

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
        _enemy.personage = _game.enemy.hero;
        _enemyPet.personage = _game.enemy.pet;

        _game.player.resetMana();
        _game.enemy.resetMana();
        _playerMana.mana = _game.player.manaList;
        _enemyMana.mana = _game.enemy.manaList;

        _dropList.drop = _game.dropList;

        _tooltip = new Sprite();
        addChild(_tooltip);
        _tooltip.visible = false;

        coreAddListener(Match3Game.END_GAME, handleEndGame);
        coreAddListener(DropSlotView.SHOW_TOOLTIP, onShowTooltip);
        coreAddListener(DropSlotView.HIDE_TOOLTIP, onHideTooltip);
    }

    private function onHideTooltip() : void {
        _tooltip.visible = false;
        _tooltip.removeChildren();
    }

    private function onShowTooltip($data : Object) : void {

        if($data.content is ItemDrop) {
            _tooltip.addChild(ItemView.getItemView(($data.content as ItemDrop).item));
            _tooltip.visible = true;

        } else if ($data.content is GoldDrop) {
            var gv : GoldView = new GoldView();
            _tooltip.addChild(gv);
            gv.data = ($data.content as GoldDrop).gold;
            gv.update();
        }
        _tooltip.visible = true;
        var rect : Rectangle = ($data.item as Sprite).getBounds(this);
        _tooltip.x = rect.x + rect.width + 5;
        _tooltip.y = rect.y + rect.height + 5;
    }


    private function handleEndGame($isWin : Boolean) : void {
        coreRemoveListener(Match3Game.END_GAME, handleEndGame);
        switch (Model.instance.match3mode) {
            case Match3Game.MODE_STEP:
                if(App.instance.chestStep >= 0) {
                    if($isWin) {
                        if(App.instance.chestStep + 1 < App.instance.steps.length) {
                            App.instance.chestStep++;
                            coreExecute(ShowPopupCmd, HuntStepsPopup.NAME, {mode : HuntStepsPopup.CONTINUE_MODE});
                        } else {
                            coreExecute(ShowPopupCmd, HuntStepsPopup.NAME, {mode : HuntStepsPopup.WIN_MODE});
                        }
                    } else {
                        coreExecute(ShowPopupCmd, HuntStepsPopup.NAME, {mode : HuntStepsPopup.LOSE_MODE});
                    }

                    coreExecute(ShowScreenCmd, MapScreen.NAME);
                    return;
                } else {
                    coreExecute(ShowPopupCmd, WinPopup.NAME, {isWin : $isWin});
                }
                break;

            case Match3Game.MODE_REGULAR:
                coreExecute(ShowPopupCmd, WinPopup.NAME, {isWin : $isWin, drops:_game.dropList});
                break;
            case Match3Game.MODE_HOUSE:
                coreExecute(ShowScreenCmd, MapScreen.NAME);
                var pt : HousePoint = Model.instance.currentHousePoint;
                if($isWin) {
                    Model.instance.houses[pt.name]["owner"] = Model.instance.player.id;
                    Model.instance.checkHouses();
                } else {

                }

                coreExecute(ShowPopupCmd, HousePopup.NAME, {point : pt});
                break;
        }




        /**
         * MOVE next things in win popup
         */
//        if($isWin) {
//            for (var i : int = 0; i < _game.dropList.list.length; i++)
//            {
//                var drop : DropSlot = _game.dropList.list[i];
//                if (drop.content)
//                {
//                    if (drop.content is GoldDrop)
//                    {
//                        var gold : GoldDrop = drop.content as GoldDrop;
//                        Model.instance.addPlayerGold(gold.gold);
//                    }
//                    else if (drop.content is ItemDrop)
//                    {
//                        var item : ItemDrop = drop.content as ItemDrop;
//                        Model.instance.addPlayerItem(item.item);
////                        Model.instance.player.addItem(item.item);
//                    }
//                }
//            }
//
//
//            Model.instance.progress.saveProgress();
//        }

    }


    private function handleClick(e: Event):void {
        coreExecute(ShowPopupCmd, SelectMonsterPopup.NAME);
    }



}
}
