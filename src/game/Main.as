package game {
import com.agnither.hunters.App;

//import flash.display.Bitmap;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import starling.core.Starling;

[SWF(frameRate="60", width="1000", height="720", backgroundColor="#000000")]
public class Main extends Sprite {

//    [Embed(source="gui.png")]
//    public var gui : Class;
//
//    [Embed(source="gui.png")]
//    public var gui1 : Class;

    private var viewPort: Rectangle;

    private var _starling: Starling;
//    private var _gui : Bitmap;

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function handleAddedToStage(event: Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

        Starling.handleLostContext = true;

//        _gui = new gui as Bitmap;

        var deviceSize: Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);

        _starling = new Starling(App, stage, deviceSize, null, "auto", "auto");
        _starling.antiAliasing = 0;
        _starling.stage.stageWidth = deviceSize.width;
        _starling.stage.stageHeight = deviceSize.height;
        _starling.showStatsAt("right", "bottom");
        _starling.simulateMultitouch = false;
        _starling.enableErrorChecking = Capabilities.isDebugger;
        _starling.start();
    }
}
}
