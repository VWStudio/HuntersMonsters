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
        this.visible = false;
        //item = null;
//        this.visible = price > 0 && touched;


    }

    private function onBuy(event : Event) : void
    {

        if(isSell)
        {
            Model.instance.progress.gold += price;
            Model.instance.player.inventory.removeItem(item);
            Model.instance.progress.saveProgress();
        }
        else
        {

            if (Model.instance.progress.gold < price || price <= 0)
            {
                return;
            }

            Model.instance.progress.gold -= price;
            Model.instance.addPlayerItem(item);
            //if (!item.isSpell())
//        if (_item.type != ItemTypeVO.spell)
            //{
                Model.instance.shop.removeItem(item);
            //}
            Model.instance.progress.saveProgress();

        }
        coreDispatch(ItemView.HOVER_OUT);
        item = null;
    }

    override public function update() : void {

        if (!isNew) return;

        _value.text = price.toString();
        var str:String = "";
        str += item.description;
        var exts : Object = item.getExtensions();
        for (var key : String in exts)
        {
            if (key == ManaExt.TYPE)
            {
                str += "\n\n";
                str += "Требует магии:\n";
                str += exts[key].getDescription();
            }
        }

        if (item.isArmor() || item.isWeapon())
        {
            str += "\n\n";
            str += "Слот: ";
            switch (item.slot)
            {
                case 2: str += "Оружие"; break;
                case 3: str += "Голова"; break;
                case 4: str += "Тело"; break;
                case 6: str += "Руки"; break;
                case 7: str += "Ноги"; break;
            }
        }

        if (item.slot == 0)
        {
            str += "\n\n";
            str += "Не прирученный монстр.";
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
            _buy.visible = !Model.instance.player.inventory.isHaveSpell(item.id) && isPriceEnough
        }
        _buy.visible = price > 0 && !(isSell && item.isSpell());
        _goldIcon.visible = _value.visible = price > 0;
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
        if(price <= 0) return;
        var touch : Touch = event.getTouch(this);

//        this.touched = touch != null;
        if(!touch) {
            if(event.target is TextField) {
//            if(event.target is TextField || event.target is ButtonContainer) {
            }
            else
            {
                coreDispatch(ItemView.HOVER_OUT);
                item = null;
            }
        }

        var touchBuy : Touch = event.getTouch(_buy, TouchPhase.HOVER);
        if (!touchBuy) coreDispatch(ItemView.HOVER_OUT);
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
