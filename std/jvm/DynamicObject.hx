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

package jvm;

import haxe.ds.StringMap;

@:keep
@:native('haxe.jvm.DynamicObject')
@:nativeGen
class DynamicObject implements java.lang.Cloneable extends Object {
	static var __hx_toString_depth = 0;

	var _hx_fields:Null<StringMap<Dynamic>>;

	public var _hx_deletedAField:Null<Bool>;

	public function toString() {
		if (__hx_toString_depth >= 5) {
			return "...";
		}
		++__hx_toString_depth;
		_hx_initReflection();
		if (_hx_hasField("toString")) {
			--__hx_toString_depth;
			return _hx_getField("toString")();
		}
		var buf = new StringBuf();
		buf.addChar("{".code);
		var first = true;
		try {
			for (key in _hx_fields.keys()) {
				if (first)
					first = false
				else
					buf.add(", ");
				buf.add(key);
				buf.add(": ");
				buf.add(_hx_fields.get(key));
			}
		} catch (e:Dynamic) {
			--__hx_toString_depth;
			throw(e);
		}
		--__hx_toString_depth;
		buf.addChar("}".code);
		return buf.toString();
	}

	final public function _hx_deleteField(name:String) {
		_hx_initReflection();
		_hx_deletedAField = true;
		try {
			Jvm.writeFieldNoObject(this, name, null);
		} catch (_:Dynamic) {}
		return _hx_fields.remove(name);
	}

	final public function _hx_getFields() {
		_hx_initReflection();
		return [for (key in _hx_fields.keys()) key];
	}

	override public function _hx_getField<T>(name:String) {
		_hx_initReflection();
		return _hx_fields.get(name);
	}

	final public function _hx_hasField(name:String) {
		_hx_initReflection();
		return _hx_fields.exists(name);
	}

	override public function _hx_setField(name:String, value:Dynamic) {
		_hx_initReflection();
		_hx_fields.set(name, value);
	}

	final public function _hx_clone() {
		var clone:DynamicObject = (cast this : java.lang.Object).clone();
		if (_hx_fields != null) {
			clone._hx_fields = this._hx_fields.copy();
		}
		return clone;
	}

	final function _hx_initReflection() {
		if (_hx_fields == null) {
			_hx_fields = _hx_getKnownFields();
		}
	}

	function _hx_getKnownFields():StringMap<Dynamic> {
		return new StringMap();
	}
}
