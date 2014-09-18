/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.ManaList;
import com.agnither.hunters.view.ui.common.ManaView;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

public class ManaListView extends AbstractView {

    private var _manaList: ManaList;
    public function set mana(value: ManaList):void {
        _manaList = value;
        for (var i:int = 0; i < _mana.length; i++) {
            _mana[i].mana = _manaList.list.length > i ? _manaList.list[i] : null;
        }
    }

    private var _mana: Vector.<ManaView>;

    public function ManaListView() {
    }

    override protected function initialize():void {
        _mana = new <ManaView>[];

        for (var i:int = 0; i < numChildren; i++) {
            _mana.push(getChildAt(i) as ManaView);
        }
    }
}
}
