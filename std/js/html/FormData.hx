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

// This file is generated from mozilla\FormData.webidl line 16:0. Do not edit!

package js.html;

@:native("FormData")
extern class FormData
{
	/** @throws DOMError */
	function new( ?form : FormElement ) : Void;
	/** @throws DOMError */
	@:overload( function( name : String, value : Blob, ?filename : String ) : Void {} )
	function append( name : String, value : String ) : Void;
	@:native("delete")
	function delete_( name : String ) : Void;
	function get( name : String ) : haxe.extern.EitherType<Blob,String>;
	function getAll( name : String ) : Array<haxe.extern.EitherType<Blob,String>>;
	function has( name : String ) : Bool;
	/** @throws DOMError */
	@:overload( function( name : String, value : Blob, ?filename : String ) : Void {} )
	function set( name : String, value : String ) : Void;
	/** @throws DOMError */
	function entries() : FormDataIterator;
	/** @throws DOMError */
	function keys() : FormDataIterator;
	/** @throws DOMError */
	function values() : FormDataIterator;
	/** @throws DOMError */
	function forEach( callback : Dynamic, ?thisArg : Dynamic ) : Void;
}