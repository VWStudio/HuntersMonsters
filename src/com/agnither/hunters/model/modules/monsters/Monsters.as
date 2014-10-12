/**
 * Created by mor on 11.10.2014.
 */
package com.agnither.hunters.model.modules.monsters {
public class Monsters {
    public function Monsters() {
    }

    public function getRandomMonster() : MonsterVO {
        return getMonster(MonsterVO.LIST[int(MonsterVO.LIST.length * Math.random())].id);
    }

    public function getMonster($id : String, $fillObj : Object = null) : MonsterVO {

        var monster : MonsterVO = MonsterVO.DICT[$id];
        if (!monster)
        {
            return null;
        }
        if ($fillObj)
        {
            return MonsterVO.fill(monster.clone(), $fillObj);
        }
        return monster.clone();
    }

}
}
