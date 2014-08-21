/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.player.drop {
import starling.events.EventDispatcher;

public class Drop extends EventDispatcher {

    public function get icon():String {
        return null;
    }

    public function Drop() {
    }

    public function stack(drop: Drop):Boolean {
        return true;
    }
}
}
