/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player.inventory {
import com.agnither.hunters.view.ui.screens.battle.player.*;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class ItemView extends AbstractView {

    public static function getItemView(refs: CommonRefs, item: Item):ItemView {
        switch (item.type) {
            case ItemTypeVO.weapon:
                return new WeaponView(refs, item);
            case ItemTypeVO.armor:
                return new ArmorView(refs, item);
            case ItemTypeVO.magic:
                return new MagicItemView(refs, item);
            case ItemTypeVO.spell:
                return new SpellView(refs, item);
        }
        return new ItemView(refs, item);
    }

    protected var _item: Item;
    public function get item():Item {
        return _item;
    }

    protected var _mana: Vector.<ManaView>;

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

        _mana = new <ManaView>[];
        for (var i:int = 0; i < 3; i++) {
            trace(_links["mana"+(i+1)]);
            var mana: ManaView = _links["mana"+(i+1)];
            mana.visible = false;
            _mana.push(mana);
        }

        _damage = _links.damage_tf;

        _item.addEventListener(Item.UPDATE, handleUpdate);
        handleUpdate();
    }

    private function handleUpdate(e: Event = null):void {
        _select.visible = _item.isWearing;
    }

    override public function destroy():void {
        super.destroy();

        _item.removeEventListener(Item.UPDATE, handleUpdate);

        _item = null;
        _select = null;
        _picture = null;
        _damage = null;
    }
}
}
