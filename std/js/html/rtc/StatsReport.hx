/*
 * Copyright (C)2005-2016 Haxe Foundation
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

// This file is generated from mozilla\RTCStatsReport.webidl. Do not edit!

package js.html.rtc;

/**
	WebRTC provides a method—`RTCPeerConnection.getStats()`—which returns a set of statistics about the state of the connection and the data transfers which have taken place. This status report is an object of type `RTCStatsReport`, and consists of a mapping of strings identifying objects which have had statistics recorded and a dictionary containing all of the corresponding data. 

	@see <https://developer.mozilla.org/en-US/docs/Web/API/RTCStatsReport> 
**/
@:native("RTCStatsReport")
extern class StatsReport
{
	function forEach( callbackFn : StatsReport -> Void, ?thisArg : Dynamic ) : Void;
	function get( key : String ) : Dynamic;
	function has( key : String ) : Bool;
}