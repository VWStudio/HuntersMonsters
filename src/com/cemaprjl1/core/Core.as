package com.cemaprjl1.core {
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

/**
 * @author mor
 */
internal class Core extends EventDispatcher {

    private static var _instance:Core;
    private var _listeners:Dictionary;


    public function Core() {
        super(this);
        _listeners = new Dictionary();
    }

    public static function get instance():Core {
        if (!_instance) {
            _instance = new Core();
        }
        return _instance;
    }

    public function dispatch(...rest):void {
        var evtName:String = rest.shift();
        var listener:Vector.<Function> = _listeners[evtName] as Vector.<Function>;
        if (listener) {
            for (var i:int = 0; i < listener.length; i++) {
                if (rest && listener[i].length) {
                    listener[i].apply(null, rest);
                } else {
                    listener[i]();
                }
            }
        }
    }

    public function addListener($event:String, $func:Function):void {
        var listener:Vector.<Function> = _listeners[$event];
        if (!listener) {
            listener = new <Function>[];
            _listeners[$event] = listener;
        }
        if (listener.indexOf($func) == -1) {
            listener.push($func);
        }
    }

    public function removeListener($event:String, $func:Function):void {
        var listener:Vector.<Function> = _listeners[$event];
        if (listener) {
            var index:int = listener.indexOf($func);
            if (index != -1) {
                listener.splice(index, 1);
            }
            if (!listener.length) {
                delete _listeners[$event];
            }
        }
    }
}
}
