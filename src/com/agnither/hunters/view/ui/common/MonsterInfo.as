/**
 * Created by mor on 23.09.2014.
 */
package com.agnither.hunters.view.ui.common {
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.ui.AbstractView;
import com.agnither.ui.ButtonContainer;

import starling.display.Image;

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
    private var _sellButton : ButtonContainer;
    public function MonsterInfo() {
        super();
    }


    override protected function initialize() : void {

        _nameVal = _links["name_tf"];
        _hpVal = _links["hp_tf"];
        _icon = _links["icon"].getChildAt(0) as Image;
        _damageType = _links["damage_type_icon"].getChildAt(0) as Image;
        _damageVal = _links["damage_tf"];
        _armorVal = _links["armor_tf"];
        _killed = _links["bitmap_common_killed"];
        _killed.visible = false;

        _sellButton = _links["buy_btn"];
        _sellButton.visible = false;
    }


    override public function update() : void {

        _monster = (data as MonsterVO);
        _hpVal.text = _monster.hp.toString();
        _damageVal.text = _monster.damage.toString();
        _armorVal.text = _monster.defence.toString();
        _nameVal.text = Locale.getString(_monster.id) + " ["+_monster.level+ "]";
        _killed.visible = false;

        _icon.texture = _refs.gui.getTexture(_monster.picture);
        _damageType.texture = _refs.gui.getTexture(MagicTypeVO.DICT[_monster.magic].picturedamage);
    }

    public function set killed($val : Boolean):void {
        _killed.visible = $val;
    }

    public function get monster() : MonsterVO {
        return _monster;
    }
}
}
