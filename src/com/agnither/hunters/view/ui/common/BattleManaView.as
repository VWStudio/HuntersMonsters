/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.common {
import com.agnither.hunters.model.player.Mana;
import com.agnither.ui.AbstractView;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class BattleManaView extends AbstractView {

    private var _mana: Mana;
    public function set mana(value: Mana):void {
        if (_mana) {
            _mana.removeEventListener(Mana.UPDATE, handleUpdate);
        }
        _mana = value;
        if (_mana) {
            _mana.addEventListener(Mana.UPDATE, handleUpdate);
        }
        handleUpdate();
    }

    private var _icon: Image;
    private var _value: TextField;

    public function BattleManaView() {
    }

    override protected function initialize():void {
        this.touchable = true;
        _icon = _links.bitmap_mana_green;
        _icon.touchable = true;
        _value = _links.value_tf;
        _value.touchable = true;
//        visible = false;
    }




    private function handleUpdate(e: Event = null):void {
        if (_mana && _mana.manaicon) {

            _icon.texture = _refs.gui.getTexture(_mana.manaicon);
            _value.text = String(_mana.value);
            visible = true;

            _icon.readjustSize();
            _icon.x = (_value.width - _icon.width) * 0.5;

        } else {
            visible = false;
        }
    }

    public function get mana() : Mana
    {
        return _mana;
    }
}
}
