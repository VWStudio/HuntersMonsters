/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.map {
import com.agnither.hunters.model.player.Mana;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class PlayerPoint extends AbstractView {

//    private var _mana: Mana;
//    public function set mana(value: Mana):void {
//        if (_mana) {
//            _mana.removeEventListener(Mana.UPDATE, handleUpdate);
//        }
//        _mana = value;
//        if (_mana) {
//            _mana.addEventListener(Mana.UPDATE, handleUpdate);
//        }
//        handleUpdate();
//    }
//
//    private var _icon: Image;
//    private var _value: TextField;

    public function PlayerPoint() {
    }

    override protected function initialize():void {
//        _icon = _links.icon.getChildAt(0);
//        _value = _links.value_tf;
//        visible = false;
    }

//    private function handleUpdate(e: Event = null):void {
//        if (_mana) {
//            _icon.texture = _refs.gui.getTexture(_mana.icon);
//            _value.text = String(_mana.value);
//            visible = true;
//        } else {
//            visible = false;
//        }
//    }
}
}
