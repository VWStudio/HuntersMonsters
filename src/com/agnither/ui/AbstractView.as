/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 05.06.13
 * Time: 14:46
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.ui {
import com.agnither.hunters.App;
import com.agnither.utils.CommonRefs;

import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.getClassByAlias;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;

import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.VAlign;

public class AbstractView extends Sprite {

    protected var _refs: CommonRefs;
    private var _data: Object;
    protected var _links: Dictionary = new Dictionary();

    public function set data(val: Object):void {
            if (val != null)
            {
                _data = val;
            }
            else
            {
                _data = {};
            }
    }

    protected var _defaultPosition: Point;
    protected var _backSize: Rectangle;

    public function AbstractView() {
        _refs = App.instance.refs;
        addEventListener(Event.ADDED_TO_STAGE, handleFirstRun);
//        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
//        addEventListener(Event.ADDED_TO_STAGE, handleAdded);
//        addEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
    }

    private function handleFirstRun(event : Event) : void {
        removeEventListener(Event.ADDED_TO_STAGE, handleFirstRun);
//        addEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);

        initialize(); // runs only once to create contents
//        update(); // used to fill content by data
    }

//    private function handleRemoved(event: Event):void {
//        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
////        addEventListener(Event.ADDED_TO_STAGE, handleAdded);
////        close();
//    }
//    /*
//    runs second and future times, only updates content
//     */
//    private function handleAddedToStage(event: Event):void {
//        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
////        update();
//    }

//
//
//    public function open():void {
//    }
//
//    public function close():void {
//    }
    protected function initialize():void {
    }
    public function update() : void {
    }

//    protected function hide():void {
//        visible = false;
//    }
//    protected function show():void {
//        visible = true;
//    }

//    private function handleAdded(event: Event):void {
//        removeEventListener(Event.ADDED_TO_STAGE, handleAdded);
//        open();
//    }



    private function destroyContainer(container: Sprite):void {
        while (container.numChildren>0) {
            var child: DisplayObject = container.getChildAt(0);
            if (child is Sprite) {
                destroyContainer(child as Sprite);
            }
            container.removeChild(child, true);
        }
    }

    public function destroy():void {
        destroyContainer(this);
        _refs = null;
    }





    protected function addToContainer(texture: Texture, container: Sprite, x: int, y: int, scaleX: Number = 1, scaleY: Number = 1):void {
        var image: Image = new Image(texture);
        image.x = x;
        image.y = y;
        image.scaleX = scaleX;
        image.scaleY = scaleY;
        container.addChild(image);
    }

    public function createFromConfig(config: Object, container: Sprite = null):void {
        if (!container) {
            container = this;
            _defaultPosition = new Point(config.x, config.y);
        }

        container.x = config.x;
        container.y = config.y;

        var l: int = config.structure.length;
        for (var i:int = 0; i < l; i++) {
            var frames: Array = config.structure[i];
            var frL: int = frames.length;
            for (var j:int = 0; j < frL; j++) {
                var item: Object = frames[j];

                var view: DisplayObject = null;
                if (item.type == "bitmap") {
                    var texture: Texture = _refs.gui.getTexture(item.image);
                    view = texture ? new Image(texture) : new Image(Texture.fromColor(item.width, item.height, 0));
                    view.visible = Boolean(texture);
                    if (!texture) {
                        item.matrix = null;
                    }
                    if (view) {
                        view.touchable = false;
                    }
                } else if (item.type == "button") {
                    var images: Array = item.images;
                    var upTex : Texture = _refs.gui.getTexture(images[0]);
                    var hovTex : Texture = images.length > 1 ? _refs.gui.getTexture(images[1]) : upTex;
                    var downTex : Texture = images.length > 1 ?_refs.gui.getTexture( images[2]) : upTex;
                    var disTex : Texture = images.length > 1 ? _refs.gui.getTexture(images[3]) : upTex;


                    view = new ButtonContainer(upTex, hovTex, downTex, disTex);
//                    view = new ButtonContainer(_refs.gui.getTexture(images[0]), "", images.length>=2 ? _refs.gui.getTexture(images[1]) : null, images.length>=3 ? _refs.gui.getTexture(images[2]) : null);
                } else if (item.type == "text") {
                    if (item.name.search("_label")<0) {
                        view = new TextField(item.width, item.height, item.text, item.fontName, -1, 0xFFFFFF);
                        view.touchable = false;
                        (view as TextField).hAlign = item.align;
                        (view as TextField).autoScale = true;
                        (view as TextField).batchable = true;
                    } else {
                        link = item.name.replace("_label", "_btn");
                        btn = _links[link];
                        btn.textBounds = new Rectangle(item.x - btn.x, item.y - btn.y, item.width, item.height);
                        btn.fontName = item.fontName;
                        btn.fontSize = -1;
                        btn.fontColor = 0xFFFFFF;
                        btn.text = item.text;
                    }
                } else if (item.type == "movie clip") {
                    if (item.linkage) {
                        var ViewClass:Class = getClassByAlias(item.linkage);
                        view = new ViewClass();
                        (view as AbstractView).createFromConfig(item);
                    } else {
                        view = new Sprite();
                        createFromConfig(item, view as Sprite);
                    }
                    if (item.name && item.name.search("_ico")>=0) {
                        var link: String = item.name.replace("_ico", "_btn");
                        var btn: ButtonContainer = _links[link] as ButtonContainer;
                        if (btn) {
                            btn.icon = view as Sprite;
                        }
                    }
                }
                if (view) {
                    view.x = item.x;
                    view.y = item.y;
//                    if(item.name == "bitmap__bg" || item.name == "spell") {
//                        trace(view, item.matrix, JSON.stringify(item));
//                    }

                    /**
                     * TODO some elements are not affected by matrix, FIX!!!
                     */

                    if (item.matrix) {
                        view.transformationMatrix = new Matrix(item.matrix.a, item.matrix.b, item.matrix.c, item.matrix.d, item.matrix.tx, item.matrix.ty);
                    }
                    container.addChild(view);
                    if (item.name) {
                        if (item.name == "back") {
                            _backSize = new Rectangle(item.x, item.y, item.width, item.height);
                        }

                        view.name = item.name;
                        _links[item.name] = view;
                    }
                }

            }
        }
    }

    public function createFromCommon(config: Object):void {
        var l: int = config.structure.length;
        for (var i:int = 0; i < l; i++) {
            var frames: Array = config.structure[i];
            var frL: int = frames.length;
            for (var j:int = 0; j < frL; j++) {
                var item: Object = frames[j];

                var view: DisplayObject = null;
                if (item.type == "bitmap") {
                    var texture: Texture = _refs.gui.getTexture(item.image);
                    view = texture ? new Image(texture) : new Image(Texture.fromColor(item.width, item.height, 0));
                    view.visible = Boolean(texture);
                    if (!texture) {
                        item.matrix = null;
                    }
                    if (view) {
                        view.touchable = false;
                    }
                } else if (item.type == "button") {
                    var images: Array = item.images;

                    var upTex : Texture = _refs.gui.getTexture(images[0]);
                    var hovTex : Texture = images.length > 1 ? _refs.gui.getTexture(images[1]) : upTex;
                    var downTex : Texture = images.length > 1 ?_refs.gui.getTexture( images[2]) : upTex;
                    var disTex : Texture = images.length > 1 ? _refs.gui.getTexture(images[3]) : upTex;

                    view = new ButtonContainer(upTex, hovTex, downTex, disTex);
//                    view = new ButtonContainer(_refs.gui.getTexture(images[0]), "", images.length>=2 ? _refs.gui.getTexture(images[1]) : null, images.length>=3 ? _refs.gui.getTexture(images[2]) : null);
                } else if (item.type == "text") {
                    if (item.name.search("_label")<0) {
                        view = new TextField(item.width, item.height, item.text, item.fontName, -1, 0xFFFFFF);
                        view.touchable = false;
                        (view as TextField).hAlign = item.align;
//                        (view as TextField).vAlign = VAlign.TOP;
                        (view as TextField).autoScale = true;
                        (view as TextField).batchable = true;
                    } else {
                        link = item.name.replace("_label", "_btn");
                        btn = _links[link];
                        if (btn) {
                            btn.textBounds = new Rectangle(item.x - btn.x, item.y - btn.y, item.width, item.height);
                            btn.fontName = item.fontName;
                            btn.fontSize = -1;
                            btn.fontColor = 0xFFFFFF;
                            btn.text = item.text;
                        }
                    }
                } else if (item.type == "movie clip") {
                    if (item.linkage) {
                        var ViewClass:Class = getClassByAlias(item.linkage);
                        view = new ViewClass();
//                        view = new ViewClass(_refs);
                        (view as AbstractView).createFromConfig(item);
                    } else {
                        view = new Sprite();
                        createFromConfig(item, view as Sprite);
                    }
                    if (item.name && item.name.search("_ico")>=0) {
                        var link: String = item.name.replace("_ico", "_btn");
                        var btn: ButtonContainer = _links[link] as ButtonContainer;
                        if (btn) {
                            btn.icon = view as Sprite;
                        }
                    }
                }
                if (view) {
                    view.x = item.x;
                    view.y = item.y;
                    addChild(view);
                    if (item.name) {
                        _links[item.name] = view;
                    }
                }
            }
        }
    }

    public function get data() : Object {
        return _data;
    }

    public function onRemove() : void {

    }
}
}