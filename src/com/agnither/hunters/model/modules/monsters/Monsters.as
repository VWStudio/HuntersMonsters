/**
 * Created by mor on 11.10.2014.
 */
package com.agnither.hunters.model.modules.monsters {
import flash.utils.Dictionary;

public class Monsters {
    public function Monsters() {
    }

    public function getRandomAreaMonster($area : String) : MonsterVO {
        var monsters : Vector.<MonsterVO> = MonsterVO.DICT_BY_TYPE[$area];
        return monsters[int(monsters.length * Math.random())].clone();
    }
    public function getRandomMonster() : MonsterVO {
        return MonsterVO.LIST[int(MonsterVO.LIST.length * Math.random())].clone();
    }

    public function getMonsterArea($id : String) : MonsterAreaVO {
        return MonsterAreaVO.DICT[$id];
    }
    public function getMonster($id : String, $level : int, $fillObj : Object = null) : MonsterVO {

        var monsters : Dictionary = MonsterVO.DICT[$id];
        var monster : MonsterVO = monsters[$level];
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

    public function getNextArea($id : String) : MonsterAreaVO {
        var monstersList : Vector.<MonsterAreaVO> = MonsterAreaVO.LIST;
        var next : Boolean = false;
        for (var i : int = 0; i < monstersList.length; i++)
        {
            var vo : MonsterAreaVO = monstersList[i];
            if(next) {
                return vo;
            }
            if(vo.id == $id) {
                next = true;
            }
        }
        return null;
    }
}
}
