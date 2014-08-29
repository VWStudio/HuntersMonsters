/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.drop.DropList;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

public class DropListView extends AbstractView {

    private var _dropList: DropList;
    public function set drop(value: DropList):void {
        _dropList = value;
        for (var i:int = 0; i < _dropList.list.length; i++) {
            _drop[i].drop = _dropList.list[i];
        }
    }

    private var _drop: Vector.<DropSlotView>;

    public function DropListView(refs:CommonRefs) {
        super(refs);
    }

    override protected function initialize():void {
        _drop = new <DropSlotView>[];

        for (var i:int = 0; i < numChildren; i++) {
            _drop.push(getChildAt(i) as DropSlotView);
        }
    }
}
}
