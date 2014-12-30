/**
 * Created by agnither on 25.08.14.
 */
package com.agnither.hunters.view.ui.popups.monsters {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.TrapVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.inventory.PetsInventory;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.common.TabView;
import com.agnither.hunters.view.ui.popups.monsters.CatchedPetsView___not_used;
import com.agnither.hunters.view.ui.popups.traps.TrapItem;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Popup;
import com.agnither.utils.CommonRefs;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.viewmanage.ShowPopupCmd;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class TameMonsterPopup extends Popup {

    public static const NAME : String = "com.agnither.hunters.view.ui.popups.monsters.TameMonsterPopup";
    private var _title : TextField;
    private var _monster_tf : TextField;
    private var _tame : ButtonContainer;
    private var _container : Sprite;
    private var _monsterID : String;
    private var _monsterArea : MonsterAreaVO;
    private var _monster : MonsterVO;
    private var _isEnough : Boolean = false;

    public function TameMonsterPopup() {
    }

    override protected function initialize():void {
        createFromConfig(_refs.guiConfig.tame_monster);

        _title = _links.titlle_tf;
        _monster_tf = _links.monster_tf;

        _tame = _links.mode_btn;
        _tame.text = "Приручить";
        _tame.addEventListener(Event.TRIGGERED, onTame);

        _container = new Sprite();
        addChild(_container);
        _container.x = _links.price.x;
        _container.y = _links.price.y;

        removeChild(_links.price);
        delete _links.price;

        handleCloseButton(_links.close_btn);
    }


    override protected function handleClose(e : Event) : void {
        super.handleClose(e);

        coreExecute(ShowPopupCmd, SelectMonsterPopup.NAME);
    }

    private function onTame(event : Event) : void {



        for (var i : int = 0; i < _container.numChildren; i++)
        {
            var tameRow : TamePriceRow = _container.getChildAt(i) as TamePriceRow;
            tameRow.pay();
        }


        Model.instance.progress.tamedMonsters.push(_monsterID);
        Model.instance.progress.saveProgress();

        coreExecute(ShowPopupCmd, SelectMonsterPopup.NAME);


    }


    override public function update() : void {

        _monsterID = data.toString();
        _title.text = "Приручить монстра";
        _monster_tf.text = Locale.getString(_monsterID);

        _monsterArea = MonsterAreaVO.DICT[_monsterID];
        _monster = Model.instance.monsters.getMonster(_monsterID, 1);

        _container.removeChildren();
        _isEnough = true;
        for (var i : int = 0; i < _monsterArea.tameprice.length; i++)
        {
            var o : Number = _monsterArea.tameprice[i];
            var priceItem : TamePriceRow = new TamePriceRow(o);
            _container.addChild(priceItem);
            priceItem.y = i * 60;
            _isEnough = _isEnough && priceItem.isEnough;
        }

        _tame.visible = _isEnough;


//        _tab1.dispatchEventWith(TabView.TAB_CLICK);

//        _monsters.showType(PetsInventory.TAMED);










    }



}
}
