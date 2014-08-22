/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.inventory.Weapon;
import com.agnither.utils.CommonRefs;

public class ArmorView extends ItemView {

    public function get weapon():Weapon {
        return _item as Weapon;
    }

    public function ArmorView(refs:CommonRefs, weapon: Weapon) {
        super(refs, weapon);
    }

    override protected function initialize():void {
        super.initialize();

        _damage.text = String(weapon.damage);

//        addEventListener(TouchEvent.TOUCH, handleTouch);
    }
//
//    private function handleTouch(e: TouchEvent):void {
//        var touch: Touch = e.getTouch(this, TouchPhase.BEGAN);
//        if (touch) {
//            dispatchEventWith(SPELL_SELECTED, true, spell);
//        }
//    }
//
//    override public function destroy():void {
//        super.destroy();
//
//        removeEventListener(TouchEvent.TOUCH, handleTouch);
//    }
}
}
