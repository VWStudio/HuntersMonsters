/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.personage.Personage;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.core.Starling;
import starling.display.Button;
import starling.events.Event;
import starling.text.TextField;

public class HeroView extends AbstractView {

    private var _hero: Personage;

    private var _name: TextField;
    private var _hp: TextField;
    private var _armor: TextField;
    private var _damage: TextField;
    private var _hit: TextField;

    private var _btn: Button;

    public function HeroView(refs:CommonRefs, hero: Personage) {
        _hero = hero;

        super(refs);
    }

    override protected function initialize():void {
        createFromCommon(_refs.guiConfig.common.hero);

        _links.hp_icon.getChildAt(0).texture = _refs.gui.getTexture("heart.png");
        _links.armor_icon.getChildAt(0).texture = _refs.gui.getTexture("shild.png");
        _links.damage_icon.getChildAt(0).texture = _refs.gui.getTexture("hit.png");
        _links.damage_type_icon.getChildAt(0).texture = _refs.gui.getTexture("m_2.png");

        _name = _links.name_tf;
        _hp = _links.hp_tf;
        _armor = _links.armor_tf;
        _damage = _links.damage_tf;
        _hit = _links.hit_tf;

        _btn = _links.monster_btn;
        _btn.visible = false;

        _hero.addEventListener(Personage.UPDATE, handleUpdate);
        handleUpdate();

        _hero.addEventListener(Personage.HIT, handleHit);
        hideHit();
    }

    private function handleUpdate(e: Event = null):void {
        _name.text = String(_hero.name) + " " + String(_hero.level);
        _hp.text = String(_hero.hp) + "/" + String(_hero.maxHP);
        _armor.text = String(_hero.defence);
        _damage.text = String(_hero.damage);

        _btn.visible = _hero.dead;
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
