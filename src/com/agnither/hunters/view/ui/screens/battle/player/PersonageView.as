/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.model.player.personage.Hero;
import com.agnither.hunters.model.player.personage.Monster;
import com.agnither.hunters.model.player.personage.Personage;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.core.Starling;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class PersonageView extends AbstractView {

    private var _personage: Personage;
    public function set personage(value: Personage):void {
        _personage = value;

        _personage.addEventListener(Personage.UPDATE, handleUpdate);
        handleUpdate();

        _personage.addEventListener(Personage.HIT, handleHit);
        hideHit();
    }

    private var _picture: Image;

    private var _name: TextField;
    private var _hp: TextField;
    private var _armor: TextField;
    private var _damage: TextField;
    private var _hit: TextField;

    public function PersonageView() {
    }

    override protected function initialize():void {
        _picture = getChildAt(0) as Image;

        _links.hp_icon.getChildAt(0).texture = _refs.gui.getTexture("heart.png");
        _links.armor_icon.getChildAt(0).texture = _refs.gui.getTexture("shild.png");
        _links.damage_icon.getChildAt(0).texture = _refs.gui.getTexture("hit.png");

        _name = _links.name_tf;
        _hp = _links.hp_tf;
        _armor = _links.armor_tf;
        _damage = _links.damage_tf;
        _hit = _links.hit_tf;
    }

    private function handleUpdate(e: Event = null):void {
        if (!_personage.dead) {
            _links.damage_type_icon.getChildAt(0).texture = _personage is Hero ? _refs.gui.getTexture(DamageTypeVO.weapon.picture) : _refs.gui.getTexture(_personage.magic.picture);

            if (_personage.picture) {
                _picture.texture = _refs.gui.getTexture(_personage.picture);
                _picture.readjustSize();
                _picture.x = _picture.y = 0;
            }
        }

        _name.text = String(_personage.name) + " " + String(_personage.level);
        _hp.text = String(_personage.hp) + "/" + String(_personage.maxHP);
        _armor.text = String(_personage.defence);
        _damage.text = String(_personage.damage);

        visible = !_personage.dead;
    }

    private function handleHit(e: Event):void {
        _hit.text = String(e.data);
        _hit.visible = true;
        Starling.juggler.delayCall(hideHit, 1);
    }

    private function hideHit():void {
        _hit.visible = false;
    }
}
}
