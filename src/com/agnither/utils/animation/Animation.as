/**
 * Created by agnither on 07.08.14.
 */
package com.agnither.utils.animation {
import flash.utils.Dictionary;

import starling.animation.IAnimatable;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureAtlas;

public class Animation extends Sprite implements IAnimatable {

    public static const COMPLETE: String = "complete_Animation";

    private static var animations: Dictionary = new Dictionary();
    public static function registerAnimation(name: String, data: Object, atlas: TextureAtlas):void {
        var states: Dictionary = new Dictionary();
        animations[name] = states;

        var l: int = data.length;
        var lastFrameLabel: String;
        for (var i:int = 0; i < l; i++) {
            var frameData: Object = data[i];
            var frameLabel: String = frameData.frame;
            var link: String = null;
            if (frameLabel.charAt(0) == "#") {
                link = frameLabel.replace("#", "");
                frameLabel = lastFrameLabel;
            }
            lastFrameLabel = frameLabel;

            if (!states[frameLabel]) {
                states[frameLabel] = new <Frame>[];
            }

            var frame: Frame = new Frame();
            frame.x = frameData.x;
            frame.y = frameData.y;
            frame.texture = atlas.getTexture(frameData.name);
            frame.link = link;
            states[frameLabel].push(frame);
        }
    }
    public static function getAnimation(name: String, frameRate: int = 24):Animation {
        return new Animation(animations[name], frameRate);
    }

    private var _loops: Dictionary;
    private var _states: Dictionary;

    private var _currentState: String;
    public function get currentState():Vector.<Frame> {
        return _states[_currentState];
    }

    private var _currentFrame: Number;
    public function get currentFrame():Frame {
        return currentState && currentState.length > _currentFrame ? currentState[int(_currentFrame)] : null;
    }

    private var _viewport: Image;

    private var _playing: Boolean;

    private var _frameRate: int;
    public function set frameRate(value: int):void {
        _frameRate = value;
    }

    private var _timeScale: Number = 1;
    public function set timeScale(value: Number):void {
        _timeScale = value;
    }

    public function Animation(states: Dictionary, framerate: int = 24) {
        _states = states;
        _frameRate = framerate;

        _loops = new Dictionary();
    }

    public function setLoop(state: String, loop: Boolean):void {
        _loops[state] = loop;
    }

    public function gotoAndPlay(state: String):void {
        _currentState = state;
        _currentFrame = 0;

        play();
    }

    public function play():void {
        _playing = true;
        updateTexture(currentFrame);
    }

    public function gotoAndStop(state: String):void {
        _currentState = state;
        _currentFrame = 0;

        stop();
    }

    public function previousFrame():void {
        _currentFrame--;
        updateTexture(currentFrame);
    }

    public function stop():void {
        _playing = false;
        updateTexture(currentFrame);
    }

    public function advanceTime(time: Number):void {
        if (_playing) {
            var frameTime: Number = 1 / _frameRate / _timeScale;
            nextFrame(time / frameTime);
        }
    }



    private function nextFrame(delta: Number):void {
        if (currentFrame) {
            if (currentFrame.link) {
                gotoAndPlay(currentFrame.link);
            } else {
                _currentFrame += delta;
                if (currentFrame) {
                    updateTexture(currentFrame);
                } else if (_loops[_currentState]) {
                    gotoAndPlay(_currentState);
                } else {
                    dispatchEventWith(COMPLETE);
                }
            }
        }
    }

    private function updateTexture(frame: Frame):void {
        if (!frame && _viewport) {
            _viewport.visible = false;
            return;
        }

        if (!_viewport) {
            _viewport = new Image(frame.texture);
            addChild(_viewport);
        }
        _viewport.texture = frame.texture;
        _viewport.x = frame.x;
        _viewport.y = frame.y;
        _viewport.visible = true;
    }
}
}

import starling.textures.Texture;

class Frame {
    public var x: int;
    public var y: int;
    public var texture: Texture;
    public var link: String;
}
