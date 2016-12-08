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

// This file is generated from mozilla\MessageChannel.webidl. Do not edit!

package js.html;

/**
	The `MessageChannel` interface of the Channel Messaging API allows us to create a new message channel and send data through it via its two `MessagePort` properties. 

	@see <https://developer.mozilla.org/en-US/docs/Web/API/MessageChannel> 
**/
@:native("MessageChannel")
extern class MessageChannel
{
	
	/**
		Returns port1 of the channel.
	**/
	var port1(default,null) : MessagePort;
	
	/**
		Returns port2 of the channel.
	**/
	var port2(default,null) : MessagePort;
	
	/** @throws DOMError */
	function new() : Void;
}