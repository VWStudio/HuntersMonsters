/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.map {
import com.agnither.hunters.App;
import com.agnither.hunters.model.Match3Game;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.ui.Screen;

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

    public static const ID : String = "MapScreen";

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

        _container.x = (stage.stageWidth - _back.width) * 0.5;
        _container.y = (stage.stageHeight - _back.height) * 0.5;

        _maxX = stage.stageWidth - _back.width;
        _maxY = stage.stageHeight - _back.height;

        _container.addEventListener(TouchEvent.TOUCH, handleTouch);

        for (var i : int = 0; i < _container.numChildren; i++)
        {
            var dobj : DisplayObject = _container.getChildAt(i);
            if(dobj is PointView) {
                _points[dobj.name.split("_")[1]] = dobj;
                dobj.touchable = true;
            } else if (dobj is PlayerMapView) {
                _playerPositions[dobj.name.split("_")[1]] = dobj;
                dobj.visible = false;
            } else if(dobj.name.indexOf("clouds") > -1) {
                _clouds[dobj.name.split("_")[1]] = dobj;
            } else {
//                trace(dobj);
            }
        }
        _playerPositions["00"].visible = true;
        _clouds["01"].visible = false;




    }

    private function sortPlayers($a : PlayerMapView, $b : PlayerMapView) : Number {
        if($a.name < $b.name) return -1;
        if($a.name > $b.name) return 1;
        return 0;
    }

    private function handleTouch(e : TouchEvent) : void {

        for (var key : String in _points)
        {
            if(e.interactsWith(_points[key])) {
                Mouse.cursor = MouseCursor.BUTTON;
                var ptTouch : Touch = e.getTouch(_points[key], TouchPhase.BEGAN);
//                trace(key, ptTouch, e.currentTarget["name"]);
                if(ptTouch) {
                    trace("RUN GAME HERE");
                    return;
                }
            }
        }
        Mouse.cursor = MouseCursor.AUTO;
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
//            trace(touch.phase);
//            var cell: Sprite = _container.hitTest(touch.getLocation(_container)) as Sprite;
//            if (cell) {
//                switch (touch.phase) {
//
//                }
//
//
//                if (touch.phase == TouchPhase.BEGAN) {
//
//                } || touch.phase == TouchPhase.MOVED
////                                                               && _rollOver && _rollOver != cell
//                        ) {
////                    _rollOver = cell;
////                    dispatchEventWith(SELECT_CELL, true, _rollOver.cell);
//
////                    if (touch.phase != TouchPhase.BEGAN) {
////                        _rollOver = null;
////                    }
//                } else if (touch.phase == TouchPhase.ENDED) {
////                    _rollOver = null;
//                }
//            }
        }
    }

//    private function handleClick(e: Event):void {
//        dispatchEventWith(SELECT_MONSTER, true);
//    }
}
}
