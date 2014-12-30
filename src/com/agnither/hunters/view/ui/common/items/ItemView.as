/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.common.items
{
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.model.modules.extensions.DamageExt;
import com.agnither.hunters.model.modules.extensions.DefenceExt;
import com.agnither.hunters.model.modules.extensions.PetExt;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.Mana;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.common.ItemManaView;
import com.agnither.ui.AbstractView;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class ItemView extends AbstractView
{
    public static const HOVER : String = "ItemView.HOVER";
    public static const HOVER_OUT : String = "ItemView.HOVER_OUT";

    public static function create(item : Item) : ItemView
    {
        return new ItemView(item);
    }

    protected var _item : Item;
    public function get item() : Item
    {
        return _item;
    }

    protected var _select : Image;
    protected var _picture : Image;

    protected var _damage : TextField;
    protected var _icon : Image;
    protected var _magicBack : Image;
    private var _allowSelection : Boolean = true;
    protected var _manaContainer : Sprite;
    protected var _name : TextField;
    protected var _disabled : Image;

    public function ItemView(item : Item)
    {
        _item = item;
        createFromConfig(_refs.guiConfig.common.spell);
        handleFirstRun();
    }

    override protected function initialize() : void
    {
        _select = _links.bitmap_item_select;
        _name = _links["name_tf"];
        _picture = _links.bitmap_item_sword;
        _magicBack = _links["bitmap_itemmagic_back"];
        _damage = _links.damage_tf;
        _disabled = _links["bitmap_common_disabled_tint"];

        _select.visible = false;
        _magicBack.visible = false;
        _disabled.visible = false;


    }


    override public function update() : void
    {

        _name.text = item.title;

        _picture.texture = _refs.gui.getTexture(_item.picture);
        _picture.touchable = true;
//        this.touchable = !item.isPet();
        var magicType : MagicTypeVO;
        var texName : String = "";

        if (_item.isSpell())
        {
            texName = "itemicon_spell";
            _damage.text = item.getDamage().toString();
        }
        else if (_item.getDamage())
        {
            var dmgExt : DamageExt = _item.getExtension(DamageExt.TYPE) as DamageExt;
            magicType = MagicTypeVO.DICT[dmgExt.getType()];
            texName = magicType.picturedamage;
//            texName = "chip_sword";
            _damage.text = item.getDamage().toString();
        }
        else if (_item.getDefence())
        {
            texName = "itemicon_shield";
            _damage.text = item.getDefence().toString();
        }
        else if(_item.isPet())
        {

            var petExt : PetExt = _item.getExtension(PetExt.TYPE) as PetExt;
            var monster : MonsterVO = petExt.getMonster();


            magicType = MagicTypeVO.DICT[monster.damagetype];
            texName = magicType.picturedamage;
            _damage.text = monster.damage.toString();
        }
        else
        {
            _damage.visible = false;
        }

        if (texName.length > 0)
        {

            _icon = new Image(_refs.gui.getTexture(texName));
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
        }

        if (_item.isSpell())
        {

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
        }


        _item.addEventListener(Item.UPDATE, handleUpdate);

        handleUpdate();
    }

    protected function handleUpdate(e : Event = null) : void
    {
        _select.visible = _item.isWearing && _allowSelection;
    }

    public function set selected($val : Boolean) : void
    {
        _select.visible = $val;
    }

    override public function destroy() : void
    {
        super.destroy();

        _item.removeEventListener(Item.UPDATE, handleUpdate);

        _item = null;
        _select = null;
        _picture = null;
        _damage = null;
    }

    public function noSelection() : void
    {

        _allowSelection = false;
        handleUpdate();
    }


    public function demoMode() : void
    {
        if (_item.isSpell() || _item.getDamage())
        {
            _damage.text = (item.getExtension(DamageExt.TYPE) as DamageExt).getRange();
        }
        else if (_item.getDefence())
        {
            _damage.text = (item.getExtension(DefenceExt.TYPE) as DefenceExt).getRange();
        }
        else
        {
            _damage.visible = false;
        }
    }
}
}
