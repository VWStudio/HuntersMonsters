/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.model.modules.monsters {
import com.agnither.hunters.model.modules.players.PersonageVO;

import flash.utils.Dictionary;

public dynamic class PriceItemVO extends PersonageVO {

    public static const LIST: Vector.<PriceItemVO> = new <PriceItemVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public var id: String;
    public var type: String = "";
    public var code: String = "";
    public var amount: Number = 0;


    //id	type	code	amount



    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {

            var source: Object = data[i];

            var object: PriceItemVO = fill(new PriceItemVO(), source);

            if(!DICT[object.id]) {
                DICT[object.id] = new Dictionary();
            }

            DICT[object.id] = object;
            LIST.push(object);
        }
    }



    public static function fill($target : PriceItemVO, $source : Object) : PriceItemVO {

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
    public function clone() : PriceItemVO {
        return fill(new PriceItemVO(), this);
    }
}
}
