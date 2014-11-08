/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.model.modules.players {
import com.agnither.hunters.model.modules.players.PersonageVO;

import flash.utils.Dictionary;

public class SettingsVO extends PersonageVO {

    public static const DICT: Object = {};

    public static function parseData(data: Object):void {
        for (var i: int = 0; i < data.length; i++) {
            var row: Object = data[i];
            switch(row.type) {
                case "array":
                    DICT[row.parameter] = row.value.split(",");
                    break;
                case "int":
                    DICT[row.parameter] = Number(row.value);
                    break;
                case "str":
                    DICT[row.parameter] = row.value.toString();
                    break;
            }
        }
    }
}
}
