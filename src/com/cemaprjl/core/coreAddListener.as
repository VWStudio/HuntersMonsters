package com.cemaprjl.core {
/**
 * @author mor
 */
public function coreAddListener($event:String, $func:Function):void {
    Core.instance.addListener($event, $func);
}
}
