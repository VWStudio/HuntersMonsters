/**
 * Created by mor on 04.10.2014.
 */
package com.agnither.hunters.view.ui.popups.traps {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.TrapVO;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.common.MonsterInfo;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Popup;
import com.cemaprjl.core.coreDispatch;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class TrapSetPopup extends Popup {

    public static const NAME : String = "com.agnither.hunters.view.ui.popups.traps.TrapSetPopup";

    private var _back : Image;
    private var _monster : MonsterInfo;
    private var _closeButton : ButtonContainer;

    private var _set1hButton : ButtonContainer;
    private var _set6hButton : ButtonContainer;
    private var _setNowButton : ButtonContainer;
    public static const SET_MODE : String = "set";
    public static const CHECK_MODE : String = "check";
    public static const REWARD_MODE : String = "reward";
    public static const DELETE_MODE : String = "delete";
    private var _title : TextField;
    private var _monsterVO : MonsterVO;
    private var _trap : TrapVO;
    private var _currentTerritory : MonsterAreaVO;
    private var _chance1 : TextField;
    private var _chance2 : TextField;
    private var _chance3 : TextField;
    private var _chances : Array;

    public function TrapSetPopup() {
        super();
    }


    override protected function initialize() : void {
        createFromConfig(_refs.guiConfig.trap_popup);

        _back = _links["bitmap_common_back"];
        _closeButton = _links["close_btn"];
        _closeButton.addEventListener(Event.TRIGGERED, handleClose);

        _title = _links["title_tf"];

        _set1hButton = _links["set1h_btn"];
        _set1hButton.text = "На 1 час";
        _set6hButton = _links["set6h_btn"];
        _set6hButton.text = "На 6 часов";
        _setNowButton = _links["setNow_btn"];
        _setNowButton.text = "Моментально";

        _set1hButton.addEventListener(Event.TRIGGERED, handleSet);
        _set6hButton.addEventListener(Event.TRIGGERED, handleSet);
        _setNowButton.addEventListener(Event.TRIGGERED, handleSet);

        _chance1 = _links["level1chance_tf"];
        _chance2 = _links["level2chance_tf"];
        _chance3 = _links["level3chance_tf"];


        _monster = _links.monster;
//        _monster.visible = false;
    }


    override public function update() : void {

//        _trap = Model.instance.currentTrap;


        _currentTerritory = MonsterAreaVO.DICT[data["id"]];

        var settedIndex : int = MonsterAreaVO.NAMES_LIST.indexOf(_currentTerritory.area);
        var trapIndex : int = MonsterAreaVO.NAMES_LIST.indexOf(_trap.area);

        var baseChance : Number = 100 + _trap.areaeffect * (trapIndex - settedIndex);
        _chance1.text = "Уровень 1: "+int(baseChance * _trap.leveleffect[0] + 1)+"%";
        _chance2.text = "Уровень 2: "+int(baseChance * _trap.leveleffect[1] + 1)+"%";
        _chance3.text = "Уровень 3: "+int(baseChance * _trap.leveleffect[2] + 1)+"%";

        _chances = [
            int(baseChance * _trap.leveleffect[0] * Model.instance.progress.getSkillMultiplier("9") + 1),
            int(baseChance * _trap.leveleffect[1] * Model.instance.progress.getSkillMultiplier("9") + 1),
            int(baseChance * _trap.leveleffect[2] * Model.instance.progress.getSkillMultiplier("9") + 1)];
        data["chances"] = _chances;

        if(data.id) {
            _monsterVO = Model.instance.monsters.getMonster(data.id, data.level ? data.level : 1);
            _monster.data = _monsterVO;
            _monster.update();
            _monster.visible = true;
        } else {
            _monster.visible = false;
        }
//        _monsterVO = MonsterVO.DICT[data.id];
        _set1hButton.visible = false;
        _set6hButton.visible = false;
        _setNowButton.visible = false;
        switch (data.mode) {
            case TrapSetPopup.CHECK_MODE:
                _title.text = "Ловушка ур."+(_trap.level);
                _setNowButton.visible = true;
                _setNowButton.text = "Удалить";
                break;
            case TrapSetPopup.DELETE_MODE:
                _title.text = "Ловушка ур."+(_trap.level);
                _setNowButton.visible = true;
                _setNowButton.text = "Удалить";
                break;
            case TrapSetPopup.REWARD_MODE:
                _title.text = "Монстр пойман";
                _setNowButton.visible = true;
                _setNowButton.text = "Забрать";
                break;
            case TrapSetPopup.SET_MODE:
            default :

                    //_title.text = "Установить ловушку ур."+(_trap.level + 1);
                _title.text = "Установить ловушку ур."+(_trap.level);
                _set1hButton.visible = true;
                _set6hButton.visible = true;
                _setNowButton.visible = true;
                _setNowButton.text = "Моментально";
                break;
        }

    }

    private function handleSet(event : Event) : void {
        switch (event.target) {
            case _set1hButton:
                data["time"] = 60;
//                data["time"] = 3600;
                data["chanceAdd"] = _trap.timechance[0];
                break;
            case _set6hButton:
                data["time"] = 3600 * 6;
                data["chanceAdd"] = _trap.timechance[1];

                break;
            case _setNowButton:
                if(data.mode == TrapSetPopup.SET_MODE) {
                    data["time"] = 0;
                    data["chanceAdd"] = _trap.timechance[2];
                } else {
                    if(data.mode == TrapSetPopup.REWARD_MODE) {


                        var petData : Object = {};
                        petData.uniqueId = "caught.pet." + Model.instance.player.pets.petsList.length;
                        petData.id = _monsterVO.id;
                        petData.level = _monsterVO.level;
                        petData.hp = _monsterVO.hp * 0.5;
                        petData.damage = _monsterVO.damage;
                        petData.defence = _monsterVO.defence;
                        petData.magic = _monsterVO.magic;
                        petData.tamed = 0;
                        var pet : Pet = new Pet(_monsterVO, petData);
                        pet.uniqueId = petData.uniqueId;

                        Model.instance.player.pets.addPet(pet);
//                        coreDispatch(MapScreen.DELETE_TRAP, data.marker);
                    } else {
//                        coreDispatch(MapScreen.DELETE_TRAP, data.marker);
                    }
                    coreDispatch(UI.HIDE_POPUP, NAME);
                    return;
                }
                break;
        }
//        coreDispatch(MapScreen.ADD_TRAP, data);
        coreDispatch(UI.HIDE_POPUP, NAME);
    }

    override protected function handleClose(event : Event) : void {
        coreDispatch(UI.HIDE_POPUP, NAME);
    }

}
}
