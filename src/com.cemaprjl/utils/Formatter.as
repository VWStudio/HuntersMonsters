/**
 * Created with IntelliJ IDEA.
 * User: lv
 * Date: 06.02.13
 * Time: 13:22
 * To change this template use File | Settings | File Templates.
 */
package com.cemaprjl.utils {
public class Formatter {

    public static function plural(count : Number, form1:String,  form2:String, form5:String):String {
        if((count %10 == 1) && (count % 100 != 11)) {
            return form1;
        } else if ((count %10 >=2) && (count % 10 <= 4) && ((count % 100 < 10) || (count % 100 >= 20))){
            return form2;
        }
        return form5;
    }

    public static function msToHHMMSS($val:Number):String {

        var date:Date = new Date();
        date.setTime($val);

        var time:String = date.toUTCString().split(" ")[3];

        var parts:Array = time.split(":");
        parts.reverse();

        var seconds:String = parts[0];
        var minutes:String = parts[1];
        var hours:String = parts[2];

        var str:String = minutes + ":" + seconds;
        if (int(hours) > 0) {
            str = hours + ":" + str;
        }

        return str;
    }

    public static function secToDD_HHMMSS($val:Number):String {
        var str:String = msToHHMMSS($val);

        var secInDays : int = 3600 * 24;
        var days:int = $val / secInDays;
        if (days > 0) {
            str = days + " д. " + str;
        }

        return str;
    }

    public static function secToWhen(val:Number):String {
        return Formatter.secToDate(val / 1000) + " в " + Formatter.msToHHMM(val / 1000);
    }
    public static function dateToWhen($data:String):String {

        var dateStr : String = $data + " UTC-0000";
        var date : Date = new Date(Date.parse(dateStr));
        return Formatter.secToDate(date.time / 1000) + " в " + Formatter.msToHHMM(date.time / 1000);

    }




    public static function secToDateHHMM($val:Number):String {
        return secToDate($val) +" " +msToHHMM($val);
    }
    public static function secToDate($val:Number):String {
        var date:Date = new Date();
        date.setTime($val * 1000);
        var parts :Array = date.toUTCString().split(" ");
//        var time:String = date.toUTCString().split(" ")[3];
        return parts[2]+" "+parts[1]+" "+parts[4]
    }

    public static function msToHHMM($val:Number):String {
        var date:Date = new Date();
        date.setTime($val);
        var parts :Array = date.toUTCString().split(" ");

        var timeParts : Array = parts[3].toString().split(":");

        return timeParts[0] + ":" + timeParts[1];
    }

    public static function intToRanges($str : String) : String {
        return $str.replace(/(\d)(?=(\d{3})+$)/gmi, "$1 ");
//        return $str.replace(/(\d)(?=(\d{3})+$)/gmi, "$1.");
    }

    public static function intShortener($amount : Number) : String {
        if(isNaN($amount)) {
            $amount = 0;
        }
        var strArr : Array = intToRanges($amount.toString()).split(" ");
        var postfix : String = "";
        if(strArr.length > 1 && $amount.toString().length > 5) {
            postfix = ","+(strArr.pop() as String).substr(0,1)+"K";
            if(strArr.length > 1 && strArr.join().length > 5) {
                postfix = ","+(strArr.pop() as String).substr(0,1)+"M";
//                if(strArr.length > 1 && strArr.join().length > 5) {
//                    postfix = ","+(strArr.pop() as String).substr(0,1)+"B"
//                }
            }
        }
        return strArr.join(" ") + postfix;
    }
}
}
