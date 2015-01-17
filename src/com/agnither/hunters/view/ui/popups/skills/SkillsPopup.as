/**
 * Created by mor on 04.11.2014.
 */
package com.agnither.hunters.view.ui.popups.skills {
import com.agnither.hunters.data.outer.LevelVO;
import com.agnither.hunters.data.outer.SkillVO;
import com.agnither.hunters.model.Model;
import com.agnither.hunters.model.player.LocalPlayer;
import com.agnither.hunters.model.player.personage.Progress;
import com.agnither.hunters.view.ui.common.Tooltip;
import com.agnither.ui.Popup;
import com.cemaprjl.core.coreAddListener;

import flash.geom.Rectangle;

import starling.display.Image;

import starling.display.Sprite;

import starling.text.TextField;

public class SkillsPopup extends Popup {

    public static const NAME : String = "com.agnither.hunters.view.ui.popups.skills.SkillsPopup";
    private var _level : TextField;
    private var _exp : TextField;
    private var _hp : TextField;
    private var _summon : TextField;
    private var _skillPoints : TextField;
    //private var _level1tf : TextField;
    //private var _level2tf : TextField;
    //private var _level3tf : TextField;
    //private var _level4tf : TextField;
    private var _magic : Sprite;
    private var _level1 : Sprite;
    private var _level2 : Sprite;
    private var _level3 : Sprite;
    private var _level4 : Sprite;
    //private var _hero : Image;
    private var _tooltip : Tooltip;

    public function SkillsPopup() {
        super();
    }


    override protected function initialize() : void {
        createFromConfig(_refs.guiConfig.skills_popup);

        //_hero = _links["bitmap_hero.png"];

        handleCloseButton(_links["close_btn"]);

        _level = _links["level_tf"];
        _level.visible = false;
        _exp = _links["exp_tf"];
        _exp.visible = false;
        _hp = _links["hp_tf"];
        _hp.visible = false;
        _summon = _links["summon_tf"];
        _summon.visible = false;
        _skillPoints = _links["sp_tf"];
        //_level1tf = _links["level1_tf"];
        //_level2tf = _links["level2_tf"];
        //_level3tf = _links["level3_tf"];
        //_level4tf = _links["level4_tf"];

        _magic = new Sprite();
        addChild(_magic);
        _magic.x = _links["magic"].x;
        _magic.y = _links["magic"].y;

        _level1 = new Sprite();
        addChild(_level1);
        _level1.x = _links["level1"].x;
        _level1.y = _links["level1"].y;

        _level2 = new Sprite();
        addChild(_level2);
        _level2.x = _links["level2"].x;
        _level2.y = _links["level2"].y;

        _level3 = new Sprite();
        addChild(_level3);
        _level3.x = _links["level3"].x;
        _level3.y = _links["level3"].y;

        _level4 = new Sprite();
        addChild(_level4);
        _level4.x = _links["level4"].x;
        _level4.y = _links["level4"].y;

        this.removeChild(_links["magic"]);
        this.removeChild(_links["level1"]);
        this.removeChild(_links["level2"]);
        this.removeChild(_links["level3"]);
        this.removeChild(_links["level4"]);

        coreAddListener(Progress.UPDATED, update);


        _tooltip = new Tooltip();
        addChild(_tooltip);
        _tooltip.visible = false;

        coreAddListener(SkillItem.HOVER, onItemHover);
        coreAddListener(SkillItem.HOVER_OUT, onItemHoverOut);
    }

    private function onItemHoverOut() : void
    {
        trace(1);
        _tooltip.visible = false;
    }

    private function onItemHover($item : SkillItem) : void
    {
        if(!isActive) return;
        if($item) {
            var rect : Rectangle = $item.getBounds(this);
            _tooltip.x = rect.right;
            _tooltip.y = rect.bottom;
            var str : String = $item.skill.description;
            _tooltip.visible = str.length > 0;
            _tooltip.text = str;
        }
    }



    override public function update() : void {

         trace(SkillVO.LEVELS["1"]);

        var progress :  Progress = Model.instance.progress;
        var player :  LocalPlayer = Model.instance.player;


        _level.text = "Уровень: "+ progress.level.toString();
        _exp.text = "Опыт: "+progress.exp.toString() + "/" +LevelVO.DICT[progress.level.toString()].exp;
        _hp.text = "Здоровье:  "+progress.hp.toString() + "       (+10 за каждый новый уровень)";
        _summon.text = "Питомцы:  "+player.hero.maxSummon.toString();
        _skillPoints.text = "Очки навыков:  "+progress.skillPoints.toString();
        //_level1tf.text = "Уровень 1";
        //_level2tf.text = "Уровень 3";
        //_level3tf.text = "Уровень 7";
        //_level4tf.text = "Уровень 10";

        _level1.removeChildren();
        var arr : Array = SkillVO.LEVELS["1"];
        for (var i : int = 0; i < arr.length; i++)
        {
            var skill : SkillVO = arr[i];
            var skItem : SkillItem = new SkillItem();
            _level1.addChild(skItem);
            skItem.setSkill(skill);
            skItem.update();
            skItem.y = i * 42;
        }

        /*_level2.removeChildren();
        arr = SkillVO.LEVELS["3"];
        for (i = 0; i < arr.length; i++)
        {
            skill = arr[i];
            skItem = new SkillItem();
            _level2.addChild(skItem);
            skItem.setSkill(skill);
            skItem.update();
            skItem.x = i * 125;
        }

        _level3.removeChildren();
        arr = SkillVO.LEVELS["7"];
        for (i = 0; i < arr.length; i++)
        {
            skill = arr[i];
            skItem = new SkillItem();
            _level3.addChild(skItem);
            skItem.setSkill(skill);
            skItem.update();
            skItem.x = i * 125;
        }

        _level4.removeChildren();
        arr = SkillVO.LEVELS["10"];
        for (i = 0; i < arr.length; i++)
        {
            skill = arr[i];
            skItem = new SkillItem();
            _level4.addChild(skItem);
            skItem.setSkill(skill);
            skItem.update();
            skItem.x = i * 125;
        } */

    }
}
}
