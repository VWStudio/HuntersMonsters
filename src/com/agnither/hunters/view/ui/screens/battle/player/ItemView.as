/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.inventory.Spell;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;

public class ItemView extends AbstractView {

    public static function getItemView(refs: CommonRefs, item: Item):ItemView {
        if (item is Spell) {
            return new SpellView(refs, item as Spell);
        }
        return new ItemView(refs, item);
    }

    protected var _item: Item;

    protected var _select: Sprite;
    protected var _picture: Sprite;

    protected var _damage: TextField;

    public function ItemView(refs:CommonRefs, item: Item) {
        _item = item;
        super(refs);
    }

    override protected function initialize():void {
        createFromCommon(_refs.guiConfig.common.spell);

        _select = _links.select;
        _select.visible = false;

        _picture = _links.picture;
        _picture.addChild(new Image(_refs.gui.getTexture(_item.picture)));

        _links.damage_icon.getChildAt(0).texture = _refs.gui.getTexture("hit.png");

        _links.mana1_icon.visible = false;
        _links.mana1_tf.visible = false;
        _links.mana2_icon.visible = false;
        _links.mana2_tf.visible = false;
        _links.mana3_icon.visible = false;
        _links.mana3_tf.visible = false;

        _damage = _links.damage_tf;
    }
}
}
