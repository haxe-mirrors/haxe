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
package haxe.ds;

@:coreApi class IntMap<T> implements haxe.Constraints.IMap<Int,T> {
#if (js_es >= 6)
	var m:js.Map<Int,T>;
	@:pure public inline function new() this.m = new js.Map();
	@:pure public inline function get(key:Int):Null<T> return m.get(key);
	public inline function set(key:Int, value:T):Void m.set(key, value);
	@:pure public inline function exists(key:Int):Bool return m.has(key);
	public inline function remove(key:Int):Bool return m.delete(key);
	@:pure public inline function keys():Iterator<Int> return new js.JsIterator.JsIteratorAdapter(m.keys());
	@:pure public inline function iterator():Iterator<T> return new js.JsIterator.JsIteratorAdapter(m.values());
	@:pure public inline function copy():IntMap<T> return { var copy = new IntMap(); @:privateAccess js.Boot.__copyMap(this.m, copy.m); copy; };
	@:pure public inline function toString():String return @:privateAccess js.Boot.__mapToString(m);
#else
	private var h : Dynamic;

	public inline function new() : Void {
		h = {};
	}

	public inline function set( key : Int, value : T ) : Void {
		h[key] = value;
	}

	public inline function get( key : Int ) : Null<T> {
		return h[key];
	}

	public inline function exists( key : Int ) : Bool {
		return (cast h).hasOwnProperty(key);
	}

	public function remove( key : Int ) : Bool {
		if( !(cast h).hasOwnProperty(key) ) return false;
		js.Syntax.delete(h, key);
		return true;
	}

	public function keys() : Iterator<Int> {
		var a = [];
		untyped __js__("for( var key in {0} ) {1}", h, if( h.hasOwnProperty(key) ) a.push(key|0));
		return a.iterator();
	}

	public function iterator() : Iterator<T> {
		return untyped {
			ref : h,
			it : keys(),
			hasNext : function() { return __this__.it.hasNext(); },
			next : function() { var i = __this__.it.next(); return __this__.ref[i]; }
		};
	}

	public function copy() : IntMap<T> {
		var copied = new IntMap();
		for(key in keys()) copied.set(key, get(key));
		return copied;
	}

	public function toString() : String {
		var s = new StringBuf();
		s.add("{");
		var it = keys();
		for( i in it ) {
			s.add(i);
			s.add(" => ");
			s.add(Std.string(get(i)));
			if( it.hasNext() )
				s.add(", ");
		}
		s.add("}");
		return s.toString();
	}
#end
}
