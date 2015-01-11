/**
 * Created by agnither on 25.08.14.
 */
package com.agnither.hunters.view.ui.popups.monsters {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.hunters.model.player.personage.Monster;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.common.items.ItemView;
import com.agnither.hunters.view.ui.popups.inventory.InventoryPopup;
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
    private var _isInstalled : Boolean = false;
    private var _item : ItemView;
    private var _back : Image;
    private var _tameIcon : Image;

    public function TamedMonsterView($monsterID : String) {
//        _pet;
        _monsterID = $monsterID;
        _monsterArea = MonsterAreaVO.DICT[$monsterID];
        _monster = Model.instance.monsters.getMonster($monsterID, 1);
        var isTame:Boolean = Model.instance.progress.tamedMonsters.indexOf(_monster.id) >= 0;
        _item = ItemView.create(Item.create(ItemVO.createPetItemVO(_monster,isTame)))
    }


    override public function update() : void
    {


        _picture.texture = _refs.gui.getTexture(_monster.picture);
        _picture.readjustSize();
        _picture.touchable = true;
        this.touchable = true;

        if(_picture.width > _tint.width) {
            _picture.width = _tint.width;
            _picture.scaleY = _picture.scaleX;
        }
        if(_picture.height > _tint.height) {
            _picture.height = _tint.height;
            _picture.scaleX = _picture.scaleY;
        }
        _name.text = Locale.getString(_monsterID);

        isUnlocked = Model.instance.progress.unlockedLocations.indexOf(_monsterID) >= 0;
        _tint.visible = !isUnlocked;

        isTamed = Model.instance.progress.tamedMonsters.indexOf(_monsterID) >= 0;
        isBattle = Model.instance.currentPopupName == InventoryPopup.NAME; // not battle, now its inventory

        _isInstalled = false;
        var itemsInSlot : Array = Model.instance.player.inventory.getItemsInSlot("1");
        if(itemsInSlot && itemsInSlot.length > 0) {
            var monsterInSlot : Item = itemsInSlot[0];
            if(monsterInSlot.name == _monsterID) {
                _isInstalled = true;
            }
        }

        if (isTamed) _tameIcon.visible = true;

        _tame.visible = (!isBattle && isUnlocked && !isTamed) || (isBattle && isTamed); //&& isTamed || isBattle;
        _tame.text = isTamed ? (_isInstalled ? "Убрать" : "Взять") : "Приручить";


    }

    override protected function initialize():void {
        createFromConfig(_refs.guiConfig.common.tamedMonster);

        _back = _links["bitmap_common_back"];
        _back.touchable = true;

                _picture = _links["bitmap_monster_1.png"] as Image;
//        _picture.touchable = true;

        _name = _links.name_tf;
        _tint = _links["bitmap_common_disabled_tint"];


        _tameIcon = _links["bitmap_itemicon_tamed"];
        _tameIcon.visible = false;

        _tame = _links["tame_btn"];
        _tame.addEventListener(Event.TRIGGERED, onTame);


        update();
    }

    private function onTame(event : Event) : void {

        if(isBattle) {

            if(_isInstalled)
            {
                Model.instance.player.inventory.clearSlot("1");
            }
            else
            {
                var monster : MonsterVO = Model.instance.monsters.getMonster(_monsterID, 1);
                var petItem : ItemVO = ItemVO.createPetItemVO(monster, true);
//                petItem.id = 24;
                //petItem.slot = 1;
                petItem.type = "pet";
//                var itm : Item = Item.create(petItem);
                var itm : Item = Item.create(petItem);
                Model.instance.player.inventory.addItem(itm);
                coreDispatch(LocalPlayer.ITEM_SELECTED, itm);
            }
//            items[petItem.id] = petItem;


//            inventory.unshift(petItem.id.toString());


//            monster.hp = monster.hp * 0.5;
//            var pet : Pet = new Pet(monster, monster);
//
//            Model.instance.summonTimes++;
//            coreDispatch(LocalPlayer.PET_SELECTED, pet);
//            coreDispatch(UI.HIDE_POPUP, SelectMonsterPopup.NAME);

//            coreDispatch(BattleScreen.SUMMON_BUTTON_UPDATE);
            update();
        } else {
            coreDispatch(ItemView.HOVER_OUT);
            coreExecute(ShowPopupCmd, TameMonsterPopup.NAME, _monsterID);
        }

    }

    public function allowToTame($val : Boolean):void {
        _tame.visible = $val;
    }


    override public function destroy():void {
        super.destroy();

        _pet = null;
        _picture = null;
        _name = null;
    }

    public function get item() : ItemView
    {
        return _item;
    }
}
}
