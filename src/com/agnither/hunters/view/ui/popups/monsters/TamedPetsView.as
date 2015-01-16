/**
 * Created by agnither on 22.08.14.
 */
package com.agnither.hunters.view.ui.popups.monsters
{
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.ui.AbstractView;
import com.cemaprjl.core.coreDispatch;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class TamedPetsView extends AbstractView
{

    public static var itemX : int = 175;
    public static var itemY : int = 175;

    public function TamedPetsView()
    {
    }


    override public function update() : void
    {

        var catchedPets : Vector.<String> = MonsterAreaVO.NAMES_LIST;

        removeChildren();

        var isBattle : Boolean = Model.instance.state == BattleScreen.NAME;

        for (var i : int = 0; i < catchedPets.length; i++)
        {

            if (isBattle && Model.instance.progress.tamedMonsters.indexOf(catchedPets[i]) == -1)
            {
                continue;
            }

            var tile : TamedMonsterView = new TamedMonsterView(catchedPets[i]);
            addChild(tile);
            tile.x = 180 * (i % 4);
            tile.y = 180 * int(i / 4);
            tile.touchable = true;
            tile.addEventListener(TouchEvent.TOUCH, onTouchPet);
        }

    }

    private function onTouchPet(e : TouchEvent) : void
    {
        var item : TamedMonsterView = e.currentTarget as TamedMonsterView;
        var touch : Touch = e.getTouch(item);
//        var touch: Touch = e.getTouch(item, TouchPhase.BEGAN);
        if (touch)
        {
            Mouse.cursor = MouseCursor.BUTTON;
//            if(touch.phase == TouchPhase.BEGAN && !item.item.isPet()) {
//                coreDispatch(LocalPlayer.ITEM_SELECTED, item.item);
//                item.update();
//            }
//            else
            if (touch.phase == TouchPhase.HOVER)
            {
                coreDispatch(ItemView.HOVER, item, item.item);
            }
        }
        else
        {
            coreDispatch(ItemView.HOVER_OUT);
            Mouse.cursor = MouseCursor.AUTO;
        }
    }

    public function get itemsAmount() : Number
    {
        return int(numChildren / 4) + 1;
    }
}
}
