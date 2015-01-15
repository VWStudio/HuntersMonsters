/**
 * Created by mor on 23.11.2014.
 */
package com.agnither.hunters.model.modules.extensions
{
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.player.inventory.Item;

public class Extension
{
    protected var _extArguments : Array;


    public static const TYPE : String = "extension";
    protected var _initialArgs : Array;


    public static function create($type : String, $args : Array):Extension {
        switch ($type) {
            case DamageExt.TYPE:
                return new DamageExt($args);
                break;
            case DefenceExt.TYPE:
                return new DefenceExt($args);
                break;
            case ManaExt.TYPE:
                return new ManaExt($args);
                break;
            case DoubleDropExt.TYPE:
                return new DoubleDropExt($args);
                break;
            case MirrorDamageExt.TYPE:
                return new MirrorDamageExt($args);
                break;
            case ManaAddExt.TYPE:
                return new ManaAddExt($args);
                break;
            case SpellDefenceExt.TYPE:
                return new SpellDefenceExt($args);
                break;
            case ResurrectPetExt.TYPE:
                return new ResurrectPetExt($args);
                break;
            case PetExt.TYPE:
                return new PetExt($args);
                break;
            case IncHpExt.TYPE:
                return new IncHpExt($args);
                break;

            case IncDmgExt.TYPE:
                return new IncDmgExt($args);
                break;

            case DmgEnemyOnTurnExt.TYPE:
                return new DmgEnemyOnTurnExt($args);
                break;

            case MoveAgainExt.TYPE:
                return new MoveAgainExt($args);
                break;
        }
        return new Extension($args);



        /*
         if(extType == IncHpExt.TYPE) {
         incHpPercent = (item.getExtension(extType) as IncHpExt).percent;
         }
         if(extType == IncDmgExt.TYPE) {
         incDmgPercent = (item.getExtension(extType) as IncDmgExt).percent;
         }
         if(extType == DmgEnemyOnTurnExt.TYPE) {
         dealDmgOnMove = (item.getExtension(extType) as DmgEnemyOnTurnExt).amount;
         }
         if(extType == MoveAgainExt.TYPE) {

         moveAgainOn5 = true;
         }
         */

    }

    public function getRandomExtValue($min : Number, $max : Number, $factor : Number = 0.5):Number {
        var returnVal : Number = 0;
        var chance:Number = 2 / Math.pow(2, 6 * Math.random() + 1); //0-60%; 1-2%
        var pSpread:Number = $max - $min;
        if (Math.random() < $factor)
        {
            returnVal = pSpread * $factor * -chance;
        }
        else
        {
            returnVal = (pSpread - (pSpread * $factor)) * chance;
        }
        returnVal = $min + (pSpread * $factor) + returnVal;
        return returnVal;
    }

    protected function fill() :void {
    }

    public function updateItem($item : Item):void {

    }

    public function Extension($args : Array)
    {
        setArguments($args);
    }

    public function setArguments($args : Array) : void {
        _initialArgs = $args.slice();
        _extArguments = $args;
        fill();
    }

    public function toObject() : Object
    {
        return _extArguments;
    }

    public function getBaseValue() : Number
    {
        return 0;
    }

    public function getDescription():String {
        return Locale.getString((this as Object).constructor["TYPE"]);
    }

}
}
