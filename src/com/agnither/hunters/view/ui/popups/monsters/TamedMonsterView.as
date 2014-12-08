/**
 * Created by agnither on 25.08.14.
 */
package com.agnither.hunters.view.ui.popups.monsters {
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.ui.AbstractView;
import com.agnither.ui.ButtonContainer;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.viewmanage.ShowPopupCmd;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class TamedMonsterView extends AbstractView {

    private var _pet: Pet;
    public function get pet():Pet {
        return _pet;
    }

    protected var _picture: Image;

    private var _name: TextField;
    private var _killed : Image;
    private var _monsterID : String;
    private var _monsterArea : String;
    private var _monster : MonsterVO;
    private var _tint : Image;
    private var _tame : ButtonContainer;
    private var isUnlocked : Boolean = false;
    private var isTamed : Boolean = false;
    private var isBattle : Boolean = false;

    public function TamedMonsterView($monsterID : String) {
//        _pet;
        _monsterID = $monsterID;
        _monsterArea = MonsterAreaVO.DICT[$monsterID];
        _monster = Model.instance.monsters.getMonster($monsterID, 1);
    }

    override protected function initialize():void {
        createFromConfig(_refs.guiConfig.common.tamedMonster);

        _picture = _links["bitmap_monster_1.png"] as Image;
//        _picture.touchable = true;
        _picture.texture = _refs.gui.getTexture(_monster.picture);
        _picture.readjustSize();

        _name = _links.name_tf;
        _tint = _links["bitmap_common_disabled_tint"];

        if(_picture.width > _tint.width) {
            _picture.width = _tint.width;
            _picture.scaleY = _picture.scaleX;
        }
        if(_picture.height > _tint.height) {
            _picture.height = _tint.height;
            _picture.scaleX = _picture.scaleY;
        }

        _tame = _links["tame_btn"];
        _tame.addEventListener(Event.TRIGGERED, onTame);

        _name.text = Locale.getString(_monsterID);

        isUnlocked = Model.instance.progress.unlockedLocations.indexOf(_monsterID) >= 0;
        _tint.visible = !isUnlocked;

        isTamed = Model.instance.progress.tamedMonsters.indexOf(_monsterID) >= 0;
        isBattle = Model.instance.state == BattleScreen.NAME;

        _tame.visible = isUnlocked && !isTamed || isBattle;
        _tame.text = isBattle ? "Вызвать" : "Приручить";


    }

    private function onTame(event : Event) : void {

        if(isBattle) {

            var monster : MonsterVO = Model.instance.monsters.getMonster(_monsterID, 1);
            monster.hp = monster.hp * 0.5;
            var pet : Pet = new Pet(monster, monster);

            Model.instance.summonTimes++;
            coreDispatch(LocalPlayer.PET_SELECTED, pet);
            coreDispatch(UI.HIDE_POPUP, SelectMonsterPopup.NAME);

//            coreDispatch(BattleScreen.SUMMON_BUTTON_UPDATE);

        } else {
            coreExecute(ShowPopupCmd, TameMonsterPopup.NAME, _monsterID);
        }

    }


    override public function destroy():void {
        super.destroy();

        _pet = null;
        _picture = null;
        _name = null;
    }
}
}
