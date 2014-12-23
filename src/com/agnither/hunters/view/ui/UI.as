/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 21.11.13
 * Time: 23:49
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.hunters.view.ui {
import com.agnither.hunters.model.Model;
import com.agnither.hunters.view.ui.common.ItemManaView;
import com.agnither.hunters.view.ui.common.TabView;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.hunters.view.ui.screens.battle.player.DropListView;
import com.agnither.hunters.view.ui.screens.battle.player.DropSlotView;
import com.agnither.hunters.view.ui.screens.battle.player.ManaListView;
import com.agnither.hunters.view.ui.screens.battle.player.PersonageView;
import com.agnither.hunters.view.ui.screens.camp.CampScreen;
import com.agnither.hunters.view.ui.screens.hud.HudScreen;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.hunters.view.ui.screens.map.PlayerPoint;
import com.agnither.hunters.view.ui.screens.map.StarsBar;
import com.agnither.hunters.view.ui.screens.map.MonsterPoint;
import com.agnither.ui.AbstractView;
import com.agnither.ui.Popup;
import com.agnither.ui.Screen;
import com.cemaprjl.core.coreAddListener;
import com.cemaprjl.viewmanage.ClassBindings;
import com.cemaprjl.viewmanage.ScreensStorage;
import com.cemaprjl.viewmanage.ViewFactory;

import flash.net.registerClassAlias;

import starling.display.Image;

import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class UI extends Screen {

    public static const SHOW_SCREEN : String = "UI.SHOW_SCREEN";
    public static const SHOW_POPUP : String = "UI.SHOW_POPUP";
//    public static const HIDE_SCREEN : String = "UI.HIDE_SCREEN";
    public static const HIDE_POPUP : String = "UI.HIDE_POPUP";

//    public static var SCREENS : Dictionary = new Dictionary();
//    public static var POPUPS : Dictionary = new Dictionary();
//    public static var PANELS : Dictionary = new Dictionary();

    private var _screensContainer : Sprite;
    private var _darkness : Image;
    private var _popupContainer : Sprite;
    private var _darkness2 : Quad;
    private var _alertsContainer : Sprite;

    private var _currentPopup : Popup;
//    private var _currentPanels : Vector.<AbstractView>;
    private var _currentAlert : Popup;

//    private var _closedPanels : Vector.<AbstractView>;
    private var _currentScreenName : String;
    private var _prevScreen : AbstractView;
    private var _currentScreen : AbstractView;
    private var _currentPopupName : String;
    private var _prevPopup : Popup;
    private var _hud : HudScreen;

    public function UI() {
        super();
    }

    override protected function initialize() : void {

        coreAddListener(UI.SHOW_SCREEN, onShowScreen);
        coreAddListener(UI.SHOW_POPUP, onShowPopup);
        coreAddListener(UI.HIDE_POPUP, onHidePopup);

        ScreensStorage.init();
        ClassBindings.init();

//        _currentPanels = new <AbstractView>[];
//        _closedPanels = new <AbstractView>[];

        _screensContainer = new Sprite();
        addChild(_screensContainer);

        _hud = ViewFactory.getView(HudScreen.NAME) as HudScreen;
        addChild(_hud);

//        _screensContainer.touchable = true;

        _darkness = new Image(_refs.gui.getTexture("tint"));
//        _darkness = new Quad(1,1, 0);
//        _darkness.alpha = 0.8;
        _darkness.visible = false;
        addChild(_darkness);

        _popupContainer = new Sprite();
        addChild(_popupContainer);

//        _darkness2 = new Quad(stage.stageWidth, stage.stageHeight, 0);
//        _darkness2.addEventListener(TouchEvent.TOUCH, handleTouch);
//        _darkness2.alpha = 0.8;
//        _darkness2.visible = false;
//        addChild(_darkness2);
//
//        _alertsContainer = new Sprite();
//        addChild(_alertsContainer);
    }


    override public function update() : void {

//        = new Quad(stage.stageWidth, stage.stageHeight, 0);
//        super.update();
    }

    private function handleClosePopup(e : TouchEvent) : void {
        var touch : Touch = e.getTouch(_darkness, TouchPhase.ENDED);
        if (touch && _currentPopup)
        {
            hidePopup();
        }
    }

    private function onShowScreen($name : String) : void {
        showScreen($name);
        updateHud();
    }

    private function updateHud() : void {

        _hud.visible = _currentScreenName == MapScreen.NAME || _currentScreenName == CampScreen.NAME;
        _hud.update();

    }

    private function onShowPopup($name : String) : void {
        showPopup($name);
    }

    private function onHidePopup($name : String) : void {
        hidePopup($name);
    }

    private function showScreen(id : String) : void {
        if (id != _currentScreenName)
        {
            _currentScreenName = id;
            var newView : AbstractView = ViewFactory.getView(id);
            if (newView != null)
            {
                _prevScreen = _currentScreen;
                _currentScreen = newView;
                _screensContainer.addChild(_currentScreen);
                _currentScreen.update();
                /**
                 * deleting previous after current may be required for effects
                 */
                if (_prevScreen)
                {
                    _screensContainer.removeChild(_prevScreen);
                    _prevScreen.onRemove();
                }
                else
                {
//                    coreDispatch(ViewManager.ON_VIEW_SHOW);
                }
            }
        }
    }

    private function showPopup(id : String) : void {
        if (id != _currentPopupName)
        {
            _currentPopupName = id;
            var newPopup : Popup = ViewFactory.getView(id) as Popup;
            if (newPopup != null)
            {
                _prevPopup = _currentPopup;
                _currentPopup = newPopup;
                _darkness.visible = _currentPopup.darkened;
                _darkness.width = stage.stageWidth;
                _darkness.height = stage.stageHeight;
                _popupContainer.addChild(_currentPopup);
                _currentPopup.isActive = true;
                Model.instance.currentPopup = _currentPopup;
                Model.instance.currentPopupName = _currentPopupName;
                _currentPopup.update();
                /**
                 * deleting previous after current may be required for effects
                 */
                if (_prevPopup)
                {
                    _prevPopup.isActive = false;
                    _popupContainer.removeChild(_prevPopup);
                }
                else
                {
//                    coreDispatch(ViewManager.ON_VIEW_SHOW);
                }
            }
        }
    }

    private function hidePopup(id : String = "") : void {
        if (_currentPopup)
        {
            _darkness.visible = false;
            _popupContainer.removeChild(_currentPopup);
            _currentPopup.isActive = false;
            _currentPopup.onRemove();
            _currentPopup = null;
            _currentPopupName = "";
        }
    }


    public function get currentPopup() : Popup
    {
        return _currentPopup;
    }
}
}
