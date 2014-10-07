/**
 * Created with IntelliJ IDEA.
 * User: lv
 * Date: 21.03.13
 * Time: 11:07
 * To change this template use File | Settings | File Templates.
 */
package com.cemaprjl.viewmanage {
import com.agnither.hunters.view.ui.UI;
import com.agnither.ui.AbstractView;
import com.cemaprjl.core.ICommand;
import com.cemaprjl.core.coreDispatch;

public class ShowScreenCmd implements ICommand {

    public function execute(...rest) : void {


        var viewName : String = rest[0];

        var view : AbstractView = ViewFactory.getView(viewName);
        if (rest[1])
        {
            view.data = (rest[1]);
        }

        coreDispatch(UI.SHOW_SCREEN, viewName);
    }
}
}
