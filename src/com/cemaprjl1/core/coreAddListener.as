package com.cemaprjl1.core {
/**
 * @author mor
 */
public function coreAddListener($event:String, $func:Function):void {
    Core.instance.addListener($event, $func);
}
}
