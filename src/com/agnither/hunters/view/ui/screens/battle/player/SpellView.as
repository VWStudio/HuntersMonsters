/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.data.outer.MagicVO;
import com.agnither.hunters.model.player.Spell;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class SpellView extends AbstractView {

    public static const SPELL_SELECTED: String = "spell_selected_SpellView";

    private var _spell: Spell;

    private var _select: Sprite;
    private var _picture: Sprite;

    private var _damage: TextField;

    public function SpellView(refs:CommonRefs, spell: Spell) {
        _spell = spell;
        super(refs);
    }

    override protected function initialize():void {
        createFromCommon(_refs.guiConfig.common.spell);

        _select = _links.select;
        _select.visible = false;

        _picture = _links.picture;
        _picture.addChild(new Image(_refs.gui.getTexture(_spell.picture)));

        _links.damage_icon.getChildAt(0).texture = _refs.gui.getTexture("hit.png");

        _links.mana1_icon.visible = false;
        _links.mana1_tf.visible = false;
        _links.mana2_icon.visible = false;
        _links.mana2_tf.visible = false;
        _links.mana3_icon.visible = false;
        _links.mana3_tf.visible = false;

        var mana: Array = _spell.mana;
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

        _damage = _links.damage_tf;
        _damage.text = String(_spell.damage);

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(this, TouchPhase.BEGAN);
        if (touch) {
            dispatchEventWith(SPELL_SELECTED, true, _spell);
        }
    }
}
}
