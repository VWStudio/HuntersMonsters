/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.data.outer.MagicVO;
import com.agnither.hunters.model.player.inventory.Spell;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class SpellView extends ItemView {

    public static const SPELL_SELECTED: String = "spell_selected_SpellView";

    public function get spell():Spell {
        return _item as Spell;
    }

    public function SpellView(refs:CommonRefs, spell: Spell) {
        super(refs, spell);
    }

    override protected function initialize():void {
        super.initialize();

        var mana: Array = spell.mana;
        var l: int = mana.length;
        for (var i:int = 0; i < l; i++) {
            var manaData: Array = mana[i].split(":");
            var manaType: MagicVO = MagicVO.DICT[manaData[0]];
            var name: String = "mana"+(i+1);
            var icon: Sprite = _links[name+"_icon"];
            (icon.getChildAt(0) as Image).texture = _refs.gui.getTexture(manaType.picture);
            icon.visible = true;
            var tf: TextField = _links[name+"_tf"];
            tf.text = String(manaData[1]);
            tf.visible = true;
        }

        _damage.text = String(spell.damage);

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(this, TouchPhase.BEGAN);
        if (touch) {
            dispatchEventWith(SPELL_SELECTED, true, spell);
        }
    }
}
}
