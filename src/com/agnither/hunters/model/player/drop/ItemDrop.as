/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.drop
{
import com.agnither.hunters.model.player.inventory.Item;
import com.cemaprjl.utils.Util;

public class ItemDrop extends Drop
{

    private var _item : Item;
    public function get item() : Item
    {
        return _item;
    }

    override public function get icon() : String
    {
        return _item.icon;
    }

    public function ItemDrop(item : Item)
    {
        _item = item;
        _item.uniqueId = Util.uniq(item.name);
    }

    override public function stack(drop : Drop) : Boolean
    {
        return false;
    }
}
}
