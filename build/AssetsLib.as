/**
 * Created by mor on 01.12.2014.
 */
package {
import flash.display.Sprite;
import flash.system.Security;
import flash.system.System;

public class AssetsLib extends Sprite
{

    [Embed(source="./textures/gui/gui.xml",mimeType="application/octet-stream")]
    public static const guixml:Class;

    [Embed(source="./textures/gui/gui.png")]
    public static const gui:Class;

    [Embed(source="./textures/fonts/impact_21.xml",mimeType="application/octet-stream")]
    public static const impact_21xml:Class;

    [Embed(source="./textures/fonts/impact_49.xml",mimeType="application/octet-stream")]
    public static const impact_49xml:Class;


    [Embed(source="./config/guiConfig.json",mimeType="application/octet-stream")]
    public static const guiConfig:Class;

    [Embed(source="./config/config/drop.json",mimeType="application/octet-stream")]
    public static const drop:Class;

    [Embed(source="./config/config/extension.json",mimeType="application/octet-stream")]
    public static const extension:Class;

    [Embed(source="./config/config/gold_drop.json",mimeType="application/octet-stream")]
    public static const gold_drop:Class;

    [Embed(source="./config/config/item.json",mimeType="application/octet-stream")]
    public static const item:Class;

    [Embed(source="./config/config/item_slot.json",mimeType="application/octet-stream")]
    public static const item_slot:Class;

    [Embed(source="./config/config/item_type.json",mimeType="application/octet-stream")]
    public static const item_type:Class;

    [Embed(source="./config/config/league.json",mimeType="application/octet-stream")]
    public static const league:Class;

    [Embed(source="./config/config/levels.json",mimeType="application/octet-stream")]
    public static const levels:Class;

    [Embed(source="./config/config/locale.json",mimeType="application/octet-stream")]
    public static const locale:Class;

    [Embed(source="./config/config/magic_type.json",mimeType="application/octet-stream")]
    public static const magic_type:Class;

    [Embed(source="./config/config/monster.json",mimeType="application/octet-stream")]
    public static const monster:Class;

    [Embed(source="./config/config/monster_area.json",mimeType="application/octet-stream")]
    public static const monster_area:Class;

    [Embed(source="./config/config/player_items.json",mimeType="application/octet-stream")]
    public static const player_items:Class;

    [Embed(source="./config/config/player_pets.json",mimeType="application/octet-stream")]
    public static const player_pets:Class;

    [Embed(source="./config/config/pricelist.json",mimeType="application/octet-stream")]
    public static const pricelist:Class;

    [Embed(source="./config/config/settings.json",mimeType="application/octet-stream")]
    public static const settings:Class;

    [Embed(source="./config/config/skills.json",mimeType="application/octet-stream")]
    public static const skills:Class;

    [Embed(source="./config/config/trap.json",mimeType="application/octet-stream")]
    public static const trap:Class;

//    [Embed(source="./assets/config/")]
//    public static const :Class;







    public function AssetsLib()
    {
        super();
        Security.allowDomain("*");

    }
}
}
