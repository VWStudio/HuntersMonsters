/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.data.outer.ExtensionVO;
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;

public class SpellView extends ItemView {

    public function SpellView(refs:CommonRefs, item: Item) {
        super(refs, item);
    }

    override protected function initialize():void {
        super.initialize();

        var mana: Object = item.extension_drop;

        var i: int = 1;
        for (var key: * in mana) {
            trace(key, mana[key]);
            var manaType: DamageTypeVO = DamageTypeVO.DICT[key];
            var name: String = "mana"+(i++);
            var icon: Sprite = _links[name+"_icon"];
            (icon.getChildAt(0) as Image).texture = _refs.gui.getTexture(manaType.picture);
            icon.visible = true;
            var tf: TextField = _links[name+"_tf"];
            tf.text = String(mana[key]);
            tf.visible = true;
        }

        _damage.text = String(item.extension[ExtensionVO.damage]);
    }
}
}
