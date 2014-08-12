/**
 * Created by agnither on 01.02.14.
 */
package com.agnither.hunters.utils {
import starling.core.Starling;
import starling.display.DisplayObject;

public class Motion {

    private var _obj: DisplayObject;
    private var _endVisible: Boolean;

    private var _sequence: Array = [];
    private var _pointer: int;
    private var _current: Object;
    private var _callback: Function;

    public function Motion(obj: DisplayObject) {
        _obj = obj;
        _pointer = 0;
    }

    public function init(x: int, y: int, scale: Number = 1, visible: Boolean = false, alpha: Number = 1):void {
        _obj.x = x;
        _obj.y = y;
        if (scale!=1) {
            _obj.scaleX = scale;
            _obj.scaleY = scale;
        }
        _obj.visible = visible;
        _obj.alpha = 1;
    }

    public function animate(params: Object, time: Number, loopTo: int = -1):void {
        params.time = time;
        params.loopTo = loopTo;
        _sequence.push(params);
    }

    public function start(delay: Number = 0, endVisible: Boolean = true):void {
        _endVisible = endVisible;
        if (delay) {
            Starling.juggler.delayCall(next, delay);
        } else {
            next();
        }
    }

    public function stop():void {
        Starling.juggler.removeTweens(_obj);
    }

    private function next(...args):void {
        if (_callback is Function) {
            _callback.apply(this, args);
        }

        if (_current) {
            if (_current.loopTo>=0) {
                _pointer = _current.loopTo;
            }
        }

        if (!_sequence) {
            return;
        }

        if (_pointer==_sequence.length) {
            _obj.visible = _endVisible;
            return;
        }

        _obj.visible = true;

        _current = _sequence[_pointer++];
        var action: Object = getClone(_current);
        delete action.time;
        delete action.loopTo;
        _callback = action.onComplete;
        action.onComplete = next;
        Starling.juggler.tween(_obj, _current.time, action);
    }

    private static function getClone(data: Object):Object {
        var clone: Object = data is Array ? [] : {};
        if (data) {
            if (data is Array) {
                for (var i:int = 0; i < data.length; i++) {
                    clone.push(data[i]);
                }
            } else {
                for (var key: String in data) {
                    if (data[key] is Number || data[key] is String || data[key] is Function) {
                        clone[key] = data[key];
                    } else {
                        clone[key] = getClone(data[key]);
                    }
                }
            }
        }
        return clone;
    }

    public function destroy():void {
        stop();
        _obj = null;

        while (_sequence.length>0) {
            var action: Object = _sequence.shift();
            action = null;
        }
        _sequence = null;
        _current = null;
        _callback = null;
    }
}
}
