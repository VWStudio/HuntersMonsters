/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.map {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.DropVO;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.drop.GoldDrop;
import com.agnither.hunters.model.player.drop.ItemDrop;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.popups.hunt.HuntStepsPopup;
import com.agnither.ui.AbstractView;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.viewmanage.ShowPopupCmd;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.display.Image;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class ChestPoint extends AbstractView {
    private var _back : Image;
    private var _time : TextField;
    private var _monsters : Vector.<MonsterVO>;
    private var _drops : Array;


    public function ChestPoint() {
        this.addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch(e : TouchEvent) : void {
        e.stopPropagation();
        e.stopImmediatePropagation();
        if (App.instance.trapMode)
        {
            return;
        }

        var touch : Touch = e.getTouch(this);
        if (touch)
        {
            Mouse.cursor = MouseCursor.BUTTON;
            switch (touch.phase)
            {
                case TouchPhase.HOVER :
                    break;
                case TouchPhase.BEGAN :
                    break;
                case TouchPhase.ENDED :
                    App.instance.chestStep = 0;
                    App.instance.steps = _monsters;
                    App.instance.chest = this;
                    coreExecute(ShowPopupCmd, HuntStepsPopup.NAME, {mode: HuntStepsPopup.START_MODE});
                    break;
            }
        }
        else
        {
            Mouse.cursor = MouseCursor.AUTO;
        }

    }

    override protected function initialize() : void {
        if (!_links["bitmap_icon_bg.png"])
        {
            createFromConfig(_refs.guiConfig.common.chestIcon);
        }


        _back = _links["bitmap_icon_bg.png"];
        _back.touchable = true;
        this.touchable = true;

        _time = _links.time_tf;

    }


    override public function update() : void {

        var maxMonsters : int = 1 + Math.random() * 3;
        _monsters = new <MonsterVO>[];
        for (var i : int = 0; i < maxMonsters; i++)
        {
            _monsters.push(Model.instance.monsters.getRandomMonster());
        }

        var monster : MonsterVO = _monsters[0];

        var goldDrop : GoldDrop;
        _drops = [];
        for (var j : int = 0; j < 3; j++)
        {
            var drop : DropVO = DropVO.getRandomDrop(MonsterAreaVO.DICT[monster.id].chestdropset);
            if (drop.type == ItemTypeVO.gold)
            {
                if (goldDrop)
                {
                    goldDrop.stack(new GoldDrop(drop.randomAmount));
//                    goldDrop.stack(new GoldDrop(GoldDropVO.DICT[drop.item_id].random));
                }
                else
                {
                    goldDrop = new GoldDrop(drop.randomAmount);
//                    goldDrop = new GoldDrop(GoldDropVO.DICT[drop.item_id].random);
                    _drops.push(goldDrop);
                }
            }
            else
            {
                _drops.push(new ItemDrop(Item.createDrop(Model.instance.items.getItem(drop.item_id))));
            }
        }
    }

    public function get drops() : Array {
        return _drops;
    }
}
}
