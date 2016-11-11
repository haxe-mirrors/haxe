/*
 * Copyright (C)2005-2017 Haxe Foundation
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
package python;

import python.internal.ArrayImpl;
import python.internal.Internal;
import python.internal.StringImpl;
import python.internal.EnumImpl;
import python.internal.HxOverrides;
import python.internal.HxException;
import python.internal.AnonObject;
import python.internal.UBuiltins;
import python.lib.Inspect;

import python.Syntax;

@:dox(hide)
class Boot {

	static var keywords:Set<String> = new Set(
	[
		"and",      "del",      "from",     "not",      "with",
		"as",       "elif",     "global",   "or",       "yield",
		"assert",   "else",     "if",       "pass",     "None",
		"break",    "except",   "import",   "raise",    "True",
		"class",    "exec",     "in",       "return",   "False",
		"continue", "finally",  "is",       "try",
		"def",      "for",      "lambda",   "while",
	]);

	inline static function arrayJoin <T>(x:Array<T>, sep:String):String {
		return Syntax.field(sep, "join")(Syntax.pythonCode("[{0}(x1,'') for x1 in {1}]", python.Boot.toString1, x));
	}

	inline static function safeJoin (x:Array<String>, sep:String):String {
		return Syntax.field(sep, "join")(Syntax.pythonCode("[x1 for x1 in {0}]", x));
	}

	inline static function isPyBool(o:Dynamic):Bool {
		return UBuiltins.isinstance(o, UBuiltins.bool);
	}

	inline static function isPyInt(o:Dynamic):Bool {
		return UBuiltins.isinstance(o, UBuiltins.int);
	}

	inline static function isPyFloat(o:Dynamic):Bool {
		return UBuiltins.isinstance(o, UBuiltins.float);
	}

	static inline function isClass(o:Dynamic) : Bool {
		return o != null && (o == String || Inspect.isclass(o));
	}

	static inline function isAnonObject(o:Dynamic) {
		return UBuiltins.isinstance(o, AnonObject);
	}

	@:ifFeature("add_dynamic") private static function _add_dynamic(a:Dynamic,b:Dynamic):Dynamic {
		if (UBuiltins.isinstance(a, String) && UBuiltins.isinstance(b, String)) {
			return Syntax.binop(a, "+", b);
		}
		if (UBuiltins.isinstance(a, String) || UBuiltins.isinstance(b, String)) {
			return Syntax.binop(toString1(a,""), "+", toString1(b,""));
		}
		return Syntax.binop(a, "+", b);
	}

	static inline function toString (o:Dynamic) {
		return toString1(o, "");
	}

	private static function toString1(o:Dynamic,s:String):String {

		if( o == null ) return "null";

		if (isString(o)) return o;

		if (s == null) s = "";
		if( s.length >= 5 ) return "<...>"; // too much deep recursion

		if (isPyBool(o)) {
			if ((o:Bool)) return "true" else return "false";
		}
		if (isPyInt(o)) {
			return UBuiltins.str(o);
		}
		// 1.0 should be printed as 1
		if (isPyFloat(o)) {
			try {
				if ( (o:Float) == UBuiltins.int(o)) {
					return UBuiltins.str(Math.round(o));
				} else {
					return UBuiltins.str(o);
				}
			} catch (e:Dynamic) {
				return UBuiltins.str(o);
			}
		}

		if (isArray(o))
		{
			var o1:Array<Dynamic> = o;

			var l = o1.length;

			var st = "[";
			s += "\t";
			for( i in 0...l ) {
				var prefix = "";
				if (i > 0) {
					prefix = ",";
				}
				st += prefix + toString1(o1[i],s);
			}
			st += "]";
			return st;
		}

		try {
			if (UBuiltins.hasattr(o, "toString"))
				return Syntax.callField(o, "toString");
		} catch (e:Dynamic) {
		}

		if (Inspect.isfunction(o) || Inspect.ismethod(o)) return "<function>";

		if (UBuiltins.hasattr(o, "__class__"))
		{

			if (isAnonObject(o))
			{
				var toStr = null;
				try
				{
					var fields = fields(o);
					var fieldsStr = [for (f in fields) '$f : ${toString1(simpleField(o,f), s+"\t")}'];
					toStr = "{ " + safeJoin(fieldsStr, ", ") + " }";
				}
				catch (e:Dynamic) {
					return "{ ... }";
				}

				if (toStr == null)
				{
					return "{ ... }";
				}
				else
				{
					return toStr;
				}

			}
			if (UBuiltins.isinstance(o, Enum)) {

				var o:EnumImpl = (o:EnumImpl);

				var l = UBuiltins.len(o.params);
				var hasParams = l > 0;
				if (hasParams) {
					var paramsStr = "";
					for (i in 0...l) {
						var prefix = "";
						if (i > 0) {
							prefix = ",";
						}
						paramsStr += prefix + toString1(o.params[i],s);
					}
					return o.tag + "(" + paramsStr + ")";
				} else {
					return o.tag;
				}
			}

			if (Internal.hasClassName(o)) {
				if (Syntax.field(Syntax.field(o, "__class__"), "__name__") != "type") {
					var fields = getInstanceFields(o);
					var fieldsStr = [for (f in fields) '$f : ${toString1(simpleField(o,f), s+"\t")}'];

					var toStr = (Internal.fieldClassName(o):String) + "( " + safeJoin(fieldsStr, ", ") + " )";
					return toStr;
				} else {
					var fields = getClassFields(o);
					var fieldsStr = [for (f in fields) '$f : ${toString1(simpleField(o,f), s+"\t")}'];
					var toStr = "#" + (Internal.fieldClassName(o):String) + "( " + safeJoin(fieldsStr, ", ") + " )";
					return toStr;
				}
			}

			if (isMetaType(o,String)) {
				return "#String";
			}

			if (isMetaType(o,Array)) {
				return "#Array";
			}

			if (UBuiltins.callable(o)) {
				return "function";
			}
			try {
				if (UBuiltins.hasattr(o, "__repr__")) {
					return Syntax.callField(o, "__repr__");
				}
			} catch (e:Dynamic) {}

			if (UBuiltins.hasattr(o, "__str__")) {
				return Syntax.callField(o, "__str__", []);
			}

			if (UBuiltins.hasattr(o, "__name__")) {
				return Syntax.field(o, "__name__");
			}
			return "???";
		} else {
			return UBuiltins.str(o);
		}
	}

	static inline function isMetaType(v:Dynamic, t:Dynamic):Bool {
		return python.Syntax.binop(v, "==", t);
	}

	@:analyzer(no_local_dce)
	static function fields (o:Dynamic) {
		var a = [];
		if (o != null) {
			if (Internal.hasFields(o)) {
				return (Internal.fieldFields(o) : Array<String>).copy();
			}
			if (isAnonObject(o)) {

				var d = Syntax.field(o, "__dict__");
				var keys = Syntax.callField(d, "keys");
				var handler = unhandleKeywords;

				Syntax.pythonCode("for k in keys:");
				Syntax.pythonCode("    a.append(handler(k))");
			}
			else if (UBuiltins.hasattr(o, "__dict__")) {
				var a = [];
				var d = Syntax.field(o, "__dict__");
				var keys1  = Syntax.callField(d, "keys");
				Syntax.pythonCode("for k in keys1:");
				Syntax.pythonCode("    a.append(k)");

			}
		}
		return a;
	}

	static inline function isString (o:Dynamic):Bool {
		return UBuiltins.isinstance(o, UBuiltins.str);
	}

	static inline function isArray (o:Dynamic):Bool {
		return UBuiltins.isinstance(o, UBuiltins.list);
	}

	static function simpleField( o : Dynamic, field : String ) : Dynamic {
		if (field == null) return null;

		var field = handleKeywords(field);
		return if (UBuiltins.hasattr(o, field)) UBuiltins.getattr(o, field) else null;
	}

	static var closures:Dynamic;

	static function getClosure (funId:String, o:Dynamic,  or : Void->Dynamic) {
		
		if (closures == null) {
			python.Syntax.pythonCode("import weakref");
			closures = python.Syntax.pythonCode("weakref.WeakValueDictionary()");
		}
		var hash = UBuiltins.str(UBuiltins.id(o)) + "_" + funId;
		var closure = python.Syntax.callField(closures, "get", hash);
		if (closure == null) {
			var res = or();
			python.Syntax.arraySet(closures, hash, res);
			return res;
		}
		return closure;
	}

	static function field( o : Dynamic, field : String ) : Dynamic {
		if (field == null) return null;

		switch (field) {
			case "length" if (isString(o)): 
				return StringImpl.get_length(o);
			case "toLowerCase" if (isString(o)): 
				var lazy = function () return StringImpl.toLowerCase.bind(o);
				return getClosure("String"+field, o, lazy);
			case "toUpperCase" if (isString(o)): 
				var lazy = function () return StringImpl.toUpperCase.bind(o);
				return getClosure("String"+field, o, lazy);
			case "charAt" if (isString(o)): 
				var lazy = function () return StringImpl.charAt.bind(o);
				return getClosure("String"+field, o, lazy);
			case "charCodeAt" if (isString(o)): 
				var lazy = function () return StringImpl.charCodeAt.bind(o);
				return getClosure("String"+field, o, lazy);
			case "indexOf" if (isString(o)): 
				var lazy = function () return StringImpl.indexOf.bind(o);
				return getClosure("String"+field, o, lazy);
			case "lastIndexOf" if (isString(o)): 
				var lazy = function () return StringImpl.lastIndexOf.bind(o);
				return getClosure("String"+field, o, lazy);
			case "split" if (isString(o)): 
				var lazy = function () return StringImpl.split.bind(o);
				return getClosure("String"+field, o, lazy);
			case "substr" if (isString(o)): 
				var lazy = function () return StringImpl.substr.bind(o);
				return getClosure("String"+field, o, lazy);
			case "substring" if (isString(o)): 
				var lazy = function () return StringImpl.substring.bind(o);
				return getClosure("String"+field, o, lazy);
			case "toString" if (isString(o)): 
				var lazy = function () return StringImpl.toString.bind(o);
				return getClosure("String"+field, o, lazy);
			case "length" if (isArray(o)): 
				return ArrayImpl.get_length(o);
			case "map" if (isArray(o)): 
				var lazy = function () return ArrayImpl.map.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "filter" if (isArray(o)): 
				var lazy = function () return ArrayImpl.filter.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "concat" if (isArray(o)): 
				var lazy = function () return ArrayImpl.concat.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "copy" if (isArray(o)): 
				return function () return ArrayImpl.copy(o);
			case "iterator" if (isArray(o)): 
				var lazy = function () return ArrayImpl.iterator.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "insert" if (isArray(o)): 
				var lazy = function () return ArrayImpl.insert.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "join" if (isArray(o)): 
				return function (sep) return ArrayImpl.join(o, sep);
			case "toString" if (isArray(o)): 
				var lazy = function () return ArrayImpl.toString.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "pop" if (isArray(o)): 
				var lazy = function () return ArrayImpl.pop.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "push" if (isArray(o)): 
				var lazy = function () return ArrayImpl.push.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "unshift" if (isArray(o)): 
				var lazy = function () return ArrayImpl.unshift.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "indexOf" if (isArray(o)): 
				var lazy = function () return ArrayImpl.indexOf.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "lastIndexOf" if (isArray(o)): 
				var lazy = function () return ArrayImpl.lastIndexOf.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "remove" if (isArray(o)): 
				var lazy = function () return ArrayImpl.remove.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "reverse" if (isArray(o)): 
				var lazy = function () return ArrayImpl.reverse.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "shift" if (isArray(o)): 
				var lazy = function () return ArrayImpl.shift.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "slice" if (isArray(o)): 
				var lazy = function () return ArrayImpl.slice.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "sort" if (isArray(o)): 
				var lazy = function () return ArrayImpl.sort.bind(o);
				return getClosure("Array"+field, o, lazy);
			case "splice" if (isArray(o)): 
				var lazy = function () return ArrayImpl.splice.bind(o);
				return getClosure("Array"+field, o, lazy);
		}


		var field = handleKeywords(field);
		return if (UBuiltins.hasattr(o, field)) UBuiltins.getattr(o, field) else null;
	}


	static function getInstanceFields( c : Class<Dynamic> ) : Array<String> {
		var f = if (Internal.hasFields(c)) (Internal.fieldFields(c) : Array<String>).copy() else [];
		if (Internal.hasMethods(c))
			f = f.concat(Internal.fieldMethods(c));

		var sc = getSuperClass(c);

		if (sc == null) {
			return f;
		} else {

			var scArr = getInstanceFields(sc);
			var scMap = new Set(scArr);
			for (f1 in f) {
				if (!scMap.has(f1)) {
					scArr.push(f1);
				}
			}

			return scArr;
		}
	}

	static function getSuperClass( c : Class<Dynamic> ) : Class<Dynamic> {
		if( c == null )
			return null;

		try {
			if (Internal.hasSuper(c)) {
				return Internal.fieldSuper(c);
			}
			return null;
		} catch (e:Dynamic) {

		}
		return null;

	}

	static function getClassFields( c : Class<Dynamic> ) : Array<String> {
		if (Internal.hasStatics(c)) {
			var x:Array<String> = Internal.fieldStatics(c);
			return x.copy();
		} else {
			return [];
		}
	}



	static inline function unsafeFastCodeAt (s, index) {
		return UBuiltins.ord(python.Syntax.arrayAccess(s, index));
	}

	static inline function handleKeywords(name:String):String {
		return if (keywords.has(name)) {
			Internal.getPrefixed(name);
		} else if (name.length > 2 && unsafeFastCodeAt(name,0) == "_".code && unsafeFastCodeAt(name,1) == "_".code && unsafeFastCodeAt(name, name.length-1) != "_".code) {
			Internal.getPrefixed(name);
		}
		else name;
	}

	static var prefixLength = Internal.prefix().length;

	static function unhandleKeywords(name:String):String {
		if (name.substr(0,prefixLength) == Internal.prefix()) {
			var real = name.substr(prefixLength);
			if (keywords.has(real)) return real;
		}
		return name;
	}

}