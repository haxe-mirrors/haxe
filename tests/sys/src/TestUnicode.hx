import utest.Assert;

using haxe.iterators.StringIteratorUnicode;

private enum Filename {
	Only(ref:Array<Int>);
	Normal(nfc:Array<Int>, nfd:Array<Int>);
}

class TestUnicode extends utest.Test {
	// list of expected filenames in Unicode codepoint sequences
	static var names:Array<Filename> = [
		// boundary conditions
		Only([0x0001]),
		Only([0x007F]),
		Only([0x0080]),
		Only([0x07FF]),
		Only([0x0800]),
		Only([0xD7FF]),
		Only([0xE000]),
		Only([0xFFFD]),
		//Only([0xFFFE]), // invalid character!
		//Only([0xFFFF]), // invalid character!
		// non-BMP (not supported for the time being)
		//Only([0x10000]),
		//Only([0x1FFFF]),
		//Only([0xFFFFF]),
		//Only([0x100000]),
		//Only([0x10FFFF]),
		// some readable comparison cases
		Only([0x0061]),
		Only([0x0062]),
		Only([0x0063]),
		Only([0x1F602, 0x1F604, 0x1F619])
	].concat([
		// NFC / NFD
		Normal([0x0227], [0x0061, 0x0307])
	]);

	static var namesRoot = names.concat([
		Only([0x64, 0x61, 0x74, 0x61, 0x2E, 0x62, 0x69, 0x6E]) // data.bin
	]);

	function codepointsSame(actual:Array<Int>, expected:Filename):Bool {
		function sameOption(ref:Array<Int>):Bool {
			if (actual.length != ref.length) return false;
			for (i in 0...actual.length) if (actual[i] != ref[i]) return false;
			return true;
		}
		return (switch (expected) {
				case Only(ref): sameOption(ref);
				case Normal(nfc, nfd):
				// it might eventually be best to expect a particular form
				// on specific targets + platforms + filesystems
				// for now, allowing either
				sameOption(nfc) || sameOption(nfd);
			});
	}

	// same names and length, but possibly different order
	// assumes no duplicates in expected
	function sameFiles(actual:Array<String>, expected:Array<Filename>):Void {
		Assert.equals(actual.length, expected.length);
		var remaining = expected.copy();
		for (file in actual) {
			var codepoints = unicodeCodepoints(file);
			var found = null;
			for (ref in remaining) {
				if (codepointsSame(codepoints, ref)) {
					found = ref;
					break;
				}
			}
			if (found == null) {
				Assert.fail('unexpected filename $file (${codepoints.map(c -> StringTools.hex(c, 4))}) found');
			} else {
				remaining.remove(found);
			}
		}
	}

	function unicodeCodepoints(str:String):Array<Int> {
		return [ for (codepoint in str.unicodeIterator()) codepoint ];
	}

	function testFileSystem() {
#if (target.unicode)
		sameFiles(sys.FileSystem.readDirectory("test-res"), namesRoot);
		sameFiles(sys.FileSystem.readDirectory("test-res/a"), names);
		sameFiles(sys.FileSystem.readDirectory("test-res/b"), names);
#end
	}
}
