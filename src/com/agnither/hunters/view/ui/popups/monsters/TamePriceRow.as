/**
 * Created by mor on 07.11.2014.
 */
package com.agnither.hunters.view.ui.popups.monsters {
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.modules.monsters.PriceItemVO;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.model.player.inventory.Pet;
import com.agnither.ui.AbstractView;

import starling.display.Image;
import starling.text.TextField;

public class TamePriceRow extends AbstractView {
    private var _id : Number;
    private var price : PriceItemVO;
    public var isEnough : Boolean = false;
    private var _tick : Image;
    private var _title : TextField;

    public function TamePriceRow($id : Number) {
        super();
        _id = $id;
    }


    override protected function initialize() : void {

        createFromConfig(_refs.guiConfig.common.priceRow);

        _tick = _links["bitmap_common_tick"];
        _title = _links["title_tf"];
        price = PriceItemVO.DICT[_id];
        isEnough = false;
        switch (price.type) {
            case "monster":
                //var monsters : Array = Model.instance.player.pets.getPetsByType(price.code);
                //isEnough = monsters.length >= price.amount;
                //var mon : Array = price.code.split(".");
                //_title.text = price.amount + " x " + Locale.getString(mon[0]) +" " +mon[1]+" ур.";

                var monsters : Array = Model.instance.player.inventory.getItemsByName(price.code);
                _title.text = price.amount + " " + Locale.getString(price.code);
                isEnough = monsters.length >= price.amount;
                break;
            case "money":
                _title.text = price.amount + " золота";
                isEnough = Model.instance.progress.gold >= price.amount;
                break;
            case "item":
                _title.text = price.amount + " " + price.code;
                var items : Array = Model.instance.player.inventory.getItemsByName(price.code);
                isEnough = items.length >= price.amount;
                break;
        }

        _tick.visible = isEnough;


    }


    public function pay() : void {
        switch (price.type) {
            case "monster":
                //removePets();
                removeItems();
                break;
            case "money":
                Model.instance.progress.gold -= price.amount;
                break;
            case "item":
                removeItems();
                break;

        }
    }

    private function removeItems() : void {

        var items : Array = Model.instance.player.inventory.getItemsByName(price.code);
        var removed  : int = 0;
        for (var i : int = items.length - 1; i >= 0; i--)
        {
            var item : Item = items[i];

            Model.instance.player.inventory.removeItem(item);
            removed++;

            if(removed == price.amount) {
                break;
            }
        }


//        _title.text = price.amount + " " + price.code;
//        var items : Array = Model.instance.player.inventory.getItemsByName(price.code);
//        isEnough = items.length >= price.amount;
    }

    private function removePets() : void {

        var pets : Vector.<Pet> = Model.instance.player.pets.petsList;
        var removed : int = 0;
        for (var i : int = pets.length-1; i >= 0; i--)
        {
            var pet : Pet = pets[i];
            if(pet.id + "." + pet.level == price.code) {
                Model.instance.player.pets.removePet(pet);
                removed++;
            }
            if(removed == price.amount) {
                break;
            }
        }
    }
}
}
