/**
 * Created by mor on 23.09.2014.
 */
package com.agnither.hunters.view.ui.popups.skills
{
import com.agnither.hunters.data.outer.SkillVO;
import com.agnither.hunters.model.Model;
import com.agnither.ui.AbstractView;
import com.cemaprjl.core.coreDispatch;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.display.Image;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class SkillItem extends AbstractView
{
    private var _points : TextField;
    private var _icon : Image;
    private var _back : Image;
    private var _skill : SkillVO;
    private var isAllowedToIncrease : Boolean = false;
    private var isLevelEnough : Boolean = false;
    private var _disabled : Image;
    private var isNotMax : Boolean = true;
    public static const HOVER : String = "SkillItem.HOVER";
    public static const HOVER_OUT : String = "SkillItem.HOVER_OUT";

    public function SkillItem()
    {
        super();
        createFromConfig(_refs.guiConfig.common.skillItem);
        handleFirstRun(null);
    }


    override protected function initialize() : void
    {

        _icon = _links["bitmap_drop_magic"];
        _icon.touchable = false;
        _back = _links["bitmap_common_hitrect"];
        _disabled = _links["bitmap_common_disabled_tint"];
        _disabled.touchable = true;
        _disabled.visible = false;
        _points = _links["points_tf"];
        _points.touchable = false;

        _back.touchable = true;
        _back.addEventListener(TouchEvent.TOUCH, onTouch);

        _disabled.addEventListener(TouchEvent.TOUCH, onDisabledTouch);

    }

    private function onDisabledTouch(event : TouchEvent) : void
    {
        var touch : Touch = event.getTouch(_disabled);
        if (touch)
        {
            coreDispatch(SkillItem.HOVER, this);
        }
        else {
            coreDispatch(SkillItem.HOVER_OUT);
        }
    }


    override public function update() : void
    {


        var owned : Number = Model.instance.progress.getSkillValue(_skill.id.toString());


        isLevelEnough = _skill.unlocklevel <= Model.instance.progress.level;
        isNotMax = owned < _skill.points;
        isAllowedToIncrease = Model.instance.progress.skillPoints > 0 && isLevelEnough && isNotMax;
        _points.text = owned + "/" + _skill.points + (isAllowedToIncrease ? "(+)" : "");
        _disabled.visible = !isLevelEnough;
        _back.visible = isLevelEnough;


        _icon.texture = _refs.gui.getTexture(_skill.icon);
        _icon.readjustSize();
        _icon.height = 50;
        _icon.scaleX = _icon.scaleY;

    }

    public function setSkill($skill : SkillVO) : void
    {
        _skill = $skill;
    }

    private function onTouch(e : TouchEvent) : void
    {
        if (!isAllowedToIncrease)
        {
            return;
        }
        e.stopImmediatePropagation();
        e.stopPropagation();
        var touch : Touch = e.getTouch(_back);
        if (touch)
        {
            Mouse.cursor = isAllowedToIncrease ? MouseCursor.BUTTON : MouseCursor.AUTO;
            switch (touch.phase)
            {
                case TouchPhase.HOVER :
                    coreDispatch(SkillItem.HOVER, this);
                    break;
                case TouchPhase.BEGAN :
                    break;
                case TouchPhase.ENDED :
                    Model.instance.progress.incSkill(_skill.id.toString());
                    break;
            }
        }
        else
        {
            coreDispatch(SkillItem.HOVER, this);
            Mouse.cursor = MouseCursor.AUTO;

        }


    }

    public function get skill() : SkillVO
    {
        return _skill;
    }
}
}
