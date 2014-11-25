/**
 * Created by mor on 25.11.2014.
 */
package com.agnither.hunters.view.ui.common
{
import com.agnither.ui.AbstractView;

import starling.text.TextField;

public class Tooltip extends AbstractView
{
    private var _tip : TextField;
    public function Tooltip()
    {
        super();
        createFromConfig(_refs.guiConfig.common.tooltip);

    }


    override protected function initialize() : void
    {
        _tip = _links.tip_tf

    }

    public function set text($val : String):void {
        _tip.text = $val;
    }


}
}
