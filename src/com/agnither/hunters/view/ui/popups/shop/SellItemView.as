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
import com.agnither.hunters.model.player.inventory.Spell;
import com.agnither.hunters.view.ui.common.ItemManaView;
import com.agnither.hunters.view.ui.screens.battle.player.DropSlotView;
import com.agnither.hunters.view.ui.screens.battle.player.inventory.ItemView;
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

//    protected var _mana : Vector.<ItemManaView>;

//    protected var _select : Image;
//    protected var _picture : Image;

//    protected var _damage : TextField;
    private var _buyButton : ButtonContainer;
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

        _buyButton = _links["buy_btn"];
        _buyButton.text = "Продать";
        _buyButton.addEventListener(Event.TRIGGERED, onSell);


        _itemView = ItemView.getItemView(_item);
        addChild(_itemView);
        _itemView.touchable = true;
        _itemView.noSelection();

        _itemView.addEventListener(TouchEvent.TOUCH, onTouch);
//        _damage = _links.damage_tf;

        if (_item.getDamage())
        {
            _price = int(Model.instance.getPrice(item.getDamage()) * 0.6);
        }
        else if (_item.getDefence())
        {
            _price = int(Model.instance.getPrice(item.getDefence() * 0.6));
        }
        if (item.isSpell())
        {
            _price = 0;
            _buyButton.visible = false;
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
        var touch: Touch = e.getTouch(_itemView);

        if (touch == null) {
            coreDispatch(ShopPopup.HIDE_TOOLTIP);
        } else if(touch.phase == TouchPhase.HOVER) {
            coreDispatch(ShopPopup.SHOW_TOOLTIP, this);
        }

    }
}
}
