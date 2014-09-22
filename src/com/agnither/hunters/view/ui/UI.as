/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 21.11.13
 * Time: 23:49
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.hunters.view.ui {
import com.agnither.hunters.GameController;
import com.agnither.hunters.view.ui.common.TabView;
import com.agnither.hunters.view.ui.popups.InventoryPopup;
import com.agnither.hunters.view.ui.popups.SelectMonsterPopup;
import com.agnither.hunters.view.ui.screens.battle.BattleScreen;
import com.agnither.hunters.view.ui.screens.battle.player.DropListView;
import com.agnither.hunters.view.ui.screens.battle.player.DropSlotView;
import com.agnither.hunters.view.ui.screens.battle.player.ManaListView;
import com.agnither.hunters.view.ui.common.ManaView;
import com.agnither.hunters.view.ui.screens.battle.player.PersonageView;
import com.agnither.hunters.view.ui.screens.hud.HudScreen;
import com.agnither.hunters.view.ui.screens.map.MapScreen;
import com.agnither.hunters.view.ui.screens.map.PlayerMapView;
import com.agnither.hunters.view.ui.screens.map.PointStars;
import com.agnither.hunters.view.ui.screens.map.PointView;
import com.agnither.ui.AbstractView;
import com.agnither.ui.Popup;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

import flash.net.registerClassAlias;
import flash.utils.Dictionary;

import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class UI extends Screen {

    public static const SHOW_SCREEN : String = "UI.SHOW_SCREEN";
    public static const SHOW_POPUP : String = "UI.SHOW_POPUP";
    public static const HIDE_SCREEN : String = "UI.HIDE_SCREEN";
    public static const HIDE_POPUP : String = "UI.HIDE_POPUP";

    public static var SCREENS: Dictionary = new Dictionary();
    public static var POPUPS: Dictionary = new Dictionary();
    public static var PANELS: Dictionary = new Dictionary();

    private var _screensContainer: Sprite;
    private var _darkness: Quad;
    private var _popupContainer: Sprite;
    private var _darkness2: Quad;
    private var _alertsContainer: Sprite;

    private var _currentScreen: Screen;
    private var _currentPopup: Popup;
    private var _currentPanels: Vector.<AbstractView>;
    private var _currentAlert: Popup;

    private var _closedPanels: Vector.<AbstractView>;

    public function UI() {
        super();
    }

    override protected function initialize():void {

        stage.addEventListener(UI.SHOW_SCREEN, onShowScreen);
        stage.addEventListener(UI.HIDE_SCREEN, onHideScreen);
        stage.addEventListener(UI.SHOW_POPUP, onShowPopup);
        stage.addEventListener(UI.HIDE_POPUP, onHidePopup);

        SCREENS[HudScreen.ID] = new HudScreen();
        SCREENS[MapScreen.ID] = new MapScreen();
        SCREENS[BattleScreen.ID] = new BattleScreen();

        POPUPS[InventoryPopup.ID] = new InventoryPopup();
        POPUPS[SelectMonsterPopup.ID] = new SelectMonsterPopup();

        registerClassAlias("map.Point", PointView);
        registerClassAlias("map.Player", PlayerMapView);
        registerClassAlias("map.PointStars", PointStars);

        registerClassAlias("common.TabView", TabView);
        registerClassAlias("common.ManaView", ManaView);

        registerClassAlias("battle.PersonageView", PersonageView);
        registerClassAlias("battle.ManaListView", ManaListView);
        registerClassAlias("battle.DropListView", DropListView);
        registerClassAlias("battle.DropSlotView", DropSlotView);

        _currentPanels = new <AbstractView>[];
        _closedPanels = new <AbstractView>[];

        _screensContainer = new Sprite();
        addChild(_screensContainer);
        _screensContainer.touchable = true;

        _darkness = new Quad(stage.stageWidth, stage.stageHeight, 0);
        _darkness.addEventListener(TouchEvent.TOUCH, handleTouch);
        _darkness.alpha = 0.8;
        _darkness.visible = false;
        addChild(_darkness);

        _popupContainer = new Sprite();
        addChild(_popupContainer);

        _darkness2 = new Quad(stage.stageWidth, stage.stageHeight, 0);
        _darkness2.addEventListener(TouchEvent.TOUCH, handleTouch);
        _darkness2.alpha = 0.8;
        _darkness2.visible = false;
        addChild(_darkness2);

        _alertsContainer = new Sprite();
        addChild(_alertsContainer);
    }
    private function onShowScreen(event : Event) : void {
        showScreen(event.data.toString());
    }
    private function onHideScreen(event : Event) : void {
        hideScreen();
    }
    private function onShowPopup(event : Event) : void {
        showPopup(event.data.toString());
    }
    private function onHidePopup(event : Event) : void {
        hidePopup();
    }
    public function showScreen(id: String):void {
        if (_currentScreen == SCREENS[id]) {
            return;
        }

        if (SCREENS[id]) {
            _currentScreen = SCREENS[id];
            _screensContainer.addChild(_currentScreen);
            _currentScreen.update();
        }
    }
    public function hideScreen():void {
        if (_currentScreen) {
            _screensContainer.removeChild(_currentScreen);
            _currentScreen = null;
        }
    }

    public function showPopup(id: String, data: Object = null):void {
        if (_currentPopup == POPUPS[id]) {
            return;
        }

        hidePopup();

        _currentPopup = POPUPS[id];
        if (_currentPopup) {
            _currentPopup.data = data;
            _darkness.visible = _currentPopup.darkened;
            _currentPopup.addEventListener(Popup.CLOSE, hidePopup);
            _popupContainer.addChild(_currentPopup);
        }
    }
    public function hidePopup(e: Event = null):void {
        if (_currentPopup) {
            _darkness.visible = false;
            _currentPopup.removeEventListener(Popup.CLOSE, hidePopup);
            _popupContainer.removeChild(_currentPopup);
            _currentPopup = null;

            hidePanels(false);
            restorePanels();
        }
    }

    public function showAlert(id: String, data: Object = null):void {
        if (_currentAlert == POPUPS[id]) {
            return;
        }

        hideAlert();

        _currentAlert = POPUPS[id];
        if (_currentAlert) {
            _currentAlert.data = data;
            _darkness2.visible = _currentAlert.darkened;
            _currentAlert.addEventListener(Popup.CLOSE, hideAlert);
            _alertsContainer.addChild(_currentAlert);
        }
    }
    public function hideAlert(e: Event = null):void {
        if (_currentAlert) {
            _darkness2.visible = false;
            _currentAlert.removeEventListener(Popup.CLOSE, hideAlert);
            _alertsContainer.removeChild(_currentAlert);
            _currentAlert = null;
        }
    }

    public function showPanel(id: String):void {
        var panel: AbstractView = PANELS[id];
        if (panel) {
            _currentPanels.push(panel);
            _popupContainer.addChild(panel);
//            panel.open();
        }
    }
    public function restorePanels():void {
        while (_closedPanels.length>0) {
            var panel: AbstractView = _closedPanels.shift();
            _currentPanels.push(panel);
            _popupContainer.addChild(panel);
//            panel.open();
        }
    }
    public function hidePanels(cache: Boolean = true):void {
        if (cache) {
            _closedPanels.length = 0;
        }

        while (_currentPanels.length>0) {
            var panel: AbstractView = _currentPanels.shift();
            if (cache) {
                _closedPanels.push(panel);
            }
//            panel.close();
        }
    }

    public function clearScreen():void {
        hideScreen();
        _darkness.visible = false;
        hidePopup();
        hidePanels(false);
    }

    public function clearPopup():void {
        hidePopup();
        hidePanels();
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(_darkness, TouchPhase.ENDED);
        if (touch && _currentPopup) {
//            _currentPopup.forceClose();
        }
    }
}
}
