/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player {
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.extensions.DamageExt;
import com.agnither.hunters.model.modules.extensions.DoubleDropExt;
import com.agnither.hunters.model.modules.extensions.ManaAddExt;
import com.agnither.hunters.model.modules.extensions.MirrorDamageExt;
import com.agnither.hunters.model.modules.extensions.ResurrectPetExt;
import com.agnither.hunters.model.modules.extensions.SpellDefenceExt;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.model.player.personage.Personage;
import com.agnither.hunters.model.player.personage.Progress;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;

import starling.events.Event;

public class LocalPlayer extends Player {

    public static const ITEM_SELECTED : String = "LocalPlayer.ITEM_SELECTED";
    public static const PET_SELECTED: String = "pet_selected_MonstersView";

    private var _progress : Progress;
    private var _ressurrectedPet : Boolean = false;


    public function LocalPlayer() {
        id = "player user";
        super();
        hero.isPlayer = true;
        coreAddListener(LocalPlayer.ITEM_SELECTED, selectItem);
        coreAddListener(LocalPlayer.PET_SELECTED, handleSummonPet);
    }

    override public function init($data : Object) : void {
        super.init($data);
        initInventory($data.getItems(), $data.getInventory());

        updateGlobalExtensions();

        initPets($data.getPets());

        _pet.addEventListener(Personage.DEAD, handlePetDead);



    }

    private function handlePetDead(e : Event) : void
    {
        if(Model.instance.resurrectPet && !_ressurrectedPet) {

            var monster : MonsterVO = Model.instance.monsters.getMonster(_pet.id, 1);
            monster.hp = monster.hp * 0.5 * Model.instance.resurrectPet.getPercent();
            var pet : Pet = new Pet(monster, monster);
            _ressurrectedPet = true;
            handleSummonPet(pet);
//            coreDispatch(LocalPlayer.PET_SELECTED, pet, true);
        }

//        coreDispatch(BattleScreen.SUMMON_BUTTON_UPDATE);

    }

    public function addItem(item : Item) : void {
        _inventory.addItem(item);
    }


    private function selectItem(item : Item) : void {
        if (item.isWearing)
        {
            _inventory.unwearItem(item);
        }
        else
        {
            _inventory.wearItem(item);
        }

        updateGlobalExtensions();

    }


    override public function startMove() : void
    {
        if(manaAdd) {
            var mana : MagicTypeVO = MagicTypeVO.DICT[manaAdd.type];
            _manaList.addMana(mana.name, manaAdd.amount);
        }
    }

//    private function updateGlobalExtensions() : void
//    {
//        Model.instance.doubleDrop = null;
//        Model.instance.mirrorDamage = null;
//        Model.instance.manaAdd = null;
//        Model.instance.spellsDefence = [];
////        Model.instance.resurrectPet = null;
//
//        for (var i : int = 0; i < _inventory.inventoryItems.length; i++) {
//            var item: Item = _inventory.getItem(_inventory.inventoryItems[i]);
//            if (!item.isSpell()) {
//
//                for (var extType : String in item.getExtensions())
//                {
//                    if(extType == DamageExt.TYPE) {
//                        _hero.damageType = (item.getExtension(extType) as DamageExt).getType();
//                    }
//                    if(extType == DoubleDropExt.TYPE) {
//                        Model.instance.doubleDrop = item.getExtension(extType) as DoubleDropExt;
//                    }
//                    if(extType == MirrorDamageExt.TYPE) {
//                        Model.instance.mirrorDamage = item.getExtension(extType) as MirrorDamageExt;
//                    }
//                    if(extType == ManaAddExt.TYPE) {
//                        Model.instance.manaAdd = item.getExtension(extType) as ManaAddExt;
//                    }
//                    if(extType == SpellDefenceExt.TYPE) {
//                        Model.instance.spellsDefence.push(item.getExtension(extType));
//                    }
////                    if(extType == ResurrectPetExt.TYPE) {
////                        Model.instance.resurrectPet = item.getExtension(extType) as ResurrectPetExt;
////                    }
//                }
//            }
//        }
//
//    }

//    public function get progress() : Progress {
//        return _progress;
//    }

    public function resetToBattle() : void {
        hero.healMax();
        pet.unsummon();
        _ressurrectedPet = false;

        var petsInstaled : Array = inventory.getItemsInSlot("1");
        if(petsInstaled && petsInstaled.length > 0) {
            var petItem : Item = petsInstaled[0] as Item;
            var monster : MonsterVO = MonsterVO.DICT[petItem.name][1];
            handleSummonPet(new Pet(monster, monster));
        }
    }
}
}
