/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.model {
import starling.events.EventDispatcher;

public class Game extends EventDispatcher {

    private var _field: Field;
    public function get field():Field {
        return _field;
    }

    public function Game() {
        _field = new Field();
    }

    public function init():void {
        _field.init();
    }
}
}
