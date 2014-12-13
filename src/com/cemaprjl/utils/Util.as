/**
 * Created by mor on 16.10.2014.
 */
package com.cemaprjl.utils {
public class Util {

    public static function toObj($val : Object) : Object {
        return JSON.parse(JSON.stringify($val));
    }

    public static function uniq($id : String) : String {
        return $id + "." + (new Date()).time;

    }

    public static function getIndexOfRandom($chances : Array, $sum : Number) : int
    {
        var rand : Number = Math.random() * $sum;
        var index : int = 0;
        while(rand > $chances[index]) {
            rand -= $chances[index];
            index++;
        }
        return index;
    }

    public static function getRandomParam(pMin : Number, pAverage : Number, pMax : Number):Number
    {
        if (pMin < 1) {
            pMin = 1;
        }
        if (pAverage < 1) {
            pAverage = 1;
        }
        if (pMax < 1) {
            pMax = 1;
        }
        var pFactor : Number = 0.1;
        if(pMax == pMin) { //avoud of divide by zero
            pFactor = 0.1;
        } else {
            pFactor = (pAverage - pMin) / (pMax - pMin) - 0.1;
        }
        if (pFactor < 0.1 || !pFactor)
        {
            pFactor = 0.1;
        }

        var chance : Number = 2 / Math.pow(2, 6 * Math.random() + 1) ;
        var pSpread : Number = pMax - pMin;

        var p : Number;
        if (Math.random() < pFactor) {
            p = pSpread * pFactor * -chance;
        }
        else {
            p = (pSpread - (pSpread * pFactor)) * chance;
        }
        return pMin + (pSpread * pFactor) + p;
    }



}
}
