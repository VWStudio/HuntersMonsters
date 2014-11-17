/**
 * Created by mor on 13.11.2014.
 */
package com.agnither.hunters.model.player
{
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.player.personage.Progress;
import com.agnither.hunters.view.ui.common.MonsterArea;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.hunters.view.ui.screens.map.MonsterPoint;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;

import flash.geom.Point;

import flash.geom.Rectangle;
import flash.utils.Dictionary;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class Territory
{
    public var rect : Rectangle;
    private var _area : MonsterAreaVO;
    private var _clouds : Sprite;
    private var _house : Sprite;
    private var _territoryMonsters : Vector.<MonsterPoint>;
    private var _pointsTimeout : Number = 0;
    private var _cloud : Sprite;
    private var _hud : Sprite;
    private var _index : String;
    private var _steps : Dictionary = new Dictionary();
    public var isUnlocked : Boolean = false;
    public static const CAN_UNLOCK : String = "Territory.CAN_UNLOCK";
    public function Territory($area : MonsterAreaVO)
    {
        _area = $area;
        _territoryMonsters  = new <MonsterPoint>[];
        _index = _area.hud.substr(3,2);

        coreAddListener(CAN_UNLOCK, onUnlockReady);
    }

    private function onUnlockReady() : void
    {

        if(!isUnlocked) return;
        trace("TERRITORY UNLOCK", Model.instance.progress.unlockPoints);
        var isHavePoints : Boolean = Model.instance.progress.unlockPoints > 0;
        for (var areaID : String in _steps)
        {
            var area : Territory = Model.instance.territories[areaID];
            trace(areaID, area.isUnlocked);
            if(!area.isUnlocked && isHavePoints) {
                var step : DisplayObject = _steps[areaID];
                step.visible = true;
                step.touchable = true;
                step.addEventListener(TouchEvent.TOUCH, onStepTouch);
            }
        }



    }

    private function onStepTouch(event : TouchEvent) : void
    {
        var touch : Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.ENDED);
        if(touch) {
            trace(event.currentTarget as DisplayObject);
        } else {
            trace("NO TOUCH");
        }
    }

    public function get area() : MonsterAreaVO
    {
        return _area;
    }

//    public function updatePoints():void {

//        _territoryTimeout  = _area.respawn * 1000;
//        if(_territoryPoints.length < _area.area_min) {
//            var monstersAmount : int = (_area.area_min + (_area.area_max - _area.area_min + 1) * Math.random()) - _territoryPoints.length;
//            for (var i : int = 0; i < monstersAmount; i++)
//            {
//                createPoint();
//            }
//        }


//    }
//
    private function createMonster() : void {

        if(_area.isHouse) return;
        if(!Model.instance.isMap()) return;

        var mp : MonsterPoint = new MonsterPoint();
        mp.monsterType = Model.instance.monsters.getRandomAreaMonster(_area.area);
        _territoryMonsters.push(mp);
        coreDispatch(MapScreen.ADD_POINT, mp);

    }

//    public function unlock():void {
//        if(_clouds && _clouds.visible) {
//            Starling.juggler.tween(_clouds, 1, {alpha : 0, onComplete: onEndTween});
//
//            function onEndTween():void {
//                _clouds.visible = false ;
//                _clouds.alpha = 1;
//                if(_house) {
//                    _house.visible = true;
//                }
//            }
//        }
//    }

    public function get center(): Point {
        return new Point(rect.x + rect.width * 0.5, rect.y + rect.height * 0.5 + 20); // + 20 is hack to move center a little bit lower
    }
//
//
//    public function setHouse($house : Sprite) : void
//    {
//        _house = $house;
//        _house.visible = false;
//
//    }
//
    public function deletePoint($pt : MonsterPoint) : void
    {

//        if(Model.instance.currentMonsterPoint != null) return;
        if(!Model.instance.isMap()) return;

        var index : int = _territoryMonsters.indexOf($pt);
        if(index > -1) {
            _territoryMonsters.splice(index, 1);
        }
        coreDispatch(MapScreen.DELETE_POINT, $pt);

    }

    public function tick($delta : Number) : void
    {

        if(_area.isHouse) return;

        if(_territoryMonsters.length < _area.areamax) {
            _pointsTimeout = _pointsTimeout < 0 ? 0 : _pointsTimeout - $delta;

            if(!Model.instance.isMap()) return;

            if(_territoryMonsters.length > 0) {
                _territoryMonsters.forEach(tickPoint);
                function tickPoint($item:MonsterPoint, $index:int, $vector:Vector.<MonsterPoint>):void {
                    $item.tick($delta);
                }
            }

            if(_pointsTimeout <= 0 || _territoryMonsters.length < _area.areamin) {
                createMonster();
                _pointsTimeout = _area.respawn * 1000;
            }

        }


    }
    public function setCloud($val : Sprite) : void
    {
        _cloud = $val;
        rect = new Rectangle(_cloud.x, _cloud.y , _cloud.width, _cloud.height);
        _cloud.visible = !isUnlocked;
    }

    public function setHud($val : Sprite) : void
    {
        _hud = $val;
        _hud.visible = !_cloud.visible;

    }

    public function getPoint($radius : Number = 145):Point {
        var pt : Point = Point.polar($radius, Math.random() * Math.PI * 2);
        pt.x = pt.x * 1.15;
        pt.y = pt.y * 0.60;

        return center.add(pt);
    }

    public function connect($territory : Territory, $steps : DisplayObject) : void
    {
        _steps[$territory.area.id] = $steps;
        $steps.visible = false;
    }
}
}
