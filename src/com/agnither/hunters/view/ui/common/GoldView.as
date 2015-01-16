/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.common {
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.extensions.DamageExt;
import com.agnither.hunters.model.modules.extensions.DefenceExt;
import com.agnither.hunters.model.modules.extensions.ManaExt;
import com.agnither.hunters.model.player.Mana;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.hunters.view.ui.popups.shop.ShopPopup;
import com.agnither.ui.AbstractView;
import com.agnither.ui.ButtonContainer;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;

import flash.geom.Rectangle;

import starling.display.Image;
import starling.display.Quad;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class GoldView extends AbstractView {

    private var _value: TextField;
    private var _tip : TextField;
    private var _buy : ButtonContainer;
    public var item : Item;
    public var isSell : Boolean = true;
    public var isBattle : Boolean = false;
//    private var _price : Number;
//    public var touched : Boolean = false;
    public var price : Number;
    private var _goldIcon : Image;
    private var _itemView : ItemView;
    private var _quad : Quad;
    private var _back : Image;
    private var isNew : Boolean = true;
    private var isBuy : Boolean = false;

    public function GoldView() {
        createFromConfig(_refs.guiConfig.common.goldItem);
        this.touchable = true;

        _back = _links["bitmap_common_back"];
        _back.touchable = true;

        for (var i : int = 0; i < numChildren; i++)
        {
            getChildAt(i).touchable = true;
        }
//        this.getChildAt(0).touchable = true;
//        this.getChildAt(1).touchable = true;
//        this.getChildAt(2).touchable = true;

        _goldIcon = _links.bitmap_drop_gold;
        _value = _links.amount_tf;
        _value.touchable = false;
        _tip = _links.tip_tf;
        _tip.touchable = false;
        _buy = _links.buy_btn;
        _buy.addEventListener(Event.TRIGGERED, onBuy);

        this.addEventListener(TouchEvent.TOUCH, onTouch);

//        _quad = new Quad(50,50,0xFF0000);
//        _quad.alpha = 0.3;
//        addChild(_quad);




        coreAddListener(ItemView.HOVER_OUT, onItemHoverOut);
    }

    private function onItemHoverOut() : void
    {
        //trace("onItemHoverOut");
        this.visible = false;
        item = null;
//        this.visible = price > 0 && touched;


    }

    private function onBuy(event : Event) : void
    {
        if(isSell)
        {
            if(item.crystallPrice)
            {
                Model.instance.progress.crystalls += price;
                Model.instance.player.inventory.removeItem(item);
                Model.instance.progress.saveProgress();
            }
            else
            {
                Model.instance.progress.gold += price;
                Model.instance.player.inventory.removeItem(item);
                Model.instance.progress.saveProgress();
            }
        }
        else
        {
            if(item.crystallPrice)
            {
                if (Model.instance.progress.crystalls < item.crystallPrice || item.crystallPrice <= 0)
                {
                    coreDispatch(ItemView.HOVER_OUT);
                    item = null;
                    return;
                }

                Model.instance.progress.crystalls -= item.crystallPrice;
                Model.instance.addPlayerItem(item);
                if (!item.isSpell()) Model.instance.shop.removeItem(item);
                coreDispatch(ShopPopup.ITEM_BOUGHT, item);
                Model.instance.progress.saveProgress();

                coreDispatch(ItemView.HOVER_OUT);
                item = null;
                return;
            }

            if (Model.instance.progress.gold < price || price <= 0)
            {
                coreDispatch(ItemView.HOVER_OUT);
                item = null;
                return;
            }

            Model.instance.progress.gold -= price;
            Model.instance.addPlayerItem(item);
            Model.instance.shop.removeItem(item);
            coreDispatch(ShopPopup.ITEM_BOUGHT, item);
            Model.instance.progress.saveProgress();
        }
        coreDispatch(ItemView.HOVER_OUT);
        item = null;
    }

    override public function update() : void {

        if(!isNew) return;

        _value.text = price.toString();
        var str:String = "";
        var exts : Object = item.getExtensions();
        for (var key : String in exts)
        {
            if (key != "monster") {
                if (!item.isSpell()) str += exts[key].getDescription();
                else if (key != "damage") str += exts[key].getDescription();
            }
        }
        switch (item.slot) {
            case 0:
                str += "\n\n";
                str += "Не прирученный монстр.";
                break;
            case 2:
                str += "\n\n";
                str += "Слот: Оружие";
                break;
            case 3:
                str += "\n\n";
                str += "Слот: Голова";
                break;
            case 4:
                str += "\n\n";
                str += "Слот: Тело";
                break;
            case 6:
                str += "\n\n";
                str += "Слот: Руки";
                break;
            case 7:
                str += "\n\n";
                str += "Слот: Ноги";
                break;
        }

        if (str.length > 0) _tip.text = str;

        _buy.visible = true;

        if(isSell) {
            _buy.visible = !item.isSpell();
            _buy.text = "Продать";
        }
        else
        {
            _buy.text = "Купить";
            var isPriceEnough : Boolean = Model.instance.progress.gold >= price;
            if(item.crystallPrice) {
                isPriceEnough = Model.instance.progress.crystalls >= item.crystallPrice;
            }


            _buy.visible = !Model.instance.player.inventory.isHaveSpell(item.id) && isPriceEnough
        }
        
        _goldIcon.visible = _value.visible = price > 0;

        if(_goldIcon.visible) {
            _goldIcon.texture = item.crystallPrice == 0 ? _refs.gui.getTexture("drop_gold") : _refs.gui.getTexture("crystal");
            _goldIcon.readjustSize();
        }

        _buy.visible = price > 0 && !(isSell && item.isSpell());
//        XXX uncomment next line if required to hide button on not enough money;
//        _buy.visible = _buy.visible && isPriceEnough;
        isNew = false;

        if (price > 0)
        {
            _tip.y = _back.y + 22;
            _back.height = _tip.height + 22 + 40;
            _goldIcon.y = _tip.height + 32;
            _value.y = _goldIcon.y;
        }
        else
        {
            _tip.y = _back.y + 12;
            _back.height = _tip.height + 12 + 12;
        }
    }

    private function onTouch(event : TouchEvent) : void
    {
        //trace("onTouch");
        if(price <= 0) return;
        var touch : Touch = event.getTouch(this);

        if(!touch) {
            if(event.target is TextField) {
            }
            else
            {
                coreDispatch(ItemView.HOVER_OUT);
                item = null;
            }
        }

        var touchBuy : Touch = event.getTouch(_buy, TouchPhase.HOVER);
        var touchBuyClick : Touch = event.getTouch(_buy, TouchPhase.BEGAN);
        if (!touchBuy && !touchBuyClick)
        {
            coreDispatch(ItemView.HOVER_OUT);
            //item = null;
        }
    }

    public function setData($item : ItemView, $price : Number, $isSell : Boolean, $isBattle : Boolean) : void
    {
        item = null;
//        trace("SET DATA");
        if(_itemView) {
            _itemView.removeEventListener(TouchEvent.TOUCH, onTouchItem);
        }
        itemView = $item;
        item = $item.item;
        _itemView.addEventListener(TouchEvent.TOUCH, onTouchItem);

        price = $price;
        isSell = $isSell;
        isBattle = $isBattle;

        update();
    }

    private function onTouchItem(event : TouchEvent) : void
    {
        var touch : Touch = event.getTouch(_itemView);
        if(!touch) {
            if(!event.getTouch(this) || price <= 0) {
                coreDispatch(ItemView.HOVER_OUT);
            }
            else
            {
                event.stopImmediatePropagation();
                event.stopPropagation();
                //coreDispatch(ItemView.HOVER_OUT);
            }
        }
    }

    public function get itemView() : ItemView
    {
        return _itemView;
    }

    public function set itemView(value : ItemView) : void
    {
        if(_itemView == value) {
            return
        }
        else
        {
            _itemView = value;
            isNew = true;
        }
    }
}
}
