/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player.inventory {
import com.agnither.hunters.data.outer.ExtensionVO;
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.model.player.Mana;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.utils.CommonRefs;

public class SpellView extends ItemView {

    public function SpellView(item: Item) {
        super(item);
    }

    override protected function initialize():void {
        super.initialize();

        var i: int = 0;
        var mana: Object = item.extension_drop;
        for (var key: * in mana) {
            var manaType: DamageTypeVO = DamageTypeVO.DICT[key];
            var manaObj: Mana = new Mana(manaType.name);
            manaObj.addMana(mana[key]);
            _mana[i++].mana = manaObj;
        }

        _damage.text = String(item.extension[ExtensionVO.damage]);
    }
}
}
