/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.popups.win {
import com.agnither.hunters.App;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.drop.DropList;
import com.agnither.hunters.model.player.drop.DropSlot;
import com.agnither.hunters.model.player.drop.GoldDrop;
import com.agnither.hunters.model.player.drop.ItemDrop;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.screens.battle.monster.MonsterInfo;
import com.agnither.hunters.view.ui.screens.battle.player.DropSlotView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.ItemView;
import com.agnither.hunters.view.ui.screens.map.*;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Popup;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.core.coreRemoveListener;
import com.cemaprjl.viewmanage.ShowScreenCmd;

import flash.geom.Rectangle;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class WinPopup extends Popup {

    public static const NAME : String = "WinPopup.NAME";

//    public static const SELECT_MONSTER: String = "select_monster_BattleScreen";


    private var _back : Image;
    private var _playButton : ButtonContainer;
    private var _monster : MonsterInfo;
    private var _closeButton : ButtonContainer;
    private var _title : TextField;
    private var _isClosed : Boolean = true;
    private var _stars : StarsBar;
    private var _moves : TextField;
    private var _drops : Sprite;
    private var _gold : TextField;
    private var _tooltip : Sprite;

    public function WinPopup() {

        super();
    }


    override public function destroy() : void {

        coreRemoveListener(DropSlotView.SHOW_TOOLTIP, onShowTooltip);
        coreRemoveListener(DropSlotView.HIDE_TOOLTIP, onHideTooltip);

    }

    override protected function initialize() : void {

        createFromConfig(_refs.guiConfig.win_popup);

        _back = _links["bitmap__bg"];
//        _back.touchable = true;

        _title = _links["title_tf"];

        _closeButton = _links["close_btn"];
        _closeButton.addEventListener(Event.TRIGGERED, handleClose);

        _playButton = _links["play_btn"];
        _playButton.addEventListener(Event.TRIGGERED, handleClose);
        _playButton.text = "Забрать награду";


        _moves = _links["moves_tf"];
        _stars = _links["stars"];
        _gold = _links["rewardGold_tf"];

        _drops = new Sprite();
        addChild(_drops);
        _drops.y = 320;

        _monster = _links.monster;

        _tooltip = new Sprite();
        addChild(_tooltip);
        _tooltip.visible = false;



    }

    private function handleClose(event : Event) : void {

        coreDispatch(UI.HIDE_POPUP, NAME);

        if (data.isWin && !_isClosed)
        {
            _isClosed = true;
            coreDispatch(Model.MONSTER_CATCHED);

            Model.instance.deletePoint(Model.instance.currentMonsterPoint);

        } else {
            Model.instance.currentMonsterPoint.count(true);
        }

        Model.instance.currentMonsterPoint = null;

        coreExecute(ShowScreenCmd, MapScreen.NAME);


    }

    private function onHideTooltip() : void {
        _tooltip.visible = false;
        _tooltip.removeChildren();
    }

    private function onShowTooltip($data : Object) : void {

        if($data.content is ItemDrop) {
            _tooltip.addChild(ItemView.getItemView(($data.content as ItemDrop).item));
            _tooltip.visible = true;
        }
        _tooltip.visible = true;
        var rect : Rectangle = ($data.item as Sprite).getBounds(this);
        _tooltip.x = rect.x + rect.width + 5;
        _tooltip.y = rect.y + rect.height + 5;
    }

    override public function update() : void {

        _title.text = data.isWin ? "Победа" : "Поражение";
        _playButton.text = data.isWin ? "Забрать" : "Закрыть";

        _moves.text = "Ходов: "+Model.instance.movesAmount;

        var stars : int = 0;
        if(Model.instance.movesAmount < Model.instance.monster.stars[0]) {
            stars = 3;
        } else if(Model.instance.movesAmount < Model.instance.monster.stars[1]) {
            stars = 2;
        } else if(Model.instance.movesAmount < Model.instance.monster.stars[2]) {
            stars = 1;
        }

        _stars.setProgress(data.isWin ? stars : 0);

        _monster.data = Model.instance.monster;
        _monster.update();
        _isClosed = false;

        var dropList : DropList = data.drops;
        _drops.removeChildren();

        _gold.text = "";

        if(data.isWin) {
            for (var i : int = 0; i < dropList.list.length; i++)
            {
                var drop : DropSlot = dropList.list[i];
                if (drop.content)
                {
                    if (drop.content is GoldDrop)
                    {
                        var gold : GoldDrop = drop.content as GoldDrop;
                        _gold.text = "Награда: "+gold.gold+"$";
                        Model.instance.addPlayerGold(gold.gold);
                    }
                    else if (drop.content is ItemDrop)
                    {
                        var dropView : DropSlotView = new DropSlotView();
                        dropView.createFromCommon(_refs.guiConfig.common.drop);
                        _drops.addChild(dropView);
                        dropView.drop = drop;
                        var item : ItemDrop = drop.content as ItemDrop;
                        Model.instance.addPlayerItem(item.item);
                        dropView.x = _drops.numChildren * 40;
                    }
                }
            }


            Model.instance.progress.saveProgress();

            coreAddListener(DropSlotView.SHOW_TOOLTIP, onShowTooltip);
            coreAddListener(DropSlotView.HIDE_TOOLTIP, onHideTooltip);
        }


    }


}
}
