/**
 * Created by agnither on 25.08.14.
 */
package com.agnither.hunters.model.player.inventory {
import com.agnither.hunters.model.modules.monsters.MonsterVO;

import starling.events.EventDispatcher;

public class Pet extends EventDispatcher {

    public static const UPDATE: String = "update_Pet";

    public var uniqueId: String;
//    public function set uniqueId(value: String):void {
//        _uniqueId = value;
//    }
//    public function get uniqueId():String {
//        return _uniqueId;
//    }

    protected var _monster: MonsterVO;
    public function get id():String {
        return _monster.id;
    }

    public function get level():Number {
        return _monster.level;
    }

    public function get name():String {
        return _monster.name;
    }
    public function get picture():String {
        return _monster.picture;
    }

    private var _params: Object;
    public function get params():Object {
        return _params;
    }
    public function get tamed():int {
        return _params.tamed;
    }

    public function Pet(monster: MonsterVO, params: Object) {
        _monster = monster;
        _params = params;
    }

    public function tame($val : Boolean = true):void {
        _params.tamed = int($val);
        update();
    }

    public function update():void {
        dispatchEventWith(UPDATE);
    }

    public function destroy():void {
        _monster = null;
        _params = null;
    }

    public function get monster() : MonsterVO
    {
        return _monster;
    }
}
}
