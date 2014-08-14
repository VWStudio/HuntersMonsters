/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.Mana;
import com.agnither.hunters.model.player.ManaList;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class ManaListView extends AbstractView {

    private var _manaList: ManaList;

    private var _mana1: TextField;
    private var _mana2: TextField;
    private var _mana3: TextField;
    private var _mana4: TextField;

    public function ManaListView(refs:CommonRefs, manaList: ManaList) {
        _manaList = manaList;

        super(refs);
    }

    override protected function initialize():void {
        createFromCommon(_refs.guiConfig.common.manaList);

        _mana1 = _links.value1_tf;
        _mana2 = _links.value2_tf;
        _mana3 = _links.value3_tf;
        _mana4 = _links.value4_tf;

        var l: int = _manaList.list.length;
        for (var i:int = 0; i < l; i++) {
            var mana: Mana = _manaList.list[i];
            var icon: Image = _links["icon"+(i+1)].getChildAt(0);
            icon.texture = _refs.gui.getTexture(mana.icon);
            mana.addEventListener(Mana.UPDATE, handleUpdate);
        }
        handleUpdate();
    }

    private function handleUpdate(e: Event = null):void {
        var l: int = _manaList.list.length;
        for (var i:int = 0; i < l; i++) {
            var mana: Mana = _manaList.list[i];
            var tf: TextField = this["_mana"+(i+1)];
            tf.text = String(mana.value);
        }
    }
}
}
