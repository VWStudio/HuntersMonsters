/**
 * Created by agnither on 15.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.data.outer.ExtensionVO;
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.player.personage.Personage;

public class Spell extends Item {

    public function Spell(item: ItemVO) {
        super(item);
    }

//    public function get mana():Object {
//        return _item.extension_drop;
//    }

}
}
