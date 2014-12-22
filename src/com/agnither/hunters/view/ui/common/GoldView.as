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
import com.agnither.hunters.view.ui.popups.shop.ShopPopup;
import com.agnither.ui.AbstractView;
import com.agnither.ui.ButtonContainer;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;

import starling.display.Image;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.text.TextField;

public class GoldView extends AbstractView {

    private var _value: TextField;
    private var _tip : TextField;
    private var _buy : ButtonContainer;
    public var item : Item;
    public var isSell : Boolean = true;
    private var _price : Number;
    public var touched : Boolean = false;

    public function GoldView() {
        createFromConfig(_refs.guiConfig.common.goldItem);

        this.touchable = true;
        for (var i : int = 0; i < numChildren; i++)
        {
            getChildAt(i).touchable = true;
            
        }
//        this.getChildAt(0).touchable = true;
//        this.getChildAt(1).touchable = true;
//        this.getChildAt(2).touchable = true;

        _value = _links.amount_tf;
        _tip = _links.tip_tf;
        _buy = _links.buy_btn;
        _buy.addEventListener(Event.TRIGGERED, onBuy);

        this.addEventListener(TouchEvent.TOUCH, onTouch);
    }

    private function onBuy(event : Event) : void
    {
        if(isSell)
        {
            Model.instance.progress.gold += _price;
            Model.instance.player.inventory.removeItem(item);
            Model.instance.progress.saveProgress();
        }
        else
        {

            if (Model.instance.progress.gold <= _price || _price <= 0)
            {
                return;
            }

            Model.instance.progress.gold -= _price;
            Model.instance.addPlayerItem(item);
            if (!item.isSpell())
//        if (_item.type != ItemTypeVO.spell)
            {
                Model.instance.shop.removeItem(item);
            }
            Model.instance.progress.saveProgress();

        }

    }

    override public function update() : void {

        _price = data as Number;
        _value.text = _price.toString();


        var str : String = item.description;
        var exts : Object = item.getExtensions();
        for (var key : String in exts)
        {
            if (key == DamageExt.TYPE || key == DefenceExt.TYPE || key == ManaExt.TYPE)
            {
            }
            if (str.length > 0)
            {
                str += "\n";
            }
            str += exts[key].getDescription();
//                str += Locale.getString(key);
        }
        if (str.length > 0)
        {
            _tip.text = str;
        }

        _buy.visible = true;
//        !Model.instance.player.inventory.isHaveSpell(item.id) && isPriceEnough;
        if(isSell) {
            _buy.visible = !item.isSpell();
            _buy.text = "Продать";
        }
        else
        {
            _buy.text = "Купить";
            var isPriceEnough : Boolean = Model.instance.progress.gold >= _price;
            _buy.visible = !Model.instance.player.inventory.isHaveSpell(item.id) && isPriceEnough

        }



        _buy.visible = !(isSell && item.isSpell());


    }

    private function onTouch(event : TouchEvent) : void
    {
        var touch : Touch = event.getTouch(this);
        this.touched = touch != null;
        coreDispatch(ShopPopup.HIDE_TOOLTIP, !this.touched);
    }
}
}
