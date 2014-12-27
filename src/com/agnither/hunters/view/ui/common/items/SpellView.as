/**
 * Created by mor on 07.12.2014.
 */
package com.agnither.hunters.view.ui.common.items
{
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.player.Mana;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.common.ItemManaView;

import starling.display.Image;
import starling.display.Sprite;

public class SpellView extends ItemView
{
    public var isExample : Boolean = false;
    public function SpellView(item : Item)
    {
        super(item);
    }


    override public function update() : void
    {

        _name.text = item.title;

        _disabled.visible = isExample;

        _picture.texture = _refs.gui.getTexture(_item.picture);
        _picture.touchable = !isExample;
        _damage.text = item.getDamage().toString();

        _icon = new Image(_refs.gui.getTexture("itemicon_spell"));
        addChildAt(_icon, getChildIndex(_damage));
        _icon.readjustSize();
        if (_icon.width > _damage.width)
        {
            _icon.width = _damage.width;
            _icon.scaleY = _icon.scaleX;
        }
        if (_icon.height > _picture.height * 0.7)
        {
            _icon.height = _picture.height * 0.7;
            _icon.scaleX = _icon.scaleY;
        }
        _icon.y = 15;
        _icon.x = (_damage.width - _icon.width) * 0.5;

        _manaContainer = new Sprite();
        addChild(_manaContainer);
        _manaContainer.y = 52;
        _manaContainer.x = _picture.width;

        var i : int = 0;
        var mana : Object = _item.getMana();
        for (var key : * in mana)
        {

            var manaview : ItemManaView = new ItemManaView();
            _manaContainer.addChild(manaview);
            manaview.x = -(i + 1) * 20;
            var manaType : MagicTypeVO = MagicTypeVO.DICT[key];
            var manaObj : Mana = new Mana(manaType.name);
            manaObj.addMana(mana[key]);
            manaview.mana = manaObj;
            i++;
        }

        //_magicBack.visible = i > 0;

        handleUpdate();
    }
}
}
