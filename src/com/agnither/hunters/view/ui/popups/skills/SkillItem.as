/**
 * Created by mor on 23.09.2014.
 */
package com.agnither.hunters.view.ui.popups.skills {
import com.agnither.hunters.data.outer.MagicTypeVO;
import com.agnither.hunters.data.outer.DamageTypeVO;
import com.agnither.hunters.data.outer.SkillVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.modules.locale.Locale;
import com.agnither.hunters.model.modules.monsters.MonsterVO;
import com.agnither.ui.AbstractView;
import com.cemaprjl.viewmanage.ShowPopupCmd;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.display.Image;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.ColorMatrixFilter;

import starling.text.TextField;

public class SkillItem extends AbstractView {
    private var _points : TextField;
    private var _icon : Image;
    private var _back : Image;
    private var _skill : SkillVO;
    private var isAllowedToIncrease : Boolean = false;
    private var isLevelEnough : Boolean = false;
    private var _disabled : Image;
    private var isNotMax : Boolean = true;
    public function SkillItem() {
        super();
    }


    override protected function initialize() : void {

        createFromConfig(_refs.guiConfig.common.skillItem);

        _icon = _links["bitmap_out_2.png"];
        _icon.touchable = false;
        _back = _links["bitmap_hitrect"];
        _disabled = _links["bitmap_disabled_tint"];
        _disabled.touchable = false;
        _disabled.visible = false;
        _points = _links["points_tf"];
        _points.touchable = false;

        _back.touchable = true;
        _back.addEventListener(TouchEvent.TOUCH, onTouch);
        
    }


    override public function update() : void {


        var owned : Number = Model.instance.progress.getSkillValue(_skill.id.toString());


        isLevelEnough = _skill.unlocklevel <= Model.instance.progress.level;
        isNotMax = owned < _skill.points;
        isAllowedToIncrease = Model.instance.progress.skillPoints > 0 && isLevelEnough && isNotMax;
        _points.text = owned + "/" + _skill.points + (isAllowedToIncrease ? "(+)" :"");
        _disabled.visible = !isLevelEnough;
        _back.visible = isLevelEnough;


    }

    public function setSkill($skill : SkillVO):void {
        _skill = $skill;
    }

    private function onTouch(e : TouchEvent) : void {
        e.stopImmediatePropagation();
        e.stopPropagation();
        var touch : Touch = e.getTouch(_back);
        if(touch)
        {
            Mouse.cursor = isAllowedToIncrease ? MouseCursor.BUTTON : MouseCursor.AUTO;
            switch (touch.phase)
            {
                case TouchPhase.HOVER :
                    break;
                case TouchPhase.BEGAN :
                    break;
                case TouchPhase.ENDED :
                    Model.instance.progress.incSkill(_skill.id.toString());
                    break;
            }
        } else
        {
            Mouse.cursor = MouseCursor.AUTO;
        }


    }
}
}
