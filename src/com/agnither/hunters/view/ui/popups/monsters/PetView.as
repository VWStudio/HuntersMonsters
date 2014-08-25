/**
 * Created by agnither on 25.08.14.
 */
package com.agnither.hunters.view.ui.popups.monsters {
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
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

    public function PetView(refs:CommonRefs, pet: Pet) {
        _pet = pet;
        super(refs);
    }

    override protected function initialize():void {
        createFromCommon(_refs.guiConfig.common.monster);

        _picture = _links.icon.getChildAt(0) as Image;
        _picture.touchable = true;
        _picture.texture = _refs.gui.getTexture(_pet.picture);

        _links.hp_icon.getChildAt(0).texture = _refs.gui.getTexture("heart.png");
        _links.armor_icon.getChildAt(0).texture = _refs.gui.getTexture("shild.png");
        _links.damage_icon.getChildAt(0).texture = _refs.gui.getTexture("hit.png");

        var damageType: DamageTypeVO = DamageTypeVO.DICT[_pet.params.magic];
        _links.damage_type_icon.getChildAt(0).texture = _refs.gui.getTexture(damageType.picture);

        _name = _links.name_tf;
        _hp = _links.hp_tf;
        _armor = _links.armor_tf;
        _damage = _links.damage_tf;

        _name.text = String(_pet.name) + " " + String(_pet.params.level);
        _hp.text = String(_pet.params.hp);
        _armor.text = String(_pet.params.defence);
        _damage.text = String(_pet.params.damage);
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
}
}
