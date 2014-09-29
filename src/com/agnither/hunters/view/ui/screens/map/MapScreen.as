/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.map {
import com.agnither.hunters.App;
import com.agnither.hunters.data.outer.MonsterVO;
import com.agnither.hunters.model.Match3Game;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.ui.Screen;
import com.cemaprjl.core.coreDispatch;

import flash.geom.Point;
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

    private var _player : LocalPlayer;

    private var _back : Image;
    private var _container : Sprite;
    private var _maxY : Number = -100;
    private var _maxX : Number = -100;
    private var _allowMove : Boolean = false;
    private var _startPoint : Point;
    private var _startPos : Point;
    private var _points : Dictionary = new Dictionary();
    private var _playerPositions : Dictionary = new Dictionary();
    private var _clouds : Dictionary = new Dictionary();
    public static const INIT_MONSTER : String = "MapScreen.INIT_MONSTER";
    private var _monstersContainer : Sprite;

    public function MapScreen() {

        _player = App.instance.player;

        super();



    }

    override protected function initialize() : void {

        _container = new Sprite();
        addChild(_container);
        _container.touchable = true;
        this.touchable = true;

        createFromConfig(_refs.guiConfig.map, _container);

        _back = _links["bitmap_map_bg.png"];
        _back.touchable = true;

        _monstersContainer = new Sprite();
        _monstersContainer.name = "monsters_container"; // hack
        _container.addChildAt(_monstersContainer, _container.getChildIndex(_back) + 1);

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
        for (var i : int = 0; i < _container.numChildren; i++)
        {
            var dobj : DisplayObject = _container.getChildAt(i);
//            if(dobj is MonsterPoint) {
//                _points[dobj.name.split("_")[1]] = dobj;
//                dobj.touchable = true;
//                (dobj as MonsterPoint).update();
//            } else
            if (dobj is PlayerPoint) {

                var ptName : String = dobj.name;
                _playerPositions[ptName.split("_")[1]] = dobj;
                dobj.visible = false;

                initMonster(ptName, new Point(dobj.x, dobj.y));


            } else if(dobj.name.indexOf("clouds") > -1) {
                _clouds[dobj.name.split("_")[1]] = dobj;
                dobj.touchable = true;
            } else {
//                trace(dobj);
            }
        }


    }

    private function initMonster($ptName : String, point : Point) : void {

        var mp : MonsterPoint = new MonsterPoint();
        _monstersContainer.addChild(mp);
        var monstersInArea  : Vector.<MonsterVO> = MonsterVO.AREA[$ptName];
        mp.monsterType = monstersInArea[int(monstersInArea.length * Math.random())];

        var monsterPt : Point = Point.polar((mp.monsterType.radius - 30 )* Math.random() + 30, Math.PI * 2 * Math.random());
        trace($ptName, monsterPt);
        monsterPt = monsterPt.add(point);
        trace(point, monsterPt);

        mp.x = monsterPt.x;
        mp.y = monsterPt.y;
    }


    override public function update() : void {
        /**
         * kinda progress
         */

        var player : LocalPlayer = _player as LocalPlayer;
        for (var i : int = 0; i < player.progress.regions.length; i++)
        {
            var regionID : String = player.progress.regions[i];
            if(_clouds[regionID]) {
                _clouds[regionID].visible = false;
            }
        }

        _playerPositions["00"].visible = true;
//        _clouds["01"].visible = false;

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
                    _allowMove = true;
                    _startPoint = new Point(touch.globalX, touch.globalY);
                    _startPos = new Point(_container.x, _container.y);
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