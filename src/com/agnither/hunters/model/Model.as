/**
 * Created by mor on 08.10.2014.
 */
package com.agnither.hunters.model {
public class Model {

    private static var _instance : Model;
    public static function get instance() : Model {
        if (!_instance)
        {
            _instance = new Model();
        }
        return _instance;
    }






}
}
