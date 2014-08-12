/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 8/26/13
 * Time: 11:36 AM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.hunters.utils {
import starling.events.EventDispatcher;

public class StateSequence extends EventDispatcher {

    public static const START_STATE: String = "start_state_StateSequence";

    private var _currentState: String;
    public function get current():String {
        return _currentState;
    }

    private var _nextState: String;
    public function get next():String {
        return _nextState;
    }

    private var _defaults: Array = [];

    public function StateSequence(defaults: Array) {
        _defaults = defaults;
    }

    public function addDefault(state: String):void {
        _defaults.push(state);
    }

    public function addState(name: String, force: Boolean = false):void {
        if (_currentState==name || _nextState==name) {
            return;
        }
        if (current && !force) {
            _nextState = name;
            if (_defaults.indexOf(current) >= 0) {
                nextState();
            }
        } else {
            _currentState = name;
            startState();
        }
    }

    public function nextState():void {
        _currentState = _nextState;
        _nextState = null;

        startState();
    }

    private function startState():void {
        if (current) {
            dispatchEventWith(START_STATE, false, current);
        }
    }

    public function destroy():void {
        _currentState = null;
        _nextState = null;
        _defaults = null;
    }
}
}
