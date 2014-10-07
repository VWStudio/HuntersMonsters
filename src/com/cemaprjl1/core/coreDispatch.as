package com.cemaprjl1.core {
/**
 * @author mor
 */
public function coreDispatch($event:String, ...rest):void {
    rest.unshift($event);
    Core.instance.dispatch.apply(Core.instance, rest);
}
}
