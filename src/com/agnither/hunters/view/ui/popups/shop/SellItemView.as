/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.popups.shop
{
import com.agnither.hunters.data.outer.ExtensionVO;
import com.agnither.hunters.data.outer.ItemTypeVO;
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.Mana;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.common.ManaView;
import com.agnither.hunters.view.ui.screens.battle.player.DropSlotView;
import com.agnither.ui.AbstractView;
import com.agnither.ui.ButtonContainer;
import com.cemaprjl.core.coreDispatch;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class SellItemView extends AbstractView
{

    protected var _item : Item;
    public function get item() : Item
    {
        return _item;
    }

    protected var _mana : Vector.<ManaView>;

    protected var _select : Sprite;
    protected var _picture : Sprite;

    protected var _damage : TextField;
    private var _buyButton : ButtonContainer;
    private var _spell : Sprite;
    private var _price : Number;
    private var _back : Image;
    private var _touched : Boolean = false;

    public function SellItemView()
    {
    }

    override protected function initialize() : void
    {
        // XXXCOMMON
        createFromConfig(_refs.guiConfig.common.shopItem);

        this.touchable = true;
        _back = _links["bitmap__bg"];
        _back.touchable = true;
        _back.addEventListener(TouchEvent.TOUCH, onTouch);

        _buyButton = _links["buy_btn"];
        _buyButton.text = "Продать";
        _buyButton.addEventListener(Event.TRIGGERED, onSell);

        _select = _links.select;
        _select.visible = false;

        _picture = _links.picture;
        _picture.touchable = false;
        _damage = _links.damage_tf;

    }

    private function onSell(event : Event) : void
    {
        Model.instance.progress.gold += _price;
        Model.instance.player.inventory.removeItem(_item);
        Model.instance.progress.saveProgress();

    }

    public function setSellItem($item : Item) : void
    {
        _item = $item;

        _picture.addChild(new Image(_refs.gui.getTexture(_item.picture)));

        if (_item.extension)
        {

            if (_item.extension["1"])
            {
                _links.damage_icon.getChildAt(0).texture = _refs.gui.getTexture("m_2.png");
            }
            else if (_item.extension["2"])
            {
                _links.damage_icon.getChildAt(0).texture = _refs.gui.getTexture("shild.png");
            }
        }
        else
        {
            _links.damage_icon.visible = false;
            _links.damage_tf.visible = false;
        }

        var i : int = 0;
        _mana = new <ManaView>[];
        for (i = 0; i < 3; i++)
        {
            var manaView : ManaView = _links["mana" + (i + 1)];
            manaView.visible = false;
            _mana.push(manaView);
        }


        _price = 0;

        if (item.extension[ExtensionVO.defence])
        {
            _damage.text = item.extension[ExtensionVO.defence].toString();
            _price = int(Model.instance.getPrice(item.extension[ExtensionVO.defence]) * 0.6);
        }
        else if (item.extension[ExtensionVO.damage])
        {
            _damage.text = item.extension[ExtensionVO.damage].toString();
            _price = int(Model.instance.getPrice(item.extension[ExtensionVO.damage]) * 0.6);
        }
        else
        {
            _damage.text = "";
        }

        _buyButton.visible = Model.instance.progress.gold >= _price;


        if (item.type == ItemTypeVO.spell)
        {

            i = 0;
            var mana : Object = item.extension_drop;
            for (var key : * in mana)
            {
                var manaType : MagicTypeVO = MagicTypeVO.DICT[key];
                var manaObj : Mana = new Mana(manaType.name);
                manaObj.addMana(mana[key]);
                _mana[i++].mana = manaObj;
            }
            _buyButton.visible = false;
            _price = 0;
        }



    }

    public function get price() : Number
    {
        return _price;
    }

    private function onTouch(e : TouchEvent) : void
    {
        var touch: Touch = e.getTouch(this);

        if (touch == null) {
            coreDispatch(ShopPopup.HIDE_TOOLTIP);
        } else if(touch.phase == TouchPhase.HOVER) {
            coreDispatch(ShopPopup.SHOW_TOOLTIP, this);
        }

    }
}
}
