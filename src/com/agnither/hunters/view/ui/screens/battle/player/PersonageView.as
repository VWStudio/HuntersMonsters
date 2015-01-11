/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.player.personage.Hero;
import com.agnither.hunters.model.player.personage.Monster;
import com.agnither.hunters.model.player.personage.Personage;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import flash.geom.Point;

import starling.core.Starling;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class PersonageView extends AbstractView {

    private var _personage: Personage;
    private var _isRight : Boolean = false;
    public var isEnemy : Boolean = false;

    public function set isStandRight($val : Boolean) :void {
        _isRight = $val;
    }

    public function set personage(value: Personage):void {
//        if(value is Monster) {
//            trace("SET PERSONAGE", value, value.id, value.hp, value.isDead);
//        }
        _personage = value;
        _personage.addEventListener(Personage.UPDATE, handleUpdate);
        _personage.addEventListener(Personage.HIT, handleHit);
        this.visible = false;

        if(!value || !value.id) return;


        handleUpdate();

        updateImage();

        hideHit();
    }

    private function updateImage() : void
    {
//        trace("UPDATE PERS IMAGE", _personage.isDead);
        _picturePos = new Point(isEnemy ? (_progressLine.x - _progressLine.width * 0.5) : (_progressLine.x + _progressLine.width * 0.5), 0);
        if (_personage.picture) {
            _picture.texture = _refs.gui.getTexture(_personage.picture);
            _picture.readjustSize();
            _picture.pivotX = _picture.width * 0.5;
            _picture.pivotY = _picture.height;
            _picture.scaleX = _isRight ? -1 : 1;
            _picture.y = _picturePos.y;
            _picture.x = _picturePos.x;
        }
    }

    private var _picture: Image;

    private var _name: TextField;
    private var _hp: TextField;
    private var _armor: TextField;
    private var _damage: TextField;
    private var _hit: TextField;
    private var _currentMarker : Image;
    private var _progressLine : Image;
    private var _attackType : Image;
    private var _hitImage : Image;
    public var isPet : Boolean = false;
    private var _picturePos : Point;
    private var _statsIcons : Image;
    private var _statsIconsShield : Image;
    private var _statsBack : Image;

    public function PersonageView() {
    }

    override protected function initialize():void {
        _picture = _links["bitmap_hero.png"];


        _currentMarker = _links["bitmap_battle_current_player"];
        _currentMarker.visible = false;
        _progressLine = _links["bitmap_battle_progress_line"];

        _statsIcons = _links["bitmap_battle_stats_icons"];
        _statsBack = _links["bitmap_battle_stats"];

        _statsIconsShield = _links["bitmap_itemicon_shield"];

        _attackType = _links["bitmap_chip_sword"];

        _name = _links.name_tf;
        _hp = _links.hp_tf;
        _armor = _links.armor_tf;
        _damage = _links.damage_tf;
        _hit = _links.hit_tf;
        _hitImage = _links["bitmap_battle_hit"];
        _hitImage.visible = false;

    }

    private function handleUpdate(e: Event = null):void {

//        trace("UPDATE PERS", _personage.isDead);

        if (!_personage.isDead) {
            this.visible = true;

        } else {
            this.visible = isPet ? false : true;
        }

        _statsIcons.visible = !isPet;
        _statsBack.visible = !isPet;
        _statsIconsShield.visible = !isPet;

        _name.visible = !isPet;
        _name.text = (_personage.name ? String(_personage.name) : Locale.getString(_personage.id)) + " " + String(_personage.level)+"ур";

        _hp.visible = !isPet;
        _hp.text = String(_personage.hp); //+ "/" + String(_personage.maxHP)
        _progressLine.visible = !isPet;
        _progressLine.scaleX = isEnemy ? -_personage.hp / _personage.maxHP : _personage.hp / _personage.maxHP;

        _armor.visible = !isPet;
        _armor.text = String(_personage.getDefence());
//        _damage.visible = !isPet;
        _damage.text = String(_personage.damage);
        _damage.visible = false;
//        _damage.text = String(_personage.damage);
        _currentMarker.visible = _personage.current;

        var dmgType : MagicTypeVO = MagicTypeVO.DICT[_personage.damageType];
        _attackType.visible = false;
        _attackType.texture = _refs.gui.getTexture(dmgType.picturedamage);
        _attackType.visible = false;


        //hideHit();
//        for (var i : int = 0; i < numChildren; i++)
//        {
//            var object : Object = getChildAt(i);
//        }
        
//        visible = !_personage.isDead;
    }

    private function handleHit(e: Event):void {
        _hit.text = String(e.data);
        _hit.visible = true;
        _hitImage.visible = true;
        _hitImage.alpha = 0;
        Starling.juggler.tween(_hitImage, 0.2, {alpha:1});
        Starling.juggler.delayCall(alphaHit, 0.8);
    }

    private function alphaHit():void {
        Starling.juggler.tween(_hitImage, 0.8, {alpha:0});
        Starling.juggler.delayCall(hideHit, 0.8);
    }

    private function hideHit():void {
        _hit.visible = false;
        _hitImage.visible = false;
    }
}
}
