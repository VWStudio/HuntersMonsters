package com.cemaprjl.core {
/**
 * @author mor
 */
public function coreExecute($class:Class, ...args):void {
    var command:ICommand = new $class();
    command.execute.apply(this, args);
}
}
