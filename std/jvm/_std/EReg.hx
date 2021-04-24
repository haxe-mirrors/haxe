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

import java.util.regex.*;
import jvm.CompiledPattern;

using StringTools;

@:coreApi class EReg {
	private var matcher:Matcher;
	private var cur:String;
	private var isGlobal:Bool;

	@:overload
	public function new(r:String, opt:String) {
		initialize(compilePattern(r, opt));
	}

	@:overload
	function new(compiledPattern:CompiledPattern) {
		initialize(compiledPattern);
	}

	function initialize(compiledPattern:CompiledPattern):Void {
		matcher = compiledPattern.pattern.matcher("");
		isGlobal = compiledPattern.isGlobal;
	}

	public function match(s:String):Bool {
		cur = s;
		matcher = matcher.reset(s);
		return matcher.find();
	}

	public function matched(n:Int):String {
		if (n == 0)
			return matcher.group();
		else
			return matcher.group(n);
	}

	public function matchedLeft():String {
		return untyped cur.substring(0, matcher.start());
	}

	public function matchedRight():String {
		return untyped cur.substring(matcher.end(), cur.length);
	}

	public function matchedPos():{pos:Int, len:Int} {
		var start = matcher.start();
		return {pos: start, len: matcher.end() - start};
	}
	
	public function matchedNum():Int {
		if(matcher.group() == null) {
			return 0;
		} else {
			return matcher.groupCount() + 1;
		}
	}

	public function matchSub(s:String, pos:Int, len:Int = -1):Bool {
		matcher = matcher.reset(len < 0 ? s : s.substr(0, pos + len));
		cur = s;
		return matcher.find(pos);
	}

	public function split(s:String):Array<String> {
		if (isGlobal) {
			var ret = [];
			matcher.reset(s);
			matcher = matcher.useAnchoringBounds(false).useTransparentBounds(true);
			var copyOffset = 0;
			while (true) {
				if (!matcher.find()) {
					ret.push(s.substring(copyOffset, s.length));
					break;
				}
				ret.push(s.substring(copyOffset, matcher.start()));
				var nextStart = matcher.end();
				copyOffset = nextStart;
				if (nextStart == matcher.regionStart()) {
					nextStart++; // zero-length match - shift region one forward
				}
				if (nextStart >= s.length) {
					ret.push("");
					break;
				}
				matcher.region(nextStart, s.length);
			}
			return ret;
		} else {
			var m = matcher;
			m.reset(s);
			if (m.find()) {
				return untyped [s.substring(0, m.start()), s.substring(m.end(), s.length)];
			} else {
				return [s];
			}
		}
	}

	inline function start(group:Int):Int {
		return matcher.start(group);
	}

	inline function len(group:Int):Int {
		return matcher.end(group) - matcher.start(group);
	}

	public function replace(s:String, by:String):String {
		matcher.reset(s);
		by = by.replace("\\", "\\\\").replace("$$", "\\$");
		return isGlobal ? matcher.replaceAll(by) : matcher.replaceFirst(by);
	}

	public function map(s:String, f:EReg->String):String {
		var offset = 0;
		var buf = new StringBuf();
		do {
			if (offset >= s.length)
				break;
			else if (!matchSub(s, offset)) {
				buf.add(s.substr(offset));
				break;
			}
			var p = matchedPos();
			buf.add(s.substr(offset, p.pos - offset));
			buf.add(f(this));
			if (p.len == 0) {
				buf.add(s.substr(p.pos, 1));
				offset = p.pos + 1;
			} else
				offset = p.pos + p.len;
		} while (isGlobal);
		if (!isGlobal && offset > 0 && offset < s.length)
			buf.add(s.substr(offset));
		return buf.toString();
	}

	public static inline function escape(s:String):String {
		return Pattern.quote(s);
	}

	static function compilePattern(r:String, opt:String):CompiledPattern {
		var flags = 0;
		var isGlobal = false;
		for (i in 0...opt.length) {
			switch (StringTools.fastCodeAt(opt, i)) {
				case 'i'.code:
					flags |= Pattern.CASE_INSENSITIVE;
				case 'm'.code:
					flags |= Pattern.MULTILINE;
				case 's'.code:
					flags |= Pattern.DOTALL;
				case 'g'.code:
					isGlobal = true;
			}
		}

		flags |= Pattern.UNICODE_CASE;
		#if !android // see https://github.com/HaxeFoundation/haxe/issues/7632
		flags |= Pattern.UNICODE_CHARACTER_CLASS;
		#end
		return {
			pattern: Pattern.compile(r, flags),
			isGlobal: isGlobal
		}
	}
}
