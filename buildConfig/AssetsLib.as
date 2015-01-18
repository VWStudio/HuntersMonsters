/**
 * Created by mor on 01.12.2014.
 */
package {
import flash.display.Sprite;
import flash.system.Security;
import flash.system.System;

public class AssetsLib extends Sprite
{

    [Embed(source="textures/gui/gui.xml",mimeType="application/octet-stream")]
    public static const guixml:Class;

    [Embed(source="textures/gui/gui.png")]
    public static const gui:Class;

    [Embed(source="textures/fonts/impact_21.xml",mimeType="application/octet-stream")]
    public static const impact_21xml:Class;

    [Embed(source="textures/fonts/impact_49.xml",mimeType="application/octet-stream")]
    public static const impact_49xml:Class;

    [Embed(source="textures/fonts/calibri_r_15.xml",mimeType="application/octet-stream")]
    public static const calibri_r_15xml:Class;

    [Embed(source="config/guiConfig.json",mimeType="application/octet-stream")]
    public static const guiConfig:Class;

    [Embed(source="config/gameConfig.json",mimeType="application/octet-stream")]
    public static const gameConfig:Class;

    public function AssetsLib()
    {
        super();
        Security.allowDomain("*");

    }
}
}
