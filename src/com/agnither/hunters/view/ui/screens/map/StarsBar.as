/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.map {
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.player.Mana;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class StarsBar extends AbstractView {
    private var _back : Image;
    private var _stars : Vector.<Sprite>;
    private var _progress : int;

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

    public function StarsBar() {
    }

    override protected function initialize():void {

        _back = _links["bitmap_stars_back.png"];
//        _back.touchable = true;
//        this.touchable = true;

        _stars = new <Sprite>[];

        _stars.push(_links["star1"]);
        _stars.push(_links["star2"]);
        _stars.push(_links["star3"]);

//        setProgress(0);
    }


    override public function update() : void {
        setProgress(_progress);
    }

    public function setProgress(val : int) : void {
        _progress = val;
        if(!_stars) return;
        for (var i : int = 0; i < _stars.length; i++)
        {
            _stars[i].visible = i < val;
        }
        _back.visible = val > 0;
    }

}
}
