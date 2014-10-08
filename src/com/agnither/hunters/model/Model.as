/**
 * Created by mor on 08.10.2014.
 */
package com.agnither.hunters.model {
import com.agnither.hunters.data.outer.MonsterVO;
import com.agnither.hunters.view.ui.screens.map.HousePoint;

import flash.utils.Dictionary;

public class Model {

    private static var _instance : Model;
    public var houses : Object = {};
    public var match3mode : String;
    public var currentHousePoint : HousePoint;
    public static function get instance() : Model {
        if (!_instance)
        {
            _instance = new Model();
        }
        return _instance;
    }


    public function getRandomMonster() : MonsterVO {
        return getMonster(MonsterVO.LIST[int(MonsterVO.LIST.length * Math.random())].id);
    }
    public function getMonster($id : String) : MonsterVO {

        var monster : MonsterVO = MonsterVO.DICT[$id];
        if(!monster) {
            return null;
        }
        return monster.clone();

    }
}
}
