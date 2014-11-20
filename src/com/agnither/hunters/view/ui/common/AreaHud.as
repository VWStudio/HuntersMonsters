/**
 * Created by mor on 16.11.2014.
 */
package com.agnither.hunters.view.ui.common
{
import com.agnither.ui.AbstractView;

import starling.display.Image;

public class AreaHud extends AbstractView
{

    private var _houseLocked : Image;
    private var _houseUnlocked : Image;
    private var _star1 : Image;
    private var _star2 : Image;
    private var _star3 : Image;
    private var _starsBack : Image;
    private var _isHouse : Boolean = false;
    private var _progress : int = 0;

    public function AreaHud()
    {
        super();
    }


    override protected function initialize() : void
    {
        for (var i : int = 0; i < numChildren; i++)
        {
            var image : Image = getChildAt(i) as Image;
            switch (image.name)
            {
                case "bitmap_map_hud_house1":
                    _houseUnlocked = image;
                    break;
                case "bitmap_map_hud_house0":
                    _houseLocked = image;
                    break;
                case "bitmap_map_hud_star1":
                    _star1 = image;
                    break;
                case "bitmap_map_hud_star2":
                    _star2 = image;
                    break;
                case "bitmap_map_hud_star3":
                    _star3 = image;
                    break;
                case "bitmap_map_hud_stars_back":
                    _starsBack = image;
                    break;
            }
        }
    }

    public function set isHouse($val : Boolean) : void
    {
        _isHouse = $val;
        update();
    }

    public function set progress($val : int) : void
    {
        var isOutOfBounds : Boolean = $val > 4 || $val < 0;
        _progress = isOutOfBounds ? 0 : $val;
        update();
    }

    override public function update() : void
    {
        _houseLocked.visible = _isHouse && _progress == 0;
        _houseUnlocked.visible = _isHouse && _progress > 0;
        _starsBack.visible = !_isHouse;
        _star1.visible = !_isHouse && _progress > 0;
        _star2.visible = !_isHouse && _progress > 1;
        _star3.visible = !_isHouse && _progress > 2;
    }

    public function get progress() : int
    {
        return _progress;
    }
}
}
