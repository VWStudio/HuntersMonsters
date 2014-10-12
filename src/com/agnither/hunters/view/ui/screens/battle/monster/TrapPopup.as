/**
 * Created by mor on 04.10.2014.
 */
package com.agnither.hunters.view.ui.screens.battle.monster {
import com.agnither.hunters.App;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Popup;
import com.cemaprjl.core.coreDispatch;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class TrapPopup extends Popup {

    public static const NAME : String = "com.agnither.hunters.view.ui.screens.battle.monster.TrapPopup";

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

    public function TrapPopup() {
        super();
    }


    override protected function initialize() : void {
        createFromConfig(_refs.guiConfig.trap_popup);

        _back = _links["bitmap__bg"];
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

        _monster = _links.monster;
    }


    override public function update() : void {

        _monsterVO = Model.instance.monsters.getMonster(data.id);
//        _monsterVO = MonsterVO.DICT[data.id];
        _monster.data = _monsterVO;
        _monster.update();
        _set1hButton.visible = false;
        _set6hButton.visible = false;
        _setNowButton.visible = false;
        switch (data.mode) {
            case TrapPopup.CHECK_MODE:
                _title.text = "Ловушка";
                _setNowButton.visible = true;
                _setNowButton.text = "Удалить";
                break;
            case TrapPopup.DELETE_MODE:
                _title.text = "Ловушка";
                _setNowButton.visible = true;
                _setNowButton.text = "Удалить";
                break;
            case TrapPopup.REWARD_MODE:
                _title.text = "Монстр пойман";
                _setNowButton.visible = true;
                _setNowButton.text = "Забрать";
                break;
            case TrapPopup.SET_MODE:
            default :
                _title.text = "Установить ловушку";
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
                data["chance"] = 0.5;
                break;
            case _set6hButton:
                data["time"] = 3600 * 6;
                data["chance"] = 0.85;

                break;
            case _setNowButton:
                if(data.mode == TrapPopup.SET_MODE) {
                    data["time"] = 0;
                    data["chance"] = 1;
                } else {
                    if(data.mode == TrapPopup.REWARD_MODE) {


                        var petData : Object = {};
                        petData.uniqueId = "caught.pet." + Model.instance.player.pets.pets.length;
                        petData.id = _monsterVO.id;
                        petData.level = _monsterVO.level;
                        petData.hp = _monsterVO.hp * 0.5;
                        petData.damage = _monsterVO.damage;
                        petData.defence = _monsterVO.defence;
                        petData.magic = _monsterVO.magic;
                        petData.tamed = 1;
                        var pet : Pet = new Pet(_monsterVO, petData);
                        pet.uniqueId = petData.uniqueId;

                        Model.instance.player.pets.addPet(pet);
                        coreDispatch(MapScreen.DELETE_TRAP, data.marker);
                    } else {
                        coreDispatch(MapScreen.DELETE_TRAP, data.marker);
                    }
                    coreDispatch(UI.HIDE_POPUP, NAME);
                    return;
                }
                break;
        }
        coreDispatch(MapScreen.ADD_TRAP, data);
        coreDispatch(UI.HIDE_POPUP, NAME);
    }

    private function handleClose(event : Event) : void {
        coreDispatch(UI.HIDE_POPUP, NAME);
    }

}
}
