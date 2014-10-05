/**
 * Created by mor on 05.10.2014.
 */
package com.agnither.hunters {
import flash.utils.getTimer;

import starling.display.Stage;
import starling.events.Event;

public class Ticker {
    private var _stage : Stage;

    private var tickCallbacks : Vector.<Function> = new <Function>[];
    private var lastTime : Number;

    public function Ticker($stage : Stage) {
        _stage = $stage;
        _stage.addEventListener(Event.ENTER_FRAME, onTick);
    }

    public function addTickCallback($func : Function) : void {
        if (tickCallbacks.indexOf($func) >= 0) return;
        tickCallbacks.push($func);
    }

    public function removeTickCallback($func : Function) : void {
        var index : int = tickCallbacks.indexOf($func);
        if (index >= 0)
        {
            tickCallbacks.splice(index, 1);
        }
    }

    private function onTick(event : Event) : void {

        var delta : int = getTimer() - lastTime;
        lastTime = getTimer();

        if (tickCallbacks.length == 0) return;

        for (var i : int = 0; i < tickCallbacks.length; i++)
        {
            var cb : Function = tickCallbacks[i];
            cb(delta);
        }
    }
}
}
