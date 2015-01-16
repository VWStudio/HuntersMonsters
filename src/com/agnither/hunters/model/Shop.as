/**
 * Created by mor on 09.11.2014.
 */
package com.agnither.hunters.model
{
import com.agnither.hunters.model.modules.items.ItemVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.modules.players.SettingsVO;
import com.agnither.hunters.model.player.inventory.Item;

import flash.utils.Dictionary;

public class Shop
{
    private var _itemsDict : Object;
    public static const DELIVER_TIME : String = "Shop.DELIVER_TIME";
    public static const NEW_DELIVER : String = "Shop.NEW_DELIVER";
    private var _creationRequired : Boolean = true;

    public function Shop()
    {

        _itemsDict = {};
        _creationRequired = Model.instance.progress.shopTimer <= 0;
        trace(_creationRequired, "Model.instance.progress.shopTimer", Model.instance.progress.shopTimer);
        if(Model.instance.progress.shopItems && Model.instance.progress.shopTimer > 0)
        {
            parse(Model.instance.progress.shopItems);
        }


    }

    public function parse($data : Object) : void
    {

        trace("--------------------- shop parse -----------------------");
        trace(JSON.stringify($data));


        for (var key : String in $data)
        {
            _itemsDict[key] = [];
            var itmsSource : Array = $data[key];
            for (var i : int = 0; i < itmsSource.length; i++)
            {
                var itemData : Object = itmsSource[i];
                var itemVO : ItemVO;
                if(itemData is ItemVO) {
                    itemVO = itemData as ItemVO;
                }
                else
                {
                    itemVO = Model.instance.items.getItemVO(itemData.name);
                    if (itemData.ext)
                    {
                        itemVO.ext = itemData.ext;
                    }
                    var newItem : Item = Item.create(itemVO);
                    newItem.uniqueId = itemData.uniqueId;
                    _itemsDict[key].push(newItem);
                }
            }
        }
    }

    public function getItemsByType($type : String) : Array
    {
        if (!_itemsDict[$type])
        {
            _itemsDict[$type] = generateItems($type);
        }
        return _itemsDict[$type];

    }

    private function generateItems($type : String) : Array
    {

        var createdItems : Array = [];
        var itemsMin : int = SettingsVO.DICT[$type + "TabMin"];
        var itemsMax : int = SettingsVO.DICT[$type + "TabMax"];
        var arr : Array = [];
        var amount : int = itemsMin + int((itemsMax - itemsMin + 1) * Math.random());
        var amountCrystal : int = 2; // XXX min of crystall items
        var i : int = 0;
        var item : Item;
        var itemVO : ItemVO;
        if (amount == 0)
        {

        }
        else
        {
            for (i = 0; i < amount; i++)
            {
                item = Model.instance.items.generateRandomItem($type);
                if (item)
                {
                    var itmString : String = item.toString();
                    if (item.isSpell())
                    {
                        if(!Model.instance.player.inventory.isHaveSpell(item.id) && createdItems.indexOf(itmString) == -1) {
                            createdItems.push(itmString);
                            arr.push(item);
                        }
                    }
                    else
                    {
                        if(createdItems.indexOf(itmString) == -1) {
                            createdItems.push(itmString);
                            arr.push(item);
                        }
                    }
                }
            }

        }

        return arr;

    }

    public function updateGoods() : void
    {
        if (!_itemsDict)
        {
            _itemsDict = {};
        }
        else
        {
            for (var key : String in _itemsDict)
            {
                _itemsDict[key] = null;
                delete _itemsDict[key];
            }
        }
        _creationRequired = true;
    }


    public function removeItem($item : Item) : void
    {

        trace(JSON.stringify(_itemsDict[ItemVO.TYPE_WEAPON]));

        var arr : Array = _itemsDict[$item.type];
        var index : int = arr.indexOf($item);
        arr.splice(index, 1);

        trace(JSON.stringify(_itemsDict[ItemVO.TYPE_WEAPON]));

        Model.instance.progress.shopItems = JSON.parse(JSON.stringify(_itemsDict));
        Model.instance.progress.saveProgress();

    }


    public function getShopItems() : Array
    {
        var arr : Array = [ItemVO.TYPE_WEAPON, ItemVO.TYPE_ARMOR, ItemVO.TYPE_MAGIC, ItemVO.TYPE_SPELL];
        var i : int;
        trace("get chop items, recreate", _creationRequired);
        if(_creationRequired) // если итемы не созданы
        {
            var items : Array = [];
            for (i = 0; i < arr.length; i++)
            {
                _itemsDict[arr[i]] = null; // чистим
                var arrByType : Array = getItemsByType(arr[i]);   // генерируем по типу
                items = items.concat(arrByType); // склеиваем
            }
            trace("generated------------");
            var crystallItems : Array = [];
            for (i = 0; i < items.length; i++)
            {
                var item : Item = items[i];
                if(item.crystallPrice > 0) {
                    crystallItems.push(item);
                }
            }

            var cMin : int = SettingsVO.DICT["shopCrystallItems"][0];
            var cMax : int = SettingsVO.DICT["shopCrystallItems"][1];
            trace("crystallFound------------", crystallItems.length, "range:", cMin, cMax);


            if(crystallItems.length > cMax) {
                trace("delete items------------");
                // удаляем лишние элементы
                while(crystallItems.length > cMax) {
                    var index : int = int(Math.random() * crystallItems.length);
                    var item1 : Item = crystallItems.splice(index, 1)[0]; // из тех что нашли
                    items.splice(items.indexOf(item1), 1); // из массива для вывода
                    arrByType = getItemsByType(arr[i]); // из массива для сохранения
                    arrByType.splice(arrByType.indexOf(item1), 1)
                }
            } else if(crystallItems.length < cMin) {
                // добавляем недостающие
                var counter : int = 0;
                var cm : int = cMin + Math.round((cMax - cMin) * Math.random());
                trace("create items------------", cm);
                while(crystallItems.length < cm && counter < cm * 100) {
                    var randType : String = ([ItemVO.TYPE_WEAPON, ItemVO.TYPE_ARMOR, ItemVO.TYPE_MAGIC] as Array)[int(Math.random() * 3)];
                    var item2 : Item = Model.instance.items.generateRandomItem(randType);
                    if(item2 && item2.crystallPrice > 0) {
                        crystallItems.push(item2); // добавляем в найденые
                        items.push(item2) // добавляем в итоговый массив
                        arrByType = getItemsByType(arr[i]); // в массив для сохранения
                        arrByType.push(item2);
                    }
                    counter++;
                }
            }

            _creationRequired = false;
            Model.instance.progress.shopItems = JSON.parse(JSON.stringify(_itemsDict));
            Model.instance.progress.saveProgress();
        }

        items = [];
        for (i = 0; i < arr.length; i++)
        {
            var arrByType : Array = getItemsByType(arr[i]);
            items = items.concat(arrByType);
        }


        return items;
    }
}
}
