/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.ManaList;
import com.agnither.hunters.view.ui.common.BattleManaView;
import com.agnither.hunters.view.ui.common.ItemManaView;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import flash.utils.Dictionary;

import starling.display.DisplayObject;

import starling.events.Touch;

import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class ManaListView extends AbstractView {

    private var _manaList: ManaList;
    public function set mana(value: ManaList):void {
        _manaList = value;
        _manas = new Dictionary();
        for (var i:int = 0; i < _mana.length; i++) {
            _mana[i].mana = _manaList.list.length > i ? _manaList.list[i] : null;
            _manas[_mana[i].mana.type] = _mana[i];
        }
    }

    private var _mana: Vector.<BattleManaView>;
    private var _manas : Dictionary;

    /*
     currentPlayer.manaList.addMana(match.type, match.amount);
     */

    public function ManaListView() {
    }

    override protected function initialize():void {

        _mana = new <BattleManaView>[];


        for (var i : int = 0; i < numChildren; i++)
        {
            var child : BattleManaView = getChildAt(i) as BattleManaView;
            child.touchable = true;
            child.addEventListener(TouchEvent.TOUCH, onTouch);
            _mana.push(child);


        }

//        var i : int = 0;
//        while (i < numChildren && numChildren > 3) {
//
//
//            var child : BattleManaView = getChildAt(i) as BattleManaView;
//            child.touchable = true;
//            child.addEventListener(TouchEvent.TOUCH, onTouch);
//            _mana.push(getChildAt(i) as BattleManaView);
//            i++;
//        }

//        trace(_mana);

//        for (var i:int = 0; i < numChildren; i++) {
//            if(i == 3) {
//                remo
//            }
//        }



    }

    public function getMagicObj($type) : BattleManaView {
        return _manas[$type];
    }

    private function onTouch(event : TouchEvent) : void
    {

        var touch : Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.BEGAN);
        if(touch) {
//            trace("ADD MANA");
            var mv : BattleManaView = event.currentTarget as BattleManaView;
            _manaList.addMana(mv.mana.type, 300);
        }

    }
}
}
