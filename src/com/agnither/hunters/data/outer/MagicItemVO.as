/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.data.outer {
import com.agnither.hunters.data.inner.ItemVO;

import flash.utils.Dictionary;

public class MagicItemVO extends ItemVO {

    public static const LIST: Vector.<MagicItemVO> = new <MagicItemVO>[];
    public static const DICT: Dictionary = new Dictionary();

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];

            var object: MagicItemVO = new MagicItemVO();
            object.id = row.id;
            object.name = row.name;
            object.picture = row.picture;
            object.type = row.type;
            object.action = row.action;

            LIST.push(object);
            DICT[object.id] = object;
        }
    }

    public var type: int;
    public var action: String;
}
}