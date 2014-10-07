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
import com.agnither.ui.Popup;
import com.cemaprjl.core.ICommand;
import com.cemaprjl.core.coreDispatch;

/**
 * run example:
 * coreExecute(ShowPopupCmd, SomePopup.NAME, {id:123, name:"zzzz", true});
 * 1st param - this command class
 * 2nd - popup name
 * 3rd - object, that will be sent to setData() function of popup
 * 4th - shoud we close other popups
 *
 */
public class ShowPopupCmd implements ICommand {

    public function execute(...rest) : void {

        var popupName : String = rest[0];
        var av : AbstractView = ViewFactory.getView(popupName);
        var view : Popup = av as Popup;

        if(!view) {
            trace(popupName, av, view);
            trace("view is not Popup");
            return;
        }


        if (rest[1] != null)
        {
            view.data = rest[1];
        }

        if (rest[2]) {
            view.darkened = rest[2]
        } else {
            view.darkened = true;
        }

        coreDispatch(UI.SHOW_POPUP, popupName);
    }
}
}
