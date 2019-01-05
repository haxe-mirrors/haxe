/*
 * Copyright (C)2005-2019 Haxe Foundation
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

// This file is generated from mozilla\HTMLTextAreaElement.webidl. Do not edit!

package js.html;

/**
	The `HTMLTextAreaElement` interface provides special properties and methods for manipulating the layout and presentation of `textarea` elements.

	Documentation [HTMLTextAreaElement](https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement) by [Mozilla Contributors](https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement$history), licensed under [CC-BY-SA 2.5](https://creativecommons.org/licenses/by-sa/2.5/).

	@see <https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement>
**/
@:native("HTMLTextAreaElement")
extern class TextAreaElement extends Element
{
	var autocomplete : String;
	var autofocus : Bool;
	var cols : Int;
	var disabled : Bool;
	var form(default,null) : FormElement;
	var maxLength : Int;
	var minLength : Int;
	var name : String;
	var placeholder : String;
	var readOnly : Bool;
	var required : Bool;
	var rows : Int;
	var wrap : String;
	var type(default,null) : String;
	var defaultValue : String;
	var value : String;
	var textLength(default,null) : Int;
	var willValidate(default,null) : Bool;
	var validity(default,null) : ValidityState;
	var validationMessage(default,null) : String;
	var labels(default,null) : NodeList;
	var selectionStart : Int;
	var selectionEnd : Int;
	var selectionDirection : String;
	
	function checkValidity() : Bool;
	function reportValidity() : Bool;
	function setCustomValidity( error : String ) : Void;
	function select() : Void;
	/** @throws DOMError */
	@:overload( function( replacement : String ) : Void {} )
	function setRangeText( replacement : String, start : Int, end : Int, ?selectionMode : SelectionMode = "preserve" ) : Void;
	/** @throws DOMError */
	function setSelectionRange( start : Int, end : Int, ?direction : String ) : Void;
}