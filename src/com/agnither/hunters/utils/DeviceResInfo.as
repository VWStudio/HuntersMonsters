/**
 * Created by agnither on 29.01.14.
 */
package com.agnither.hunters.utils {
import flash.display.Stage;

public class DeviceResInfo {

    public static function getInfo(stage: Stage):DeviceResInfo {
        var info: DeviceResInfo = new DeviceResInfo();
        stage.frameRate = info.frameRate;
        return info;
    }

    public var scaleFactor: Number = 1;
    public var frameRate: int = 60;
}
}
