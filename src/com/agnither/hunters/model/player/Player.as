/**
 * Created by agnither on 13.08.14.
 */
package com.agnither.hunters.model.player {
import starling.events.EventDispatcher;

public class Player extends EventDispatcher {

    private var _personage: Personage;
    public function get personage():Personage {
        return _personage;
    }

    private var _manaList: ManaList;
    public function get manaList():ManaList {
        return _manaList;
    }

    public function Player() {
        _personage = new Personage();

        _manaList = new ManaList();
    }

    public function init(data: Object):void {
        _personage.init(data);

        _manaList.init();
    }
}
}
