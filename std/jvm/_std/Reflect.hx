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

import jvm.Jvm;

@:coreApi
class Reflect {
	public static function hasField(o:Dynamic, field:String):Bool {
		if (!Jvm.instanceof(o, jvm.DynamicObject)) {
			var c:java.lang.Class<Dynamic> = Jvm.instanceof(o, java.lang.Class) ? cast o : (cast o : java.lang.Object).getClass();
			try {
				c.getField(field);
				return true;
			} catch (e:Dynamic) {
				return false;
			}
		}
		return (cast o : jvm.DynamicObject)._hx_hasField(field);
	}

	public static function field(o:Dynamic, field:String):Null<Dynamic> {
		if (o == null) {
			return null;
		}
		return Jvm.readField(o, field);
	}

	public static function setField(o:Dynamic, field:String, value:Dynamic):Void {
		Jvm.writeField(o, field, value);
	}

	public static function getProperty(o:Dynamic, field:String):Null<Dynamic> {
		var f = Reflect.field(o, "get_" + field);
		if (f != null) {
			return f();
		}
		return Reflect.field(o, field);
	}

	public static function setProperty(o:Dynamic, field:String, value:Dynamic):Void {
		var f = Reflect.field(o, "set_" + field);
		if (f != null) {
			f(value);
			return;
		}
		Reflect.setField(o, field, value);
	}

	public static function callMethod(o:Dynamic, func:haxe.Constraints.Function, args:Array<Dynamic>):Dynamic {
		return Jvm.call(cast func, @:privateAccess args.getNative());
	}

	public static function fields(o:Dynamic):Array<String> {
		if (!Jvm.instanceof(o, jvm.DynamicObject)) {
			if (Jvm.instanceof(o, java.lang.Class)) {
				return Type.getClassFields(o);
			}
			var c = (o : java.lang.Object).getClass();
			var ret = [];
			for (f in c.getDeclaredFields()) {
				if (java.lang.reflect.Modifier.isStatic(f.getModifiers()) == false && !f.isSynthetic()) {
					ret.push(f.getName());
				}
			}
			return ret;
		}
		return (cast o : jvm.DynamicObject)._hx_getFields();
	}

	public static function isFunction(f:Dynamic):Bool {
		return Jvm.instanceof(f, jvm.Function);
	}

	public static function compare<T>(a:T, b:T):Int {
		if (Jvm.referenceEquals(a, b)) {
			return 0;
		}
		if (a == null) {
			return -1;
		}
		if (b == null) {
			return 1;
		}
		if (Jvm.instanceof(a, java.lang.Number) && Jvm.instanceof(b, java.lang.Number)) {
			return java.lang.Long.compare((cast a : java.lang.Number).longValue(), (cast b : java.lang.Number).longValue());
		}
		if (Jvm.instanceof(a, java.NativeString)) {
			if (!Jvm.instanceof(b, java.NativeString)) {
				return -1;
			}
			return (cast a : java.NativeString).compareTo(cast b);
		}
		return -1;
	}

	public static function compareMethods(f1:Dynamic, f2:Dynamic):Bool {
		if (f1 == f2) {
			return true;
		}
		if (f1 == null || f2 == null) {
			return false;
		}
		var c1 = (f1 : java.lang.Object).getClass();
		if (c1 != (f2 : java.lang.Object).getClass()) {
			return false;
		}
		if (Std.isOfType(f1, jvm.Function)) {
			if (!Std.isOfType(f2, jvm.Function)) {
				return false;
			}
			return (f1 : jvm.Function).equals(f2);
		}
		return false;
	}

	public static function isObject(v:Dynamic):Bool {
		if (v == null) {
			return false;
		}
		if (Jvm.instanceof(v, jvm.Enum)) {
			return false;
		}
		if (Jvm.instanceof(v, java.lang.Number)) {
			return false;
		}
		if (Jvm.instanceof(v, java.lang.Boolean.BooleanClass)) {
			return false;
		}
		if (Jvm.instanceof(v, jvm.Function)) {
			return false;
		}
		return true;
	}

	public static function isEnumValue(v:Dynamic):Bool {
		if (v == null) {
			return false;
		}
		return @:privateAccess Type.isEnumValueClass((cast v : java.lang.Object).getClass());
	}

	public static function deleteField(o:Dynamic, field:String):Bool {
		if (!Jvm.instanceof(o, jvm.DynamicObject)) {
			return false;
		}
		return (cast o : jvm.DynamicObject)._hx_deleteField(field);
	}

	public static function copy<T>(o:Null<T>):Null<T> {
		if (!Jvm.instanceof(o, jvm.DynamicObject)) {
			return null;
		}
		var o = (cast o : jvm.DynamicObject);
		return cast o._hx_clone();
	}

	@:overload(function(f:Array<Dynamic>->Void):Dynamic {})
	public static function makeVarArgs(f:Array<Dynamic>->Dynamic):Dynamic {
		return new jvm.Closure.VarArgs((cast f : jvm.Function));
	}
}
