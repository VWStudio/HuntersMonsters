/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.Spell;
import com.agnither.hunters.model.player.SpellsList;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

public class SpellsListView extends AbstractView {

    private static var tileHeight: int;

    private var _spellsList: SpellsList;

    public function SpellsListView(refs:CommonRefs, spellsList: SpellsList) {
        _spellsList = spellsList;

        super(refs);
    }

    override protected function initialize():void {
        createFromCommon(_refs.guiConfig.common.spellsList);

        tileHeight = _links.slot2.y - _links.slot1.y;
        _links.slot1.visible = false;
        _links.slot2.visible = false;

        var l: int = _spellsList.list.length;
        for (var i:int = 0; i < l; i++) {
            var spell: Spell = _spellsList.list[i];
            var spellView: SpellView = new SpellView(_refs, spell);
            spellView.y = i * tileHeight;
            addChild(spellView);
        }
    }
}
}
