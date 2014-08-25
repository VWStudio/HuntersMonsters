/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.screens.battle.player {
import com.agnither.hunters.model.player.inventory.Inventory;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

public class InventoryView extends AbstractView {

    private static var tileHeight: int;

    private var _inventory: Inventory;

    public function InventoryView(refs:CommonRefs, inventory: Inventory) {
        _inventory = inventory;

        super(refs);
    }

    override protected function initialize():void {
        createFromCommon(_refs.guiConfig.common.spellsList);

        tileHeight = _links.slot2.y - _links.slot1.y;
        _links.slot1.visible = false;
        _links.slot2.visible = false;

        var l: int = _inventory.inventoryItems.length;
        for (var i:int = 0; i < l; i++) {
            var item: Item = _inventory.getItem(_inventory.inventoryItems[i]);
            var itemView: ItemView = ItemView.getItemView(_refs, item);
            itemView.y = i * tileHeight;
            addChild(itemView);
        }
    }
}
}
