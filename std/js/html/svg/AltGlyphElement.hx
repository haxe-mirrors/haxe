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

// This file is generated from mozilla\SVGAltGlyphElement.webidl. Do not edit!

package js.html.svg;

/**
	   

	@see <https://developer.mozilla.org/en-US/docs/Web/API/SVGAltGlyphElement> 
**/
@:native("SVGAltGlyphElement")
extern class AltGlyphElement extends TextPositioningElement
{
	
	/**
		It corresponds to the attribute `glyphRef` on the given element. It's data type is 'String'. It defines the glyph identifier, whose format is dependent on the ‘format’ of the given font.
	**/
	var glyphRef : String;
	
	/**
		It corresponds to the attribute  `format` on the given element. It's data type is 'String'. This property specifies the format of the given font.
	**/
	var format : String;
	var href(default,null) : AnimatedString;
	
}