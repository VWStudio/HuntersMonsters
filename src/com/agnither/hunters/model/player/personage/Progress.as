/**
 * Created by mor on 22.09.2014.
 */
package com.agnither.hunters.model.player.personage {
import starling.events.EventDispatcher;

public class Progress extends EventDispatcher {
    private var _regions : Vector.<String>;
    private var _petsUnlocked : Vector.<Number>;
    public function Progress() {
        super();
    }

    public function init(data : Object): void {

//        var regionsArr : Array = data.regions ? data.regions : ["00"];
//        _regions = new <String>[];
        var i : int = 0;
//        for (i = 0; i < regionsArr.length; i++)
//        {
//            var regionID : String = regionsArr[i];
//            _regions.push(regionID);
//        }

//        _petsUnlocked = new <Number>[];
//
//        var petsArr : Array = data.pets ? data.pets : [];
//        for (i = 0; i < petsArr.length; i++)
//        {
//            var petID : Number = petsArr[i];
//            _petsUnlocked.push(petID);
//        }



    }

//    public function get regions() : Vector.<String> {
//        return _regions;
//    }

//    public function get petsUnlocked() : Vector.<Number> {
//        return _petsUnlocked;
//    }
}
}
