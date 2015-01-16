/**
 * Created by mor on 23.09.2014.
 */
package com.agnither.hunters.view.ui.common {
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.hunters.view.ui.popups.monsters.TamedMonsterView;
import com.agnither.ui.AbstractView;
import com.agnither.ui.ButtonContainer;
import com.cemaprjl.core.coreDispatch;

import flash.ui.Mouse;

import flash.ui.MouseCursor;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import starling.text.TextField;

public class MonsterInfo extends AbstractView {
    private var _hpVal : TextField;
    private var _damageVal : TextField;
    private var _armorVal : TextField;
    private var _monster : MonsterVO;
    private var _nameVal : TextField;
    private var _killed : Image;
    private var _icon : Image;
    private var _damageType : Image;
    private var _iconShield : Image;
    private var _iconHp : Image;
    private var _sellButton : ButtonContainer;
    private var _back : Sprite;

    private var _hideInfo : Boolean;

    public function MonsterInfo() {
        super();
    }


    override protected function initialize() : void {

        _back = getChildAt(0) as Sprite;

        _nameVal = _links["name_tf"];
        _hpVal = _links["hp_tf"];
        _icon = _links["icon"].getChildAt(0) as Image;

        _nameVal.visible = false;

        //_damageType = new Image(_refs.gui.getTexture(MagicTypeVO.DICT[_monster.damagetype].picturedamage));

        //_damageType = _links["damage_type_icon"].getChildAt(0) as Image;
        //_damageType.visible = false;

        _damageType = _links["bitmap_chip_sword"];
        _iconShield = _links["bitmap_itemicon_shield"];
        _iconShield.visible = false;
        _iconHp = _links["bitmap_battle_stats_icons"];
        _iconHp.visible = false;
        //_damageType.visible = false;

        _damageVal = _links["damage_tf"];
        _armorVal = _links["armor_tf"];
        _killed = _links["bitmap_common_killed"];
        _killed.visible = false;

        _sellButton = _links["buy_btn"];
        _sellButton.visible = false;

        _hideInfo = false;

    }


    override public function update() : void {

        //var petExt : PetExt = _item.getExtension(PetExt.TYPE) as PetExt;
        //var monster : MonsterVO = petExt.getMonster();
        //magicType = MagicTypeVO.DICT[monster.damagetype];
        //texName = magicType.picturedamage;

        _monster = (data as MonsterVO);
        if (_hideInfo)
        {
            _hpVal.text = "";
            _damageVal.text = "";
            _armorVal.text = "";
            _nameVal.text = "";
            _damageType.visible = false;
            _iconShield.visible = false;
            _iconHp.visible = false;
        }
        else
        {
            _hpVal.text = _monster.hp.toString();
            _damageVal.text = _monster.damage.toString();
            _armorVal.text = _monster.defence.toString();
            _nameVal.text = Locale.getString(_monster.id) + " "+_monster.level+ "ур";
            _damageType.texture = _refs.gui.getTexture(MagicTypeVO.DICT[_monster.damagetype].picturedamage);
            _iconShield.visible = true;
            _iconHp.visible = true;
        }

        _killed.visible = false;
        _icon.texture = _refs.gui.getTexture(_monster.picture);
        _icon.readjustSize();
        var byWid : Boolean = _icon.width > _icon.height;
        if(byWid) {
            _icon.width = _back.width;
            _icon.scaleY = _icon.scaleX;
        } else {
            _icon.height = _back.height;
            _icon.scaleX = _icon.scaleY;
        }
        _icon.x = (_back.width - _icon.width) * 0.5;
        _icon.y = (_back.height - _icon.height) * 0.5;

    }

    public function set hideInfo($val : Boolean):void {
        _hideInfo = $val;
    }

    public function set killed($val : Boolean):void {
        _killed.visible = $val;
    }

    public function get monster() : MonsterVO {
        return _monster;
    }
}
}
