/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.drop.DropList;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

public class DropListView extends AbstractView {

    private var _dropList: DropList;

    public function DropListView(refs:CommonRefs, dropList: DropList) {
        _dropList = dropList;

        super(refs);
    }

    override protected function initialize():void {
        createFromCommon(_refs.guiConfig.common.dropList);

        var tileW: int = _links.drop2.x - _links.drop1.x;
        _links.drop1.visible = false;
        _links.drop2.visible = false;

        for (var i:int = 0; i < _dropList.list.length; i++) {
            var drop: DropSlotView = new DropSlotView(_refs, _dropList.list[i]);
            drop.x = tileW * i;
            addChild(drop);
        }
    }
}
}
