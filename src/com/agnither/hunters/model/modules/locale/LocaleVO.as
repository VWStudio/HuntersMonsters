/**
 * Created by agnither on 21.08.14.
 */
package com.agnither.hunters.model.modules.locale {
import com.agnither.hunters.model.modules.items.*;

import flash.utils.Dictionary;

public class LocaleVO {

    public static const DICT: Dictionary = new Dictionary();

    public var id: String;
    public var russian: String;

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var source: Object = data[i];
            var object: LocaleVO = fill(new LocaleVO(), source);
            DICT[object.id] = object;
        }
    }



    public static function fill($target : LocaleVO, $source : Object) : LocaleVO {

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
}
}
