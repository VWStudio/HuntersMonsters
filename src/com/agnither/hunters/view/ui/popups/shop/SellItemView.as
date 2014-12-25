/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.popups.shop
{
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.extensions.DamageExt;
import com.agnither.hunters.model.modules.extensions.DefenceExt;
import com.agnither.hunters.model.modules.extensions.Extension;
import com.agnither.hunters.model.modules.players.SettingsVO;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.ui.AbstractView;
import com.agnither.ui.ButtonContainer;
import com.cemaprjl.core.coreDispatch;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class SellItemView extends AbstractView
{

    protected var _item : Item;
    public function get item() : Item
    {
        return _item;
    }

//    protected var _mana : Vector.<ItemManaView>;

//    protected var _select : Image;
//    protected var _picture : Image;

//    protected var _damage : TextField;
//    private var _buyButton : ButtonContainer;
//    private var _spell : Sprite;
    private var _price : Number;
//    private var _back : Image;
    private var _touched : Boolean = false;
    private var _itemView : ItemView;

    public function SellItemView($item : Item)
    {
        super();
        _item = $item;
    }

    override protected function initialize() : void
    {
        // XXXCOMMON
        createFromConfig(_refs.guiConfig.common.shopItem);

        this.touchable = true;
//        _back = _links["bitmap__bg"];

//        _buyButton = _links["buy_btn"];
//        _buyButton.text = "Продать";
//        _buyButton.addEventListener(Event.TRIGGERED, onSell);


        _itemView = ItemView.create(_item);
        addChild(_itemView);
        _itemView.touchable = true;
        _itemView.update();
//        _itemView.noSelection();

        _itemView.addEventListener(TouchEvent.TOUCH, onTouch);
//        _damage = _links.damage_tf;

        _price = 0;
        if (item.isSpell())
        {
//            _buyButton.visible = false;
        }
        else if (_item.getDamage())
        {
            _price = int(Model.instance.getPrice(item.getDamage(), "slot"+item.slot)* SettingsVO.DICT["sellPriceMult"]);
//            _price = int(Model.instance.getPrice(item.getDamage(), DamageExt.TYPE) * SettingsVO.DICT["slot"+item.slot]);
//            _price = int(Model.instance.getPrice(item.getDamage(), DamageExt.TYPE) * SettingsVO.DICT["sellPriceMult"]);
//            _price = int(Model.instance.getPrice(item.getDamage(), DamageExt.TYPE) * 0.6);
        }
        else if (_item.getDefence())
        {
            _price = int(Model.instance.getPrice(item.getDefence(), "slot"+item.slot)* SettingsVO.DICT["sellPriceMult"]);
//            _price = int(Model.instance.getPrice(item.getDefence(), DefenceExt.TYPE) * SettingsVO.DICT["sellPriceMult"]);
        }
        else
        {
            for (var extId : String in _item.getExtensions())
            {
                var extItem : Extension = _item.getExtension(extId);
                _price += Model.instance.getPrice(extItem.getBaseValue(), "slot"+item.slot);
//                _price += Model.instance.getPrice(extItem.getBaseValue(), (extItem as Object).constructor["TYPE"]);
            }
            _price = int(_price * SettingsVO.DICT["sellPriceMult"]);
        }

        if(_price <= 1) {
            _price = 1;
        }

    }

    private function onSell(event : Event) : void
    {
        Model.instance.progress.gold += _price;
        Model.instance.player.inventory.removeItem(_item);
        Model.instance.progress.saveProgress();

    }

//    public function setSellItem($item : Item) : void
//    {
//        _item = $item;

//        _picture.texture = _refs.gui.getTexture(_item.picture);


//        else
//        {
//            _links.damage_icon.visible = false;
//            _links.damage_tf.visible = false;
//            _damage.text = "";
//
//        }

//        var i : int = 0;
//        _mana = new <ItemManaView>[];
//        for (i = 0; i < 3; i++)
//        {
//            var manaView : ItemManaView = _links["mana" + (i + 1)];
//            manaView.visible = false;
//            _mana.push(manaView);
//        }


//        _price = 0;
//
//
//
//
//
//    }

    public function get price() : Number
    {
        return _price;
    }

    private function onTouch(e : TouchEvent) : void
    {
        var touch : Touch = e.getTouch(this, TouchPhase.HOVER);
//        var touch : Touch = e.getTouch(_itemView);

//        if (touch == null)
//        {
//            coreDispatch(ShopPopup.HIDE_TOOLTIP, true);
//        }
//        else if (touch.phase == TouchPhase.HOVER)
//        {
//            coreDispatch(ShopPopup.SHOW_TOOLTIP, this);
//        }


//        var isHitTooltip : Boolean = e.interactsWith(Model.instance.itemsTooltip);
        if (touch && Model.instance.itemsTooltip.item != _itemView.item) {
//            trace("Buy, TOUCH", isHitTooltip, touch.phase, item.uniqueId);
//            oreDispatch(ShopPopup.SHOW_TOOLTIP, this);
            coreDispatch(ItemView.HOVER, _itemView, _price, true);
        }
        else
        {
//            trace("Buy, NO Touch", isHitTooltip, touch, item.uniqueId);
//            coreDispatch(ShopPopup.HIDE_TOOLTIP, !isHitTooltip);
        }
    }
}
}
