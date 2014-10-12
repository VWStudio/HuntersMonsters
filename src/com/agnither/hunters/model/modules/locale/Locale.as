/**
 * Created by mor on 12.10.2014.
 */
package com.agnither.hunters.model.modules.locale {
import com.agnither.hunters.model.modules.locale.LocaleVO;

public class Locale {

    public static var current : String = "russian";

    public static function getString($id : String) : String {
        var lvo : LocaleVO = LocaleVO.DICT[$id];
        if(lvo && lvo[current]) {
            return lvo[current];
        }
        trace("NO LOCALE FOR: ", $id, current);
        return "";


    }


}
}
