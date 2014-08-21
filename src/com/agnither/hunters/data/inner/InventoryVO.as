/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.data.inner {
import com.agnither.hunters.model.player.inventory.Armor;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.inventory.Spell;
import com.agnither.hunters.model.player.inventory.Weapon;

public class InventoryVO {

    public var weapon: Weapon;
    public var armor: Vector.<Armor> = new <Armor>[];
    public var items: Vector.<Item> = new <Item>[];
    public var spells: Vector.<Spell> = new <Spell>[];
}
}
