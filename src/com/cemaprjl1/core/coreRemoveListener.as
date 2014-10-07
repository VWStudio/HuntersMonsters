package com.cemaprjl1.core {
    /**
     * @author mor
     */
    public function coreRemoveListener($event : String, $func : Function) : void {
        Core.instance.removeListener($event, $func);
    }
}
