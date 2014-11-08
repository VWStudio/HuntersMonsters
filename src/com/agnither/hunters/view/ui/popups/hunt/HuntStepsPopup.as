/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.popups.hunt {
import com.agnither.hunters.App;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.drop.DropSlot;
import com.agnither.hunters.model.player.drop.GoldDrop;
import com.agnither.hunters.model.player.drop.ItemDrop;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.common.MonsterInfo;
import com.agnither.hunters.view.ui.screens.battle.player.DropSlotView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.ItemView;
import com.agnither.hunters.view.ui.screens.map.*;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Popup;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreRemoveListener;

import flash.geom.Rectangle;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class HuntStepsPopup extends Popup {

    public static const NAME : String = "com.agnither.hunters.view.ui.popups.hunt.HuntStepsPopup";

//    public static const SELECT_MONSTER: String = "select_monster_BattleScreen";

    private var _back : Image;
    private var _playButton : ButtonContainer;
    private var _closeButton : ButtonContainer;
    private var _monsterContainer : Sprite;
    private var _playerIcon : Image;
    private var _arrow1 : Sprite;
    private var _arrow2 : Sprite;
    private var _monsters : Vector.<MonsterVO>;
    public static const START_MODE : String = "HuntStepsPopup.START_MODE";
    public static const CONTINUE_MODE : String = "HuntStepsPopup.CONTINUE_MODE";
    public static const WIN_MODE : String = "HuntStepsPopup.WIN_MODE";
    public static const LOSE_MODE : String = "HuntStepsPopup.LOSE_MODE";
    private var _title : TextField;
    private var _rewardTF : TextField;
    private var _drops : Sprite;
    private var _tooltip : Sprite;

    public function HuntStepsPopup() {

        super();
    }

    override protected function initialize() : void {

        createFromConfig(_refs.guiConfig.hunt_steps);


        _back = _links["bitmap__bg"];
        _closeButton = _links["close_btn"];
        _closeButton.addEventListener(Event.TRIGGERED, handleClose);

        _title = _links["title_tf"];

        _playButton = _links["play_btn"];
        _playButton.addEventListener(Event.TRIGGERED, handlePlay);
        _playButton.text = "Напасть";

        _playerIcon = _links["bitmap_chip_2.png"];
        _arrow1 = _links["arrow1"];
        _arrow1.visible = false;
        _arrow2 = _links["arrow2"];
        _arrow2.visible = false;
        _playerIcon.visible = false;

        _rewardTF = _links["reward_tf"];

        _monsterContainer = new Sprite();
        addChild(_monsterContainer);

        _drops = new Sprite();
        addChild(_drops);
        _drops.y = _rewardTF.y - 40;
        _drops.x = 300;

        _tooltip = new Sprite();
        addChild(_tooltip);
        _tooltip.visible = false;




    }

    private function onHideTooltip() : void {
        _tooltip.visible = false;
        _tooltip.removeChildren();
    }

    private function onShowTooltip($data : Object) : void {

        if ($data.content is ItemDrop)
        {
            _tooltip.addChild(ItemView.getItemView(($data.content as ItemDrop).item));
            _tooltip.visible = true;
        }
        _tooltip.visible = true;
        var rect : Rectangle = ($data.item as Sprite).getBounds(this);
        _tooltip.x = rect.x + rect.width + 5;
        _tooltip.y = rect.y + rect.height + 5;
    }


    override public function onRemove() : void {
        coreRemoveListener(DropSlotView.SHOW_TOOLTIP, onShowTooltip);
        coreRemoveListener(DropSlotView.HIDE_TOOLTIP, onHideTooltip);
    }

    private function handleClose(event : Event) : void {
        coreDispatch(UI.HIDE_POPUP, NAME);
    }

    private function handlePlay(event : Event) : void {

        switch (data.mode)
        {
            case START_MODE:
                Model.instance.match3mode = Match3Game.MODE_STEP;
                coreDispatch(UI.HIDE_POPUP, NAME);
                coreDispatch(Match3Game.START_GAME, _monsters[App.instance.chestStep]);
                break;
            case CONTINUE_MODE:
                Model.instance.match3mode = Match3Game.MODE_STEP;
                coreDispatch(UI.HIDE_POPUP, NAME);
                coreDispatch(Match3Game.START_GAME, _monsters[App.instance.chestStep]);
                break;
            case WIN_MODE:
                coreDispatch(UI.HIDE_POPUP, NAME);
                coreDispatch(MapScreen.REMOVE_CHEST, App.instance.chest);
                break;
            case LOSE_MODE:
                coreDispatch(UI.HIDE_POPUP, NAME);
                coreDispatch(MapScreen.REMOVE_CHEST, App.instance.chest);


                break;
        }


    }


    override public function update() : void {

        _monsters = App.instance.steps;
//        _monsters = data as Vector.<MonsterVO>;
        _monsterContainer.removeChildren();
        _monsterContainer.y = 70;
        for (var i : int = 0; i < _monsters.length; i++)
        {
            var mon : MonsterInfo = new MonsterInfo();
            // XXXCOMMON
            mon.createFromConfig(_refs.guiConfig.common.monster);
//            mon.createFromCommon(_refs.guiConfig.common.monster);
            mon.data = _monsters[i];
            _monsterContainer.addChild(mon);
            mon.update();
            mon.x = i * 250;


        }
        _arrow1.visible = _monsters.length > 1;
        _arrow2.visible = _monsters.length > 2;
        _arrow1.y = 150;
        _arrow2.y = 150;
        _monsterContainer.x = (_back.getBounds(this).width - _monsterContainer.getBounds(this).width) * 0.5;

        _arrow1.x = _monsterContainer.x + 200;
        _arrow2.x = _arrow1.x + 250;

        _playerIcon.visible = true;
        _playerIcon.y = 250;
        _playerIcon.x = _monsterContainer.x + 50 + App.instance.chestStep * 250;

        _closeButton.visible = false;
        switch (data.mode)
        {
            case START_MODE:
                _rewardTF.text = "1000 золота";
                _closeButton.visible = true;
                _title.text = "Победи хранителей сундука";
                _playButton.text = "Напасть";
                break;
            case CONTINUE_MODE:
                _title.text = "Победи хранителей сундука";
                _playButton.text = "Следующий";
                break;
            case WIN_MODE:
                _title.text = "Ты победил";
                _playButton.text = "Забрать";
                break;
            case LOSE_MODE:
                _title.text = "Ты проиграл";
                _rewardTF.text = "Выигрыша нет";
                _playButton.text = "Выйти";
                break;
        }


        _drops.removeChildren();

        _rewardTF.text = "";

        for (var j : int = 0; j < App.instance.chest.drops.length; j++)
        {
            var drop : DropSlot = new DropSlot();
            drop.addContent(App.instance.chest.drops[j]);
            if (drop.content)
            {
                if (drop.content is GoldDrop)
                {
                    var gold : GoldDrop = drop.content as GoldDrop;
                    _rewardTF.text = "Награда: " + gold.gold + "$";
                    Model.instance.addPlayerGold(gold.gold);
                }
                else if (drop.content is ItemDrop)
                {
                    var dropView : DropSlotView = new DropSlotView();
                    // XXXCOMMON
                    dropView.createFromConfig(_refs.guiConfig.common.drop);
//                    dropView.createFromCommon(_refs.guiConfig.common.drop);
                    _drops.addChild(dropView);
                    dropView.drop = drop;
                    var item : ItemDrop = drop.content as ItemDrop;
                    Model.instance.addPlayerItem(item.item);
                    dropView.x = _drops.numChildren * 40;
                }
            }
        }


        coreAddListener(DropSlotView.SHOW_TOOLTIP, onShowTooltip);
        coreAddListener(DropSlotView.HIDE_TOOLTIP, onHideTooltip);
    }


}
}
