/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.map {
import com.agnither.hunters.App;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.view.ui.screens.battle.monster.MonsterArea;
import com.agnither.hunters.view.ui.screens.battle.monster.TrapPopup;
import com.agnither.ui.Screen;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.core.coreDispatch;
import com.cemaprjl.core.coreExecute;
import com.cemaprjl.viewmanage.ShowPopupCmd;

import flash.geom.Point;

import flash.geom.Point;

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.utils.Dictionary;

import starling.display.DisplayObject;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
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
    private var _clouds : Dictionary = new Dictionary();
    public static const INIT_MONSTER : String = "MapScreen.INIT_MONSTER";
    private var _monstersContainer : Sprite;
//    private var _playerPositionsArr : Vector.<Point>;
    private var _playerPosition : PlayerPoint;
    public static const START_TRAP : String = "MapScreen.START_TRAP";
    public static const STOP_TRAP : String = "MapScreen.STOP_TRAP";
    public static const ADD_TRAP : String = "MapScreen.ADD_TRAP";
    public static const DELETE_TRAP : String = "MapScreen.DELETE_TRAP";
    public static const ADD_POINT : String = "MapScreen.ADD_POINT";
    public static const DELETE_POINT : String = "MapScreen.DELETE_POINT";
    private var _trapsContainer : Sprite;
    public static const ADD_CHEST : String = "MapScreen.ADD_CHEST";
    public static const REMOVE_CHEST : String = "MapScreen.REMOVE_CHEST";
    private var _chestsContainer : Sprite;
    private var _houses : Object = {};
    private var _houseContainer : Sprite;
    private var isFirstRun : Boolean = true;

    public function MapScreen() {

        super();

    }

    override protected function initialize() : void {

        _container = new Sprite();
        addChild(_container);
        _container.touchable = true;
        this.touchable = true;

        createFromConfig(_refs.guiConfig.map, _container);

        coreAddListener(ADD_POINT, onPointAdd);
        coreAddListener(DELETE_POINT, onPointDelete);
        coreAddListener(ADD_TRAP, onTrapAdd);
        coreAddListener(DELETE_TRAP, onTrapDelete);
        coreAddListener(ADD_CHEST, onChestAdd);
        coreAddListener(REMOVE_CHEST, onChestRemove);

        _back = _links["bitmap_map_bg.png"];
        _back.touchable = true;

        _monstersContainer = new Sprite();
        _monstersContainer.name = "monsters_container"; // hack
        _container.addChildAt(_monstersContainer, _container.getChildIndex(_back) + 1);

        _trapsContainer = new Sprite();
        _trapsContainer.name = "traps_container"; // hack
        _container.addChildAt(_trapsContainer, _container.getChildIndex(_monstersContainer) + 1);

        _chestsContainer = new Sprite();
        _chestsContainer.name = "chests_container"; // hack
        _container.addChildAt(_chestsContainer, _container.getChildIndex(_trapsContainer) + 1);

        _houseContainer = new Sprite();
        _houseContainer.name = "houses_container"; // hack
        _container.addChildAt(_houseContainer, _container.getChildIndex(_chestsContainer) + 1);

        _container.x = (stage.stageWidth - _back.width) * 0.5;
        _container.y = (stage.stageHeight - _back.height) * 0.5;

        _maxX = stage.stageWidth - _back.width;
        _maxY = stage.stageHeight - _back.height;

        _container.addEventListener(TouchEvent.TOUCH, handleTouch);

        /**
         * XXX player and monsters positions are getting and should create from progress and logic
         * clouds/fog getting from graphic, but hide/shows according progress
         *
         */
        var removeArr : Array = [];
//        _playerPositionsArr = new <Point>[];
        for (var i : int = 0; i < _container.numChildren; i++)
        {
            var dobj : DisplayObject = _container.getChildAt(i);
            if(dobj is MonsterPoint) {
                removeArr.push(dobj);
            } else if (dobj is MonsterArea) {

//                (dobj as MonsterArea).update();
                Model.instance.monsterAreas[dobj.name] = new Rectangle(dobj.x, dobj.y, 50 * dobj.transformationMatrix.a, 50 * dobj.transformationMatrix.d);
//                trace(dobj.name, App.instance.monsterAreas[dobj.name]);
                removeArr.push(dobj);
            } else if (dobj is PlayerPoint) {

                var ptName : String = dobj.name;
                if(ptName.indexOf("00") > -1) {
                    _playerPosition = dobj as PlayerPoint;
                } else {
                    removeArr.push(dobj);
                }

//
//                _playerPositionsArr.push(new Point());
//
//                _playerPositions[ptName.split("_")[1]] = dobj;
//                dobj.visible = false;
//
//                initMonster(ptName, new Point(dobj.x, dobj.y));


            } else if(dobj is HousePoint) {

                _houses[dobj.name] = dobj;
                dobj.visible = false;

            } else if(dobj.name.indexOf("clouds") > -1) {
                _clouds[dobj.name] = dobj;
//                dobj.touchable = true;
//                dobj.visible = false;
            }
        }

        for (var j : int = 0; j < removeArr.length; j++)
        {
            var dobj1 : DisplayObject = removeArr[j];
            _container.removeChild(dobj1);
        }






    }

    private function onPointDelete($pt : MonsterPoint) : void {

        if(_monstersContainer.contains($pt)) {
            _monstersContainer.removeChild($pt);
            $pt.destroy();
        }

    }

    private function onPointAdd($pt : MonsterPoint) : void {
        var monsterRect : Rectangle = Model.instance.monsterAreas[$pt.monsterType.id];
//        var mp : MonsterPoint = new MonsterPoint();
        _monstersContainer.addChild($pt);
        var monsterPt : Point = new Point(monsterRect.x + Math.random() * monsterRect.width, monsterRect.y + Math.random() * monsterRect.height);
        $pt.x = monsterPt.x;
        $pt.y = monsterPt.y;
        $pt.update();

    }

    private function onChestRemove($chest : ChestPoint) : void {

        if(_chestsContainer.contains($chest)) {
            _chestsContainer.removeChild($chest);
            App.instance.chest = null;
            App.instance.chestStep = -1;
        }


    }

    private function onChestAdd() : void {

        if(_chestsContainer.numChildren >= Model.instance.progress.unlockedMonsters.length) {
            return;
        }

        var chest : ChestPoint = new ChestPoint();
        _chestsContainer.addChild(chest);

        var monster  : String  = Model.instance.progress.unlockedMonsters[int(Math.random() * Model.instance.progress.unlockedMonsters.length)];
        var rect : Rectangle = Model.instance.monsterAreas[monster];
        var pt : Point = new Point(rect.x + rect.width * Math.random(), rect.y + rect.height * Math.random());

        chest.update();

        chest.x = pt.x;
        chest.y = pt.y;


    }

    private function onTrapDelete($trap : TrapPoint) : void {

        if(_trapsContainer.contains($trap)) {
            _trapsContainer.removeChild($trap);
        }
        $trap.destroy();

    }

    private function onTrapAdd($data : Object) : void {

        var trapPoint : TrapPoint = new TrapPoint();
        _trapsContainer.addChild(trapPoint);
        trapPoint.monsterType = Model.instance.monsters.getMonster($data.id, 1);
//        trapPoint.monsterType = MonsterVO.DICT[$data.id];
        trapPoint.data = $data;
        trapPoint.update();

        var position : Point = $data.position;

        trapPoint.x = position.x;
        trapPoint.y = position.y;

        Model.instance.territoryTraps[$data.id] = trapPoint;
    }



    override public function update() : void {
        var arr : Array = Model.instance.progress.unlockedMonsters;
        var i : int = 0;
        var monsterID : String; // = Model.instance.progress.unlockedMonsters[Model.instance.progress.unlockedMonsters.length - 1];
        for (i = 0; i < arr.length; i++)
        {
            monsterID = arr[i];
            var monsterArea  : MonsterAreaVO = Model.instance.monsters.getMonsterArea(monsterID);
            if(_clouds[monsterArea.area]) {
                _clouds[monsterArea.area].visible = false;
            }

            if(monsterArea.house && _houses[monsterArea.house])  {
                _houses[monsterArea.house].visible = true;
            }
        }

        var monsterRect : Rectangle = Model.instance.monsterAreas[monsterID];
        _playerPosition.x = monsterRect.x + monsterRect.width * 0.5;
        _playerPosition.y = monsterRect.y + monsterRect.height * 0.5;

        Model.instance.updatePoints();


    }



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
                    _startPoint = new Point(touch.globalX, touch.globalY);
                    _startPos = new Point(_container.x, _container.y);

                    var pt : Point = _container.globalToLocal(_startPoint);
                    var trapAllowed : Boolean = false;
                    if(App.instance.trapMode) {
                        for (var i : int = 0; i < Model.instance.progress.unlockedMonsters.length; i++)
                        {
                            var key : String = Model.instance.progress.unlockedMonsters[i];
                            var rect : Rectangle = Model.instance.monsterAreas[key];
                            if(rect.containsPoint(pt) && Model.instance.territoryTraps[key] == null) {
                                trapAllowed = true;
                                break;
                            }
                        }
                        if(trapAllowed) {
                            coreExecute(ShowPopupCmd, TrapPopup.NAME, {id : key, position : pt, mode:TrapPopup.SET_MODE});
                            coreDispatch(MapScreen.STOP_TRAP);
                            return;
                        } else {
                            coreDispatch(MapScreen.STOP_TRAP);
                        }
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
                    }
                    break;
                case TouchPhase.ENDED:
                    _allowMove = false;
                    break;
            }
        }
    }

}
}
