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

package js.lib;

/**
	abstract over JavaScript iterator objects that enables haxe for-in iteration
**/
@:forward
abstract Iterator<T>(IteratorStructure<T>) from IteratorStructure<T> to IteratorStructure<T> {

	public inline function iterator(): JSIterator<T> {
		return new JSIterator<T>(this);
	}

}

typedef IteratorStructure<T> = {
	function next():IteratorStep<T>;
}

typedef IteratorStep<T> = {
	done:Bool,
	?value:T
}

/**
	JSIterator wraps a JavaScript iterator object in a class that haxe can iterate over
**/
class JSIterator<T> {

	final jsIterator: js.lib.IteratorStructure<T>;
	var lastStep: js.lib.Iterator.IteratorStep<T>;

	public inline function new(jsIterator: js.lib.IteratorStructure<T>) {
		this.jsIterator = jsIterator;
		lastStep = jsIterator.next();
	}

	public inline function hasNext(): Bool {
		return !lastStep.done;
	}

	public inline function next(): T {
		var v = lastStep.value;
		lastStep = jsIterator.next();
		return v;
	}

} 