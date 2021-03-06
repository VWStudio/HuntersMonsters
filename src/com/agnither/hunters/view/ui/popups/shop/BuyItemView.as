/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.popups.shop
{
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.extensions.DamageExt;
import com.agnither.hunters.model.modules.extensions.DefenceExt;
import com.agnither.hunters.model.modules.extensions.Extension;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.ui.AbstractView;
import com.agnither.ui.ButtonContainer;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;

import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.display.Sprite;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class BuyItemView extends AbstractView
{

    protected var _item : Item;
    public function get item() : Item
    {
        return _item;
    }

//    private var _buyButton : ButtonContainer;
    private var _price : Number;
    private var _itemView : ItemView;

    public function BuyItemView($item : Item)
    {
        super();
        _item = $item;
        handleFirstRun();
    }

    override protected function initialize() : void
    {
        // XXXCOMMON
//        createFromConfig(_refs.guiConfig.common.shopItem);

        this.touchable = true;

        _itemView = _links.spell;

//        _buyButton = _links["buy_btn"];
//        _buyButton.text = "Купить";
//        _buyButton.addEventListener(Event.TRIGGERED, onBuy);

        _itemView = ItemView.create(_item);
        addChild(_itemView);
        _itemView.touchable = true;
        _itemView.noSelection();
        _itemView.update();
        _itemView.addEventListener(TouchEvent.TOUCH, onTouch);

        _price = 0;

        if (_item.getDamage())
        {
//            _links.damage_icon.getChildAt(0).texture = _refs.gui.getTexture("chip_sword");
//            _damage.text = item.getDamage().toString();
            //_price = Model.instance.getPrice(item.getDamage(), "slot"+item.slot);
//            _price = Model.instance.getPrice(item.getDamage(), DamageExt.TYPE);

            if (_item.isSpell()) _price = _item.price;
            else _price = Model.instance.getPrice(item.getDamage(), "slot"+item.slot);
        }
        else if (_item.getDefence())
        {
//            _links.damage_icon.getChildAt(0).texture = _refs.gui.getTexture("itemicon_shield");
//            _damage.text = item.getDefence().toString();
            _price = Model.instance.getPrice(item.getDefence(), "slot"+item.slot);
//            _price = Model.instance.getPrice(item.getDefence(), DefenceExt.TYPE);
        }
        else
        {
            for (var extId : String in _item.getExtensions())
            {
                var extItem : Extension = _item.getExtension(extId);
                _price += Model.instance.getPrice(extItem.getBaseValue(), "slot"+item.slot);
//                _price += Model.instance.getPrice(extItem.getBaseValue(), (extItem as Object).constructor["TYPE"]);
            }

        }


        var isPriceEnough : Boolean = Model.instance.progress.gold >= _price;
        if (_item.isSpell())
        {
//            _buyButton.visible = !Model.instance.player.inventory.isHaveSpell(item.id) && isPriceEnough;
        }



        if(_item.crystallPrice) {
            _price = item.crystallPrice
        }

    }


    private function onTouch(e : TouchEvent) : void
    {
        //var touch : Touch = e.getTouch(this, TouchPhase.HOVER);
        var item: ItemView = e.currentTarget as ItemView;
        var touch: Touch = e.getTouch(item);
//        var touch1 : Touch =
//        var touchTooltip : Touch = e.getTouch(Model.instance.itemsTooltip);
//        var ttInteract : Boolean = e.interactsWith(Model.instance.itemsTooltip);

//        var isHitTooltip : Boolean = e.interactsWith(Model.instance.itemsTooltip);
//        if (touch && Model.instance.itemsTooltip.item != _itemView.item)
        if (touch && (!Model.instance.itemsTooltip.visible || Model.instance.itemsTooltip.item != _itemView.item))
        {

            coreDispatch(ItemView.HOVER, _itemView, _itemView.item, _price, false);
//            coreDispatch(ShopPopup.SHOW_TOOLTIP, this);
        }
        else
        {
            Mouse.cursor = MouseCursor.AUTO;
//            coreDispatch(ShopPopup.HIDE_TOOLTIP, !isHitTooltip);
        }


    }

//    private function onBuy(event : Event) : void
//    {
//        if(item.crystallPrice)
//        {
//           if(item.crystallPrice >= Model.instance.progress.crystalls)
//           {
//                Model.instance.progress.crystalls -= _price;
//                Model.instance.addPlayerItem(_item);
//                if (!_item.isSpell())
////        if (_item.type != ItemTypeVO.spell)
//                {
//                    Model.instance.shop.removeItem(_item);
//                }
//                Model.instance.progress.saveProgress();
//                coreDispatch(ItemView.HOVER_OUT);
//            }
//            return;
//        }
//
//        if (Model.instance.progress.gold < _price || _price <= 0)
//        {
//            return;
//        }
//
//        Model.instance.progress.gold -= _price;
//        Model.instance.addPlayerItem(_item);
//        if (!_item.isSpell())
////        if (_item.type != ItemTypeVO.spell)
//        {
//            Model.instance.shop.removeItem(_item);
//        }
//        Model.instance.progress.saveProgress();
//        coreDispatch(ItemView.HOVER_OUT);
//
//    }

//    public function setBuyItem($item : Item) : void
//    {
//        _item = $item;
//        _price = 0;
//
//        _picture.addChild(new Image(_refs.gui.getTexture(_item.picture)));
//
//        if (_item.getDamage())
//        {
//            _links.damage_icon.getChildAt(0).texture = _refs.gui.getTexture("chip_sword");
//            _damage.text = item.getDamage().toString();
//            _price = Model.instance.getPrice(item.getDamage());
//        }
//        else if (_item.getDefence())
//        {
//            _links.damage_icon.getChildAt(0).texture = _refs.gui.getTexture("itemicon_shield");
//            _damage.text = item.getDefence().toString();
//            _price = Model.instance.getPrice(item.getDefence());
//        }
//        else {
//            _links.damage_icon.visible = false;
//            _links.damage_tf.visible = false;
//            _damage.text = "";
//        }
//
//        var i : int = 0;
//        _mana = new <ItemManaView>[];
//        for (i = 0; i < 3; i++)
//        {
//            var manaView : ItemManaView = _links["mana" + (i + 1)];
//            manaView.visible = false;
//            _mana.push(manaView);
//        }
//
//
//        var isPriceEnough : Boolean = Model.instance.progress.gold >= _price;
//
//        _buyButton.visible = isPriceEnough;
//
//        if (item.isSpell())
//        {
//
//            i = 0;
//            var mana : Object = item.mana;
//            for (var key : * in mana)
//            {
//                var manaType : MagicTypeVO = MagicTypeVO.DICT[key];
//                var manaObj : Mana = new Mana(manaType.name);
//                manaObj.addMana(mana[key]);
//                _mana[i++].mana = manaObj;
//            }
//            _buyButton.visible = !Model.instance.player.inventory.isHaveSpell(item.id) && isPriceEnough;
//        }
//
//
//
//    }

    public function get price() : Number
    {
        return _price;
    }
}
}
