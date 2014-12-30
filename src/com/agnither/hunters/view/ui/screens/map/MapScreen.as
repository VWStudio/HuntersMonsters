/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.map {
import com.agnither.hunters.App;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.Territory;
import com.agnither.hunters.model.player.personage.Progress;
import com.agnither.hunters.view.ui.common.MonsterArea;
import com.agnither.hunters.view.ui.popups.traps.TrapSetPopup;
import com.agnither.hunters.view.ui.screens.camp.CampScreen;
import com.agnither.ui.Screen;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.viewmanage.ShowPopupCmd;
import com.cemaprjl.viewmanage.ShowScreenCmd;

import flash.display.PNGEncoderOptions;

import flash.geom.Point;

import flash.geom.Point;

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
import starling.events.TouchPhase;

public class MapScreen extends Screen {

    public static const NAME : String = "MapScreen";

//    public static const SELECT_MONSTER: String = "select_monster_BattleScreen";

    private var _back : Image;
    private var _container : Sprite;
    private var _maxY : Number = -100;
    private var _maxX : Number = -100;
    private var _allowMove : Boolean = false;
    private var _startPoint : Point;
    private var _startPos : Point;
    private var _points : Dictionary = new Dictionary();
//    private var _playerPositions : Dictionary = new Dictionary();
//    private var _clouds : Dictionary = new Dictionary();
    public static const INIT_MONSTER : String = "MapScreen.INIT_MONSTER";
    private var _monstersContainer : Sprite;
//    private var _playerPositionsArr : Vector.<Point>;
    private var _playerPosition : PlayerPoint;
//    public static const START_TRAP : String = "MapScreen.START_TRAP";
//    public static const STOP_TRAP : String = "MapScreen.STOP_TRAP";
//    public static const ADD_TRAP : String = "MapScreen.ADD_TRAP";
//    public static const DELETE_TRAP : String = "MapScreen.DELETE_TRAP";
    public static const ADD_POINT : String = "MapScreen.ADD_POINT";
    public static const DELETE_POINT : String = "MapScreen.DELETE_POINT";
//    private var _trapsContainer : Sprite;
    public static const ADD_CHEST : String = "MapScreen.ADD_CHEST";
    public static const REMOVE_CHEST : String = "MapScreen.REMOVE_CHEST";
    private var _chestsContainer : Sprite;
    private var _houses : Object = {};
    private var _houseContainer : Sprite;
    private var isFirstRun : Boolean = true;
    private var _camp : Sprite;

    public function MapScreen() {

        super();

    }

    override protected function initialize() : void {

        _container = new Sprite();
        addChild(_container);
        _container.touchable = true;
        this.touchable = true;

        createFromConfig(_refs.guiConfig.map, _container);

        coreAddListener(Progress.UPDATED, update);
        coreAddListener(ADD_POINT, onPointAdd);
        coreAddListener(DELETE_POINT, onPointDelete);
//        coreAddListener(ADD_TRAP, onTrapAdd);
//        coreAddListener(DELETE_TRAP, onTrapDelete);
        coreAddListener(ADD_CHEST, onChestAdd);
        coreAddListener(REMOVE_CHEST, onChestRemove);
        //coreDispatch(Territory.MOVE_CAMP, event.currentTarget as DisplayObject);
        coreAddListener(Territory.MOVE_CAMP, onMoveCamp);

        _back = _links["bitmap_map_background"];
        _back.touchable = true;


        var i : int = 0;
        var territory : Territory;
        for (i = 0; i < MonsterAreaVO.LIST.length; i++)
        {
            territory = Model.instance.territories[MonsterAreaVO.LIST[i].id];
            territory.setCloud(_links[territory.area.id]);
            territory.setHud(_links[territory.area.hud]);
            if(territory.area.isHouse) {
                territory.setHouse(_links[territory.area.area]);
            }
        }

        if(territory) {
            territory.setBoss(_links["bitmap_boss"]);
        }


        for ( i = 0; i < _container.numChildren; i++)
        {
            var dobj : DisplayObject = _container.getChildAt(i);
            if(dobj.name && dobj.name.indexOf("step_") >= 0)
            {
                var arr : Array = dobj.name.split("_");
                var territory1 : Territory = Model.instance.territories["clouds_"+arr[1]];
                var territory2 : Territory = Model.instance.territories["clouds_"+arr[2]];
                territory1.connect(territory2, dobj as Sprite);
                territory2.connect(territory1, dobj as Sprite);
            }
        }

        if(Model.instance.progress.unlockPoints > 0) {
            coreDispatch(Territory.CAN_UNLOCK);
        }

        _camp = _links["camp"];
        _camp.getChildAt(0).touchable = true;
        _camp.touchable = true;
        _camp.addEventListener(TouchEvent.TOUCH, onTouchCamp);

        if(Model.instance.progress.campPosition) {
            _camp.x = Model.instance.progress.campPosition.x;
            _camp.y = Model.instance.progress.campPosition.y;
        } else {
            Model.instance.progress.campPosition = {
                x: _camp.x,
                y: _camp.y
            }
            Model.instance.progress.saveProgress();
        }


        _monstersContainer = new Sprite();
        _monstersContainer.name = "monsters_container"; // hack
        _container.addChildAt(_monstersContainer, _container.getChildIndex(_camp) + 1);

//        _trapsContainer = new Sprite();
//        _trapsContainer.name = "traps_container"; // hack
//        _container.addChildAt(_trapsContainer, _container.getChildIndex(_monstersContainer) + 1);

        _chestsContainer = new Sprite();
        _chestsContainer.name = "chests_container"; // hack
        _container.addChildAt(_chestsContainer, _container.getChildIndex(_monstersContainer) + 1);
//        _container.addChildAt(_chestsContainer, _container.getChildIndex(_trapsContainer) + 1);

        var centerPoint : Point = new Point(stage.stageWidth * 0.5, stage.stageHeight * 0.5);
        var campPoint : Point = new Point(_camp.x, _camp.y);
        var mapDelta : Point = centerPoint.subtract(campPoint);

//        _container.x = (stage.stageWidth - _back.width) * 0.5;
//        _container.y = (stage.stageHeight - _back.height) * 0.5;

        _maxX = stage.stageWidth - _back.width;
        _maxY = stage.stageHeight - _back.height;

        mapDelta.x = Math.min(0, mapDelta.x);
        mapDelta.x = Math.max(_maxX, mapDelta.x);

        mapDelta.y = Math.min(0, mapDelta.y);
        mapDelta.y = Math.max(_maxY, mapDelta.y);

        _container.x = mapDelta.x;
        _container.y = mapDelta.y;

        _container.addEventListener(TouchEvent.TOUCH, handleTouch);

    }

    private function onMoveCamp($target : DisplayObject) : void
    {
        var currentPoint : Point = new Point(_camp.x, _camp.y);
        var targetPoint : Point = new Point($target.x, $target.y);
        var deltaPoint : Point = targetPoint.subtract(currentPoint);

        Model.instance.progress.campPosition = {x:targetPoint.x, y:targetPoint.y};
        Model.instance.progress.saveProgress();

        Starling.juggler.tween(_camp, deltaPoint.length / 100, {x : targetPoint.x, y : targetPoint.y})
    }

    private function onPointDelete($pt : MonsterPoint) : void {

        if(_monstersContainer.contains($pt)) {
            _monstersContainer.removeChild($pt);
            $pt.destroy();
        }

    }

    private function onPointAdd($pt : MonsterPoint) : void {

        _monstersContainer.addChild($pt);
        $pt.update();

    }

    private function onChestRemove($chest : ChestPoint) : void {

        if(_chestsContainer.contains($chest)) {
            _chestsContainer.removeChild($chest);
            App.instance.chest = null;
            App.instance.chestStep = -1;
            for (var key : String in Model.instance.chestAreas)
            {
                if(Model.instance.chestAreas[key] == $chest) {

                    delete  Model.instance.chestAreas[key];
                    break;
                }
            }
        }


    }

    private function onChestAdd() : void {

        if(_chestsContainer.numChildren >= Model.instance.progress.unlockedLocations.length) {
            return;
        }


        var chestAreas : Array = [];
        var territory : Territory;
        for (var i : int = 0; i < Model.instance.progress.unlockedLocations.length; i++)
        {
            var locID : String = Model.instance.progress.unlockedLocations[i];
            territory = Model.instance.territories[locID];
            if(!Model.instance.chestAreas[locID] && territory.area.chestlife > 0) {
//                if(!territory.area.isHouse) {
                    chestAreas.push(locID);
//                }
            }

        }

        if(!chestAreas.length) {
            return;
        }

        var territoryId  : String  = chestAreas[int(Math.random() * chestAreas.length)];
        territory = Model.instance.territories[territoryId];
        var pt : Point = territory.getPoint();

        var chest : ChestPoint = new ChestPoint();
        _chestsContainer.addChild(chest);
        chest.data = territory;
        chest.update();

        chest.x = pt.x;
        chest.y = pt.y;

        Model.instance.chestAreas[territoryId] = chest;

    }

//    private function onTrapDelete($trap : TrapPoint) : void {
//
//        return;
//
//        if(_trapsContainer.contains($trap)) {
//            _trapsContainer.removeChild($trap);
//        }
//        delete  Model.instance.territoryTraps[$trap.monsterType.id];
//        $trap.destroy();
//
//    }
//
//    private function onTrapAdd($data : Object) : void {
//
//        return;
//
//        var trapPoint : TrapPoint = new TrapPoint();
//        _trapsContainer.addChild(trapPoint);
//        trapPoint.data = $data;
//        trapPoint.update();
//
//        var position : Point = $data.position;
//
//        trapPoint.x = position.x;
//        trapPoint.y = position.y;
//
//        Model.instance.territoryTraps[$data.id] = trapPoint;
//    }



    override public function update() : void {



//        var arr : Array = Model.instance.progress.unlockedLocations;
//
//        var i : int = 0;
//        var monsterID : String; // = Model.instance.progress.unlockedLocations[Model.instance.progress.unlockedLocations.length - 1];
//        for (i = 0; i < arr.length; i++)
//        {

//            monsterID = arr[i];
//            Model.instance.territories[monsterID].unlock();
//            Model.instance.territories[monsterID].updatePoints();

//            monsterID = arr[i];
//            var area  : MonsterAreaVO = Model.instance.monsters.getMonsterArea(monsterID);
//            if(_clouds[area.area]) {
//                if(_clouds[area.area].visible) {
//                    openTerritoryTween(_clouds[area.area]);
//                } else {
//                    _clouds[area.area].visible = false;
//                }
//
//
//
//            }

//            if(area.house && _houses[area.house])  {
//                _houses[area.house].visible = true;
//            }
//        }

//        var centerPt : Point = Model.instance.territories[monsterID].center;
//        _playerPosition.x = centerPt.x;
//        _playerPosition.y = centerPt.y;

//        Model.instance.updatePoints();


    }

//    private function openTerritoryTween($cloud : DisplayObject) : void {
//
//        Starling.juggler.tween($cloud, 1, {alpha : 0, onComplete: onEndTween});
//
//        function onEndTween():void {
//            $cloud.visible = false ;
//            $cloud.alpha = 1;
//        }
//
//    }



    private function sortPlayers($a : PlayerPoint, $b : PlayerPoint) : Number {
        if($a.name < $b.name) return -1;
        if($a.name > $b.name) return 1;
        return 0;
    }

    private function handleTouch(e : TouchEvent) : void {
        var touch : Touch = e.getTouch(_container);
        if (touch)
        {
            switch (touch.phase)
            {
                case TouchPhase.BEGAN:
                    Model.instance.screenMoved = false;
                    _startPoint = new Point(touch.globalX, touch.globalY);
                    _startPos = new Point(_container.x, _container.y);

                    var pt : Point = _container.globalToLocal(_startPoint);
                    var trapAllowed : Boolean = false;
                    if(App.instance.trapMode) {
                        for (var i : int = 0; i < Model.instance.progress.unlockedLocations.length; i++)
                        {
                            var key : String = Model.instance.progress.unlockedLocations[i];
                            var rect : Rectangle = Model.instance.territories[key];
//                            if(rect.containsPoint(pt) && Model.instance.territoryTraps[key] == null) {
//                                trapAllowed = true;
//                                break;
//                            }
                        }
//                        if(trapAllowed) {
//                            coreExecute(ShowPopupCmd, TrapSetPopup.NAME, {id : key, position : pt, mode:TrapSetPopup.SET_MODE});
//                            coreDispatch(MapScreen.STOP_TRAP);
//                            return;
//                        } else {
//                            coreDispatch(MapScreen.STOP_TRAP);
//                        }
                    }
                    _allowMove = true;
                    break;
                case TouchPhase.MOVED:
                    if (_allowMove)
                    {
                        var deltaPt : Point = _startPos.subtract(_startPoint.subtract(new Point(touch.globalX, touch.globalY)));
                        if (deltaPt.x > 0)
                        {
                            deltaPt.x = 0;
                        }
                        if (deltaPt.y > 0)
                        {
                            deltaPt.y = 0;
                        }
                        if (deltaPt.x < _maxX)
                        {
                            deltaPt.x = _maxX;
                        }
                        if (deltaPt.y < _maxY)
                        {
                            deltaPt.y = _maxY;
                        }
                        _container.x = deltaPt.x;
                        _container.y = deltaPt.y;
                        _startPoint = new Point(touch.globalX, touch.globalY);
                        _startPos = new Point(_container.x, _container.y);
                        Model.instance.screenMoved = true;
                    }
                    break;
                case TouchPhase.ENDED:
                    Model.instance.screenMoved = false;
                    _allowMove = false;
                    break;
            }
        }
    }

    private function onTouchCamp(event : TouchEvent) : void
    {

        if(Model.instance.screenMoved) return;

        var touch : Touch = event.getTouch(_camp);
        var endTouch : Touch = event.getTouch(_camp, TouchPhase.ENDED);
        if(endTouch) {
            coreExecute(ShowScreenCmd, CampScreen.NAME);
        }

        if(touch) {
            Mouse.cursor = MouseCursor.BUTTON;
        } else {
            Mouse.cursor = MouseCursor.AUTO;
        }


    }
}
}
