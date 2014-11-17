/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.Model;

import flash.utils.Dictionary;

import starling.events.EventDispatcher;

public class PetsInventory extends EventDispatcher {

    public static const UPDATE: String = "update_PetsInventory";

    public static const TAMED: int = 1;
    public static const UNTAMED: int = 0;

    private var _data: Object;

    private var _petsList: Vector.<Pet> = new Vector.<Pet>();

    private var _petsDict: Object = {};
    public function getPet(uid: String):Pet {
        return _petsDict[uid];
    }

    private var _petsByType: Dictionary = new Dictionary();
    public function getPetsByType($type : String):Array { // of String
        var arr : Array = [];
        for (var i : int = 0; i < _petsList.length; i++)
        {
            var pet : Pet = _petsList[i];
            if(pet.id +"."+pet.level == $type) {
                arr.push(pet);
            }
        }
        return arr;
    }

    public function PetsInventory() {

    }

    public function init():void {
//        _petsByType[TAMED] = [];
        _petsByType[UNTAMED] = [];
    }

    public function parse(data : Object) : void {
        _data = data;
        for (var key: * in data) {
            var petData: Object = data[key];
            var pet : MonsterVO = Model.instance.monsters.getMonster(petData.id, petData.level);
            var newPet: Pet = new Pet(pet, petData);
            newPet.uniqueId = key;

            addPet(newPet);
        }
    }

    public function addPet(pet: Pet):void {
        if (!_petsDict[pet.uniqueId]) {
            _petsDict[pet.uniqueId] = pet;
            _petsByType[UNTAMED].push(pet.uniqueId);
            _petsList.push(pet);
        }
    }

    public function removePet(pet: Pet):void {
        if (_petsDict[pet.uniqueId]) {
            delete _petsDict[pet.uniqueId];
            delete _data[pet.uniqueId];

            var index: int = _petsByType[UNTAMED].indexOf(pet.uniqueId);
//            var index: int = _petsByType[pet.tamed].indexOf(pet.uniqueId);
            if (index >= 0) {
                _petsByType[UNTAMED].splice(index, 1);
//                _petsByType[pet.tamed].splice(index, 1);
            }

            index = _petsList.indexOf(pet);
            _petsList.splice(index, 1);

        }
    }

    public function update():void {
        dispatchEventWith(UPDATE);
    }

    public function get petsList() : Vector.<Pet> {
        return _petsList;
    }

    public function get pets() : Object
    {
        var petsObj : Object = {};
        for (var key : String in _petsDict)
        {
            petsObj[key] = (_petsDict[key] as Pet).params;
        }
        return petsObj;
    }
}
}
