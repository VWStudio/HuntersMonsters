/**
 * Created by mor on 23.11.2014.
 */
package com.agnither.hunters.model.modules.extensions
{
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.hunters.model.player.inventory.Item;

public class PetExt extends Extension
{

    public static const TYPE : String = "monster";
    private var _monster : MonsterVO;
    private var _monsterID : String;
    private var _monsterLevel : Number = 1;

    public function PetExt($args : Array)
    {
        super($args);

    }


    override protected function fill() : void
    {
        _monsterID = _extArguments[0];
        _monsterLevel = _extArguments[1] ? _extArguments[1] : 1;
        _monster = MonsterVO.DICT[_monsterID][_monsterLevel];
    }


    override public function toObject() : Object
    {
//        var obj : Object = {};
//        obj[TYPE] = _hpPercent;
        return _monsterID;
    }

    public function getMonster() : MonsterVO
    {
        return _monster;
    }

    override public function getBaseValue() : Number
    {
        return _monster.damage;
    }

    override public function getDescription() : String
    {
        var description : String = super.getDescription() + ", "
                                   +Locale.getString(_monsterID);


        return description;
    }

}
}
