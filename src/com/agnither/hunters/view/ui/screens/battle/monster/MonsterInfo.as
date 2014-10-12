/**
 * Created by mor on 23.09.2014.
 */
package com.agnither.hunters.view.ui.screens.battle.monster {
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.ui.AbstractView;

import starling.display.Image;

import starling.text.TextField;

public class MonsterInfo extends AbstractView {
    private var _hpVal : TextField;
    private var _damageVal : TextField;
    private var _armorVal : TextField;
    private var _monster : MonsterVO;
    private var _nameVal : TextField;
    private var _killed : Image;
    public function MonsterInfo() {
        super();
    }


    override protected function initialize() : void {

        _nameVal = _links["name_tf"];
        _hpVal = _links["hp_tf"];
        _damageVal = _links["damage_tf"];
        _armorVal = _links["armor_tf"];
        _killed = _links["bitmap_killed"];
        _killed.visible = false;

    }


    override public function update() : void {

        _monster = (data as MonsterVO);
        _hpVal.text = _monster.hp.toString();
        _damageVal.text = _monster.damage.toString();
        _armorVal.text = _monster.defence.toString();
        _nameVal.text = _monster.name;
        _killed.visible = false;

    }

    public function set killed($val : Boolean):void {
        _killed.visible = $val;
    }

    public function get monster() : com.agnither.hunters.model.modules.monsters.MonsterVO {
        return _monster;
    }
}
}
