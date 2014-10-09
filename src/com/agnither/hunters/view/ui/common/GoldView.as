/**
 * Created by agnither on 14.08.14.
 */
package com.agnither.hunters.view.ui.common {
import com.agnither.hunters.model.player.Mana;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class GoldView extends AbstractView {

    private var _value: TextField;

    public function GoldView() {
    }

    override protected function initialize():void {

        if(!_links["bitmap__bg"]) {
            createFromConfig(_refs.guiConfig.common.goldItem);
        }

        _value = _links.amount_tf;
    }


    override public function update() : void {

        _value.text = data.toString();

    }
}
}
