/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.MonsterVO;

import flash.utils.Dictionary;

import starling.events.EventDispatcher;

public class PetsInventory extends EventDispatcher {

    public static const UPDATE: String = "update_PetsInventory";

    public static const TAMED: int = 1;
    public static const UNTAMED: int = 0;

    private var _data: Object;

    private var _petsDict: Dictionary = new Dictionary();
    public function getPet(uid: String):Pet {
        return _petsDict[uid];
    }

    private var _petsByType: Dictionary = new Dictionary();
    public function getPetsByType(type : int):Array { // of String
        return _petsByType[type];
    }

    public function PetsInventory() {

    }

    public function init():void {
        _petsByType[TAMED] = [];
        _petsByType[UNTAMED] = [];
    }

    public function parse(data : Object) : void {
        _data = data;
        for (var key: * in data) {
            var petData: Object = data[key];
            var pet : MonsterVO = MonsterVO.DICT[petData.id];
            var newPet: Pet = new Pet(pet, petData);
            newPet.uniqueId = key;

            _petsDict[key] = newPet;
            _petsByType[petData.tamed].push(key);
        }
    }

    public function addPet(pet: Pet):void {
        if (!_petsDict[pet.uniqueId]) {
            _petsDict[pet.uniqueId] = pet;
            _petsByType[pet.tamed].push(pet.uniqueId);
            _data[pet.uniqueId] = pet.params;
        }
    }

    public function removePet(pet: Pet):void {
        if (_petsDict[pet.uniqueId]) {
            delete _petsDict[pet.uniqueId];
            delete _data[pet.uniqueId];

            var index: int = _petsByType[pet.tamed].indexOf(pet.uniqueId);
            if (index >= 0) {
                _petsByType[pet.tamed].splice(index, 1);
            }
        }
    }

    public function update():void {
        dispatchEventWith(UPDATE);
    }
}
}
