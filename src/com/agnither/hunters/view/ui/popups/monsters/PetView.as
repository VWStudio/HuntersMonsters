/**
 * Created by agnither on 25.08.14.
 */
package com.agnither.hunters.view.ui.popups.monsters {
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.ui.AbstractView;
import com.agnither.ui.ButtonContainer;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class PetView extends AbstractView {

    private var _pet: Pet;
    public function get pet():Pet {
        return _pet;
    }

    protected var _picture: Image;

    private var _name: TextField;
    private var _hp: TextField;
    private var _armor: TextField;
    private var _damage: TextField;
    private var _killed : Image;
    private var _sellButton : ButtonContainer;
    private var _price : Number = 0;
    private var _buyable : Boolean;
    private var _item : ItemView;

    public function PetView(pet: Pet) {
        _pet = pet;
        var isTame:Boolean = Model.instance.progress.tamedMonsters.indexOf(_pet.monster.id) >= 0;
        _item = ItemView.create(Item.create(ItemVO.createPetItemVO(_pet.monster,isTame)))
    }

    override protected function initialize():void {
        // XXXCOMMON
        createFromConfig(_refs.guiConfig.common.monster);
//        createFromCommon(_refs.guiConfig.common.monster);

        _picture = _links.icon.getChildAt(0) as Image;
        _picture.touchable = true;
        _picture.texture = _refs.gui.getTexture(_pet.picture);
        this.touchable = true;

        /* _picture.readjustSize();
       var byWid : Boolean = _picture.width > _picture.height;
        if(byWid) {
            _picture.width = _picture.width;
            _picture.scaleY = _picture.scaleX;
        } else {
            _picture.height = _picture.height;
            _picture.scaleX = _picture.scaleY;
        }
        _picture.x = (_picture.width - _picture.width) * 0.5;
        _picture.y = (_picture.height - _picture.height) * 0.5;*/


//        _links.damage_icon.getChildAt(0).texture = _refs.gui.getTexture("hit.png");

        var damageType: MagicTypeVO = MagicTypeVO.DICT[_pet.params.magic];
        _links.damage_type_icon.getChildAt(0).texture = _refs.gui.getTexture(damageType.picturedamage);
        //_links.damage_type_icon.visible = false;

        _name = _links.name_tf;
        _hp = _links.hp_tf;
        _armor = _links.armor_tf;
        _damage = _links.damage_tf;

        _name.text = Locale.getString(_pet.id) + " [" + String(_pet.params.level)+"]";
//        _name.text = String(_pet.name) + " " + String(_pet.params.level);
        _hp.text = String(_pet.params.hp);
        _armor.text = String(_pet.params.defence);
        _damage.text = String(_pet.params.damage);

        _killed = _links["bitmap_common_killed"];
        _killed.visible = false;

        _sellButton = _links["buy_btn"];
        _sellButton.text = "Продать";
        _sellButton.addEventListener(Event.TRIGGERED, onSell);
        _sellButton.visible = false;

        _price = Model.instance.getPrice(pet.level, "pet_level");

    }

    public function setBuyable($val : Boolean = false):void {
        _buyable = $val;
        _sellButton.visible = _buyable && _price <= Model.instance.progress.gold;

    }

    private function onSell(event : Event) : void
    {
        Model.instance.player.pets.removePet(pet);
        Model.instance.progress.gold += _price;
        Model.instance.progress.saveProgress();
    }


    override public function destroy():void {
        super.destroy();

        _pet = null;
        _picture = null;
        _name = null;
        _hp = null;
        _armor = null;
        _damage = null;
    }

    public function get item() : ItemView
    {
        return _item;
    }

    public function set item(value : ItemView) : void
    {
        _item = value;
    }
}
}
