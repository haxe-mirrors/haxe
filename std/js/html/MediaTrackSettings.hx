/*
 * Copyright (C)2005-2018 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

// This file is generated from mozilla\MediaTrackSettings.webidl. Do not edit!

package js.html;

/**
	The `MediaTrackSettings` dictionary is used to return the current values configured for each of a `MediaStreamTrack`'s settings. These values will adhere as closely as possible to any constraints previously described using a `MediaTrackConstraints` object and set using `applyConstraints()`, and will adhere to the default constraints for any properties whose constraints haven't been changed, or whose customized constraints couldn't be matched.

	Documentation [MediaTrackSettings](https://developer.mozilla.org/en-US/docs/Web/API/MediaTrackSettings) by [Mozilla Contributors](https://developer.mozilla.org/en-US/docs/Web/API/MediaTrackSettings$history), licensed under [CC-BY-SA 2.5](https://creativecommons.org/licenses/by-sa/2.5/).

	@see <https://developer.mozilla.org/en-US/docs/Web/API/MediaTrackSettings>
**/
typedef MediaTrackSettings =
{
	@:optional var autoGainControl : Bool;
	@:optional var browserWindow : Int;
	@:optional var channelCount : Int;
	@:optional var deviceId : String;
	@:optional var echoCancellation : Bool;
	@:optional var facingMode : String;
	@:optional var frameRate : Float;
	@:optional var height : Int;
	@:optional var mediaSource : String;
	@:optional var noiseSuppression : Bool;
	@:optional var scrollWithPage : Bool;
	@:optional var viewportHeight : Int;
	@:optional var viewportOffsetX : Int;
	@:optional var viewportOffsetY : Int;
	@:optional var viewportWidth : Int;
	@:optional var width : Int;
}