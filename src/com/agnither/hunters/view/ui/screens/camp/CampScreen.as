/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens.camp {
import com.agnither.hunters.view.ui.popups.monsters.SelectMonsterPopup;
import com.agnither.hunters.view.ui.popups.shop.ShopPopup;
import com.agnither.hunters.view.ui.popups.skills.SkillsPopup;
import com.agnither.hunters.view.ui.popups.trainer.TrainerPopup;
import com.agnither.hunters.view.ui.screens.map.*;
import com.agnither.hunters.App;
import com.agnither.hunters.model.modules.monsters.MonsterAreaVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.match3.Match3Game;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.view.ui.common.MonsterArea;
import com.agnither.hunters.view.ui.popups.traps.TrapSetPopup;
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
import starling.text.TextField;

public class CampScreen extends Screen {

    public static const NAME : String = "com.agnither.hunters.view.ui.screens.camp.CampScreen";

    private var _back : Image;
    private var _container : Sprite;
    private var _maxY : Number = -100;
    private var _maxX : Number = -100;
    private var _allowMove : Boolean = false;
    private var _startPoint : Point;
    private var _startPos : Point;
//    private var _points : Dictionary = new Dictionary();
//    private var _playerPositions : Dictionary = new Dictionary();
//    private var _clouds : Dictionary = new Dictionary();
//    public static const INIT_MONSTER : String = "MapScreen.INIT_MONSTER";
//    private var _monstersContainer : Sprite;
////    private var _playerPositionsArr : Vector.<Point>;
//    private var _playerPosition : PlayerPoint;
//    public static const START_TRAP : String = "MapScreen.START_TRAP";
//    public static const STOP_TRAP : String = "MapScreen.STOP_TRAP";
//    public static const ADD_TRAP : String = "MapScreen.ADD_TRAP";
//    public static const DELETE_TRAP : String = "MapScreen.DELETE_TRAP";
//    public static const ADD_POINT : String = "MapScreen.ADD_POINT";
//    public static const DELETE_POINT : String = "MapScreen.DELETE_POINT";
//    private var _trapsContainer : Sprite;
//    public static const ADD_CHEST : String = "MapScreen.ADD_CHEST";
//    public static const REMOVE_CHEST : String = "MapScreen.REMOVE_CHEST";
//    private var _chestsContainer : Sprite;
//    private var _houses : Object = {};
//    private var _houseContainer : Sprite;
    private var isFirstRun : Boolean = true;
    private var _skills : Sprite;
    private var _shop : Sprite;
    private var _instructor : Sprite;

    public function CampScreen() {

        super();

    }

    override protected function initialize() : void {

        _container = new Sprite();
        addChild(_container);
        _container.touchable = true;
        this.touchable = true;

        createFromConfig(_refs.guiConfig.camp, _container);

//        coreAddListener(ADD_POINT, onPointAdd);
//        coreAddListener(DELETE_POINT, onPointDelete);
//        coreAddListener(ADD_TRAP, onTrapAdd);
//        coreAddListener(DELETE_TRAP, onTrapDelete);
//        coreAddListener(ADD_CHEST, onChestAdd);
//        coreAddListener(REMOVE_CHEST, onChestRemove);

        _back = _links["bitmap_camp_bg.jpg"];
        _back.touchable = true;

        _skills = _links["achievements"];
        _skills.touchable = true;
        _instructor = _links["instructor"];
        _instructor.touchable = true;
        _shop = _links["shop"];
        _shop.touchable = true;

        _skills.getChildAt(0).touchable = true;
        _shop.getChildAt(0).touchable = true;
        _instructor.getChildAt(0).touchable = true;

        _skills.addEventListener(TouchEvent.TOUCH, onTouchSkills);
        _shop.addEventListener(TouchEvent.TOUCH, onTouchShop);
        _instructor.addEventListener(TouchEvent.TOUCH, onTouchInstructor);



        _container.x = (stage.stageWidth - _back.width) * 0.5;
        _container.y = (stage.stageHeight - _back.height) * 0.5;

        _maxX = stage.stageWidth - _back.width;
        _maxY = stage.stageHeight - _back.height;

        _container.addEventListener(TouchEvent.TOUCH, handleTouch);



    }

    private function onTouchInstructor(e : TouchEvent) : void {
        var touch : Touch = e.getTouch(_instructor);
        if (touch)
        {
            e.stopImmediatePropagation();
            switch (touch.phase)
            {
                case TouchPhase.HOVER:
                    Mouse.cursor = MouseCursor.BUTTON;
                    break;
                case TouchPhase.ENDED:
                    coreExecute(ShowPopupCmd, TrainerPopup.NAME);
                    break;
            }
        } else {
            Mouse.cursor = MouseCursor.AUTO;
        }
    }

    private function onTouchSkills(e : TouchEvent) : void {
        e.stopImmediatePropagation();
        e.stopPropagation();
        var touch : Touch = e.getTouch(_skills);
        if (touch)
        {

            e.stopImmediatePropagation();
            switch (touch.phase)
            {
                case TouchPhase.HOVER:
                    Mouse.cursor = MouseCursor.BUTTON;
                    break;
                case TouchPhase.ENDED:
                    coreExecute(ShowPopupCmd, SkillsPopup.NAME);
                    break;
            }
        } else {
            Mouse.cursor = MouseCursor.AUTO;
        }
    }

    private function onTouchShop(e : TouchEvent) : void {
        e.stopImmediatePropagation();
        e.stopPropagation();
        var touch : Touch = e.getTouch(_shop);
        if (touch)
        {
            e.stopImmediatePropagation();
            switch (touch.phase)
            {
                case TouchPhase.HOVER:
                    Mouse.cursor = MouseCursor.BUTTON;
                    break;
                case TouchPhase.ENDED:
                    coreExecute(ShowPopupCmd, ShopPopup.NAME);
                    break;
            }
        } else {
            Mouse.cursor = MouseCursor.AUTO;
        }
    }


    override public function update() : void {

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
