/**
 * Created by agnither on 18.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.outer.ArmorVO;
import com.agnither.hunters.data.outer.GoldDropVO;
import com.agnither.hunters.data.outer.ItemVO;
import com.agnither.hunters.data.outer.WeaponVO;

import starling.events.EventDispatcher;

public class DropSlot extends EventDispatcher {

    public static const UPDATE: String = "update_DropSlot";

    private var _content: *;
    public function get content():* {
        return _content;
    }

    public function get icon():String {
        if (_content is int) {
            return "out_1.png";
        }
        if (_content is ItemVO) {
            return "out_2.png";
        }
        if (_content is ArmorVO) {
            return "out_3.png";
        }
        if (_content is WeaponVO) {
            return "out_4.png";
        }
        return "out_5.png";
    }

    public function get isGold():Boolean {
        return _content is int;
    }
    public function get isEmpty():Boolean {
        return !_content;
    }

    public function DropSlot() {
    }

    public function addContent(content: Object):Boolean {
        var gold: GoldDropVO = content as GoldDropVO;

        if (isEmpty) {
            _content = gold ? gold.random : content;
        } else if (isGold && gold) {
            _content += gold.random;
        } else {
            return false;
        }
        dispatchEventWith(UPDATE);
        return true;
    }

    public function clear():void {
        _content = null;
    }

    private function update():void {
        dispatchEventWith(UPDATE);
    }
}
}
