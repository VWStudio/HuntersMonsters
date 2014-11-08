/**
 * Created by agnither on 25.08.14.
 */
package com.agnither.hunters.view.ui.popups.traps {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.data.outer.TrapVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.popups.monsters.SelectMonsterPopup;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import flash.display.Sprite;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.display.Image;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class TrapItem extends AbstractView {

    public function get trap():TrapVO {
        return _trap;
    }
    private var _trap : TrapVO;

    private var _name: TextField;
    private var _area_tf: TextField;
    private var _level1: TextField;
    private var _level2: TextField;
    private var _level3 : TextField;
    private var _back : Image;

    public function TrapItem($trap: TrapVO) {
        _trap = $trap;
    }

    override protected function initialize():void {
        createFromConfig(_refs.guiConfig.common.trapItem);

        _back = _links["bitmap__bg"];
        _back.touchable = true;

        _name = _links.monster_tf;

        _area_tf = _links.area_tf;
        _area_tf.visible = false;
        _level1 = _links.level1_tf;
        _level2 = _links.level2_tf;
        _level3 = _links.level3_tf;


        _name.text = "Ловушка "+(_trap.level);

        _level1.text = "Уровень 1: "+_trap.leveleffect[0] * 100 + "%";
        _level2.text = "Уровень 2: "+_trap.leveleffect[1] * 100 + "%";
        _level3.text = "Уровень 3: "+_trap.leveleffect[2] * 100 + "%";

        _area_tf.text = "Территория: "+_trap.areaeffect + "%";

        addEventListener(TouchEvent.TOUCH, onTouch);
    }


    override public function destroy():void {
        super.destroy();
    }

    private function onTouch(e : TouchEvent) : void {


            e.stopPropagation();
            e.stopImmediatePropagation();
//            if(App.instance.trapMode) {
//                return;
//            }

            var touch : Touch = e.getTouch(this);
            if(touch)
            {
                Mouse.cursor = MouseCursor.BUTTON;
                switch (touch.phase)
                {
                    case TouchPhase.HOVER :
                        break;
                    case TouchPhase.BEGAN :
                        break;
                    case TouchPhase.ENDED :
                        Model.instance.currentTrap = _trap;
                        coreDispatch(MapScreen.START_TRAP);
                        coreDispatch(UI.HIDE_POPUP, SelectMonsterPopup.NAME);
                        break;
                }
            } else
            {
                Mouse.cursor = MouseCursor.AUTO;
            }

    }
}
}
