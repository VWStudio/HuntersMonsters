/**
 * Created with IntelliJ IDEA.
 * User: lv
 * Date: 04.02.13
 * Time: 10:47
 * To change this template use File | Settings | File Templates.
 */
package com.cemaprjl1.viewmanage {

import com.agnither.ui.AbstractView;

import flash.utils.Dictionary;

public class ViewFactory {


    private var _a : uint;

    private static var createdViews : Dictionary = new Dictionary();
    private static var views : Dictionary = new Dictionary();

    public static function getView($name : String) : AbstractView {
        if (!createdViews[$name])
        {
            createdViews[$name] = createView($name);
        }
        return createdViews[$name];
    }

    private static function createView($name : String) : AbstractView {
        if (!views[$name])
        {
            throw new Error("There is no View with \"" + $name + "\"");
            return null;
        }
        var viewClass : Class = views[$name];
        return new viewClass();
    }

    public static function add($name : String, $class : Class) : void {
        views[$name] = $class;
    }

}
}
