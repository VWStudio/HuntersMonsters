/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.popups.hunt {
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.view.ui.UI;
import com.agnither.hunters.view.ui.common.MonsterInfo;
import com.agnither.ui.ButtonContainer;
import com.agnither.ui.Popup;
import com.cemaprjl.core.coreDispatch;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class HuntPopup extends Popup {

    public static const NAME : String = "HuntPopup.NAME";

//    public static const SELECT_MONSTER: String = "select_monster_BattleScreen";

    private var _back : Image;
    private var _playButton : ButtonContainer;
    private var _monster : MonsterInfo;
    private var _closeButton : ButtonContainer;
    private var _stars3 : TextField;
    private var _stars2 : TextField;
    private var _stars1 : TextField;

    public function HuntPopup() {

        super();
    }

    override protected function initialize() : void {

        createFromConfig(_refs.guiConfig.hunt_popup);


        _back = _links["bitmap_common_back"];
        _closeButton = _links["close_btn"];
        _closeButton.addEventListener(Event.TRIGGERED, handleClose);


        _playButton = _links["play_btn"];
        _playButton.addEventListener(Event.TRIGGERED, handlePlay);
        _playButton.text = "Охотиться";

        _stars3 = _links["stars3_tf"];
        _stars2 = _links["stars2_tf"];
        _stars1 = _links["stars1_tf"];

        _stars1.visible = false;
        _stars2.visible = false;
        _stars3.visible = false;

        _monster = _links.monster;


    }

    override protected function handleClose(event : Event) : void {
        Model.instance.currentMonsterPoint = null;
        coreDispatch(UI.HIDE_POPUP, NAME);
    }

    private function handlePlay(event : Event) : void {

        Model.instance.match3mode = Match3Game.MODE_REGULAR; //
//        Model.instance.currentMonsterPoint.count(false);
        coreDispatch(UI.HIDE_POPUP, NAME);
        coreDispatch(Match3Game.START_GAME, data);
    }


    override public function update() : void {

        _monster.data = data;
        _monster.update();
        _stars3.text = _monster.monster.stars[0];
        _stars2.text = _monster.monster.stars[1];
        _stars1.text = _monster.monster.stars[2];


    }


}
}
