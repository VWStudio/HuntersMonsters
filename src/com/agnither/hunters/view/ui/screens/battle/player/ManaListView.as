/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.ManaList;
import com.agnither.hunters.view.ui.common.ManaView;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.DisplayObject;

import starling.events.Touch;

import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class ManaListView extends AbstractView {

    private var _manaList: ManaList;
    public function set mana(value: ManaList):void {
        _manaList = value;
        for (var i:int = 0; i < _mana.length; i++) {
            _mana[i].mana = _manaList.list.length > i ? _manaList.list[i] : null;
        }
    }

    private var _mana: Vector.<ManaView>;

    /*
     currentPlayer.manaList.addMana(match.type, match.amount);
     */

    public function ManaListView() {
    }

    override protected function initialize():void {
        _mana = new <ManaView>[];

        for (var i:int = 0; i < numChildren; i++) {
            var child : ManaView = getChildAt(i) as ManaView;
            child.touchable = true;
            child.addEventListener(TouchEvent.TOUCH, onTouch);
            _mana.push(getChildAt(i) as ManaView);
        }



    }

    private function onTouch(event : TouchEvent) : void
    {

        var touch : Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.BEGAN);
        if(touch) {
            trace("ADD MANA");
            var mv : ManaView = event.currentTarget as ManaView;
            _manaList.addMana(mv.mana.type, 5);
        }

    }
}
}
