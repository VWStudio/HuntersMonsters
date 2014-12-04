/**
 * Created by mor on 13.11.2014.
 */
package com.agnither.hunters.model.player
{
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.player.inventory.Item;
import com.agnither.hunters.view.ui.common.AreaHud;
import com.agnither.hunters.view.ui.popups.house.HousePopup;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.hunters.view.ui.screens.map.MonsterPoint;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.core.coreRemoveListener;
import com.cemaprjl.viewmanage.ShowPopupCmd;

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.utils.Dictionary;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class Territory
{
    private var _isUnlocked : Boolean = false;

    public var rect : Rectangle;
    private var _area : MonsterAreaVO;
    private var _house : Sprite;
    private var _territoryMonsters : Vector.<MonsterPoint>;
    private var _pointsTimeout : Number = 0;
    private var _cloud : Sprite;
    private var _hud : AreaHud;
    private var _index : String;
    private var _steps : Dictionary = new Dictionary();
    public static const CAN_UNLOCK : String = "Territory.CAN_UNLOCK";
    private var _territoriesBySteps : Dictionary = new Dictionary();
    private var _isHouseOwner : Boolean = false;
    private var _houseUnlockItems : Array;
    private var _nextRandomHouseItem : Item;
    private var _houseTimeout : Number;
    public static const MOVE_CAMP : String = "Territory.MOVE_CAMP";
    private var _boss : Image;


    public function getStars() : int
    {
        return _hud.progress;
    }

    public function Territory($area : MonsterAreaVO)
    {
        _area = $area;
        _territoryMonsters = new <MonsterPoint>[];
        _index = _area.hud.substr(3, 2);


    }

    public function setCloud($val : Sprite) : void
    {
        _cloud = $val;
        rect = new Rectangle(_cloud.x, _cloud.y, _cloud.width, _cloud.height);
        _cloud.visible = !_isUnlocked;
        _cloud.touchable = false;
    }

    public function setHud($val : Sprite) : void
    {
        _hud = $val as AreaHud;
        _hud.visible = !_cloud.visible;
        _hud.isHouse = _area.isHouse;
        _hud.progress = Model.instance.progress.areaStars[area.area] ? Model.instance.progress.areaStars[area.area] : 0;

    }

    public function getPoint($radius : Number = 145) : Point
    {
        var pt : Point = Point.polar($radius, Math.random() * Math.PI * 2);
        pt.x = pt.x * 1.15;
        pt.y = pt.y * 0.60;

        return center.add(pt);
    }

    public function connect($territory : Territory, $steps : Sprite) : void
    {

        _territoriesBySteps[$steps] = $territory;
        _steps[$territory.area.id] = $steps;
        $steps.touchable = true;
        $steps.getChildAt(0).touchable = true;
        $steps.visible = false;
    }


    public function get area() : MonsterAreaVO
    {
        return _area;
    }


    private function createMonster() : void
    {

        if (_area.isHouse)
        {
            return;
        }
        if (!Model.instance.isMap())
        {
            return;
        }

        var mp : MonsterPoint = new MonsterPoint();
        mp.monsterType = Model.instance.monsters.getRandomAreaMonster(_area.area);
        _territoryMonsters.push(mp);
        coreDispatch(MapScreen.ADD_POINT, mp);

    }

    public function unlock() : void
    {
        trace("UNLOCK", _area.area);
        var territory : Territory = this;
        if (_cloud && _cloud.visible)
        {
            Starling.juggler.tween(_cloud, 1, {alpha: 0, onComplete: onEndTween});
            Model.instance.progress.unlockLocation(area.area);
            isUnlocked = true;
            function onEndTween() : void
            {
                _cloud.visible = false;
                _cloud.alpha = 1;
                _hud.visible = !_cloud.visible;
                if (_house)
                {
                    _house.visible = true;
                }
                if(_boss) {
                    _boss.visible = !isUnlocked;
                }
                if (_area.isHouse)
                {

                    coreExecute(ShowPopupCmd, HousePopup.NAME, territory);

                    Model.instance.progress.sets.push(area.area);

                    updateHouseData();
                    Model.instance.shop.updateGoods();

                    Model.instance.progress.unlockPoints += 1;
                    coreDispatch(CAN_UNLOCK);
                }

            }
        }
    }

    public function get center() : Point
    {
        return new Point(rect.x + rect.width * 0.5, rect.y + rect.height * 0.5 + 20); // + 20 is hack to move center a little bit lower
    }

//
//
    public function setHouse($house : Sprite) : void
    {
        _house = $house;
        _house.touchable = true;
        _house.getChildAt(0).touchable = true;
        _house.addEventListener(TouchEvent.TOUCH, onHouseTouch);
        updateHouseData();
    }

    private function onHouseTouch(event : TouchEvent) : void
    {
        if(!isUnlocked) return;
        var touch : Touch = event.getTouch(_house);

        if (touch)
        {
            Mouse.cursor = MouseCursor.BUTTON;
            touch = event.getTouch(_house, TouchPhase.ENDED);
            if (touch)
            {
                coreExecute(ShowPopupCmd, HousePopup.NAME, this);
            }
        }
        else
        {
            Mouse.cursor = MouseCursor.AUTO;
        }


    }

//
    public function deletePoint($pt : MonsterPoint) : void
    {

//        if(Model.instance.currentMonsterPoint != null) return;
        if (!Model.instance.isMap())
        {
            return;
        }

        var index : int = _territoryMonsters.indexOf($pt);
        if (index > -1)
        {
            _territoryMonsters.splice(index, 1);
        }
        coreDispatch(MapScreen.DELETE_POINT, $pt);

    }

    /*
     private function housesTick($delta : int) : void
     {
     var changedHouses : int = 0;
     for (var key : String in houses)
     {
     var house : Object = houses[key];
     if (house.owner == player.id && house.timeLeft > 0)
     {
     house.timeLeft -= $delta;
     changedHouses++;
     if (house.timeLeft <= 0)
     {
     house.timeLeft = 0;
     }
     coreDispatch(Model.UPDATE_HOUSE);
     }
     }

     if (changedHouses == 0)
     {
     App.instance.tick.removeTickCallback(housesTick);
     }
     }
     */

    public function tick($delta : Number) : void
    {


        if (_area.isHouse)
        {
            if(_isHouseOwner && _houseTimeout > 0) {
                _houseTimeout -= $delta;
            }
            if (_houseTimeout <= 0)
            {
                coreDispatch(Model.UPDATE_HOUSE);
            }
            return;
        }

        _pointsTimeout = _pointsTimeout < 0 ? 0 : _pointsTimeout - $delta;

        if (!Model.instance.isMap())
        {
            return;
        }

        for (var i : int = 0; i < _territoryMonsters.length; i++)
        {
            var mpt : MonsterPoint = _territoryMonsters[i];
            mpt.tick($delta);
        }

        if (_territoryMonsters.length < _area.areamax)
        {
            if (_pointsTimeout <= 0 || _territoryMonsters.length < _area.areamin)
            {
                createMonster();
                _pointsTimeout = _area.respawn * 1000;
            }
        }


    }

    public function updateStars() : void
    {
        _hud.progress = Model.instance.progress.areaStars[area.area];
//        _hud.progress = Model.instance.progress.areaStars[area.id];
    }


    private function onStepTouch(event : TouchEvent) : void
    {
        var touch : Touch = event.getTouch(event.currentTarget as DisplayObject);
        var touchEnded : Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.ENDED);
        if (touch)
        {
            Mouse.cursor = MouseCursor.BUTTON;
        }
        else
        {
            Mouse.cursor = MouseCursor.AUTO;
        }

        if (touchEnded)
        {

            var territory : Territory = _territoriesBySteps[event.currentTarget as DisplayObject];
            if (territory)
            {
//                Model.instance.progress.unlockLocation(territory.area.area);

                territory.unlock();

                coreDispatch(Territory.MOVE_CAMP, event.currentTarget as DisplayObject);

                coreDispatch(CAN_UNLOCK);
//                onUnlockReady();
            }
        }
    }


    private function onUnlockReady() : void
    {

        if (!_isUnlocked)
        {
            return;
        }
        var isHavePoints : Boolean = Model.instance.progress.unlockPoints > 0;

        for (var areaID : String in _steps)
        {
            var area : Territory = Model.instance.territories[areaID];
//            trace(areaID, area.isUnlocked);
            var step : DisplayObject = _steps[areaID];
            if (step.hasEventListener(TouchEvent.TOUCH))
            {
                step.removeEventListener(TouchEvent.TOUCH, onStepTouch);
            }

            if (!area.isUnlocked && isHavePoints)
            {
                step.visible = true;
                step.touchable = true;
                step.addEventListener(TouchEvent.TOUCH, onStepTouch);
            }
            else
            {
                step.visible = false;
            }
        }
    }

    public function handleMonsterWin($stars : int) : void
    {
        if (area.isHouse)
        {
            _hud.progress = 1;
        }
        else
        {
            _hud.progress = $stars > _hud.progress ? $stars : _hud.progress;
        }
    }

    public function get isUnlocked() : Boolean
    {
        return _isUnlocked;
    }

    public function set isUnlocked(value : Boolean) : void
    {
        _isUnlocked = value;
        var hasLockedNeighbor : Boolean = false;
        if (_isUnlocked)
        {
            for (var areaID : String in _steps)
            {
                var area : Territory = Model.instance.territories[areaID];
                if (!area.isUnlocked)
                {
                    hasLockedNeighbor = true;
                    break;
                }
            }
        }

        if (hasLockedNeighbor || _isUnlocked)
        {
            coreAddListener(CAN_UNLOCK, onUnlockReady);
        }
        else
        {
            coreRemoveListener(CAN_UNLOCK, onUnlockReady);
        }


    }

    public function updateHouseData() : void {
        _isHouseOwner = Model.instance.progress.houses.indexOf(_area.area) >= 0;
        if(!_houseUnlockItems) {
            _houseUnlockItems = [Model.instance.items.getRandomThing(), Model.instance.items.getRandomThing(), Model.instance.items.getRandomThing()];
        }
        if(!_nextRandomHouseItem) {
            generateNewHouseItem();
        }
    }

    public function generateNewHouseItem() : void
    {

        _nextRandomHouseItem = Item.create(Model.instance.items.getRandomThing());
        _houseTimeout = (Math.random() * 500) * 1000;

    }

    public function get isHouseOwner() : Boolean
    {
        return _isHouseOwner;
    }

    public function get houseTimeout() : Number
    {
        return _houseTimeout;
    }

    public function set houseTimeout(value : Number) : void
    {
        _houseTimeout = value;
    }

    public function get houseUnlockItems() : Array
    {
        return _houseUnlockItems;
    }

    public function get nextRandomHouseItem() : Item
    {
        return _nextRandomHouseItem;
    }

    public function setBoss($bossImg : Image) : void
    {
        _boss = $bossImg;
        _boss.visible = !isUnlocked;
    }
}
}
