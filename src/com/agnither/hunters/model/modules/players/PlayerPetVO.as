/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.model.modules.players {
import com.agnither.hunters.model.modules.players.PersonageVO;

import flash.utils.Dictionary;

public dynamic class PlayerPetVO {

    public static const LIST: Vector.<PlayerPetVO> = new <PlayerPetVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public var id: String;
    public var name: String = "";
    public var level: int = 0;
    public var hp: int = 0;
    public var damage: int = 0;
    public var defence: int = 0;
    public var magic: int;
//    public var tamed: int;

    public static function fill($target : PlayerPetVO, $source : Object) : PlayerPetVO {
        var source : Object = $source;
        if(source.constructor != Object){
            source = JSON.parse(JSON.stringify(source));
        }
        for (var key : String in source)
        {
            if($target.hasOwnProperty(key)) {
                $target[key] = source[key];
            }
        }
        return $target;
    }

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {

            var source: Object = data[i];

            var object: PlayerPetVO = new PlayerPetVO();
            object = fill(object, source);

            LIST.push(object);
            DICT[object.id] = object;
        }
    }



    public function clone() : PlayerPetVO {
        return fill(new PlayerPetVO(), this);
    }
}
}
