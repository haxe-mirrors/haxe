import utest.Assert;
import haxe.io.Bytes;
import UnicodeSequences.UnicodeString;
import UnicodeSequences.codepointsToString;
import UnicodeSequences.showUnicodeString;

class TestUnicode extends utest.Test {
	static var BIN_PATH =
#if cpp
		"bin/cpp";
#elseif cs
		"bin/cs/bin";
#elseif hl
		"bin/hl";
#elseif java
		"bin/java";
#elseif neko
		"bin/neko";
#elseif php
		"bin/php";
#elseif python
		"bin/python";
#else
		null;
#end
	static var BIN_NAME =
#if cpp
		#if debug
			"UtilityProcess-debug";
		#else
			"UtilityProcess";
		#end
#elseif cs
		#if debug
			"UtilityProcess-Debug.exe";
		#else
			"UtilityProcess.exe";
		#end
#elseif hl
		"UtilityProcess.hl";
#elseif java
		#if debug
			"UtilityProcess-Debug.jar";
		#else
			"UtilityProcess.jar";
		#end
#elseif neko
		"UtilityProcess.n";
#elseif php
		"UtilityProcess/index.php";
#elseif python
		"UtilityProcess.py";
#else
		null;
#end
	static var BIN_SYMLINK =
#if cpp
		"bin-cpp";
#elseif cs
		"bin-cs";
#elseif hl
		"bin-hl";
#elseif java
		"bin-java";
#elseif neko
		"bin-neko";
#elseif php
		"bin-php";
#elseif python
		"bin-py";
#else
		null;
#end

	// list of filenames expected to NOT exist in sub-directories
	static var nonExistentNames:Array<UnicodeString> = [
		// Java escapes
		Only([0x0025, 0x0030 , 0x0001]), // %01
		Only([0x0025, 0x0037 , 0x0046]) // %7F
	];

	// list of expected filenames in sub-directories
	static var names:Array<UnicodeString> = UnicodeSequences.valid;

	// extra files only present in the root test-res directory
	static var namesRoot = names.concat([
		Only([0x0061]), // a
		Only([0x0062]), // b
		Only([0x64, 0x61, 0x74, 0x61, 0x2E, 0x62, 0x69, 0x6E]) // data.bin
	]);

	// same names and length, but possibly different order
	// assumes no duplicates in expected
	function sameFiles(actual:Array<String>, expected:Array<UnicodeString>):Void {
		Assert.equals(actual.length, expected.length);
		var remaining = expected.copy();
		for (file in actual) {
			var codepoints = UnicodeSequences.unicodeCodepoints(file);
			var removed = remaining.filter(ref -> !UnicodeSequences.codepointsSame(codepoints, ref));
			if (removed.length == remaining.length) {
				Assert.fail('unexpected filename ${showUnicodeString(file)} found');
			} else {
				remaining = removed;
			}
		}
	}

	function assertUEnds(actual:String, expected:String, ?alt:String, ?pos:haxe.PosInfos):Void {
		Assert.isTrue(
			StringTools.endsWith(actual, expected) || (alt != null ? StringTools.endsWith(actual, alt) : false),
			'expected ${showUnicodeString(actual)} to end with ${showUnicodeString(expected)}'
			+ (alt != null ? ' or ${showUnicodeString(alt)}' : ""),
			pos
		);
	}

	function assertUEquals(actual:String, expected:String, ?msg:String, ?pos:haxe.PosInfos):Void {
		Assert.equals(
			expected, actual,
			'expected ${showUnicodeString(actual)} to be ${showUnicodeString(expected)}',
			pos
		);
	}

	function pathBoth(f:String->Void, path:String, ?skipNonExistent:Bool = true):Void {
		for (filename in names) switch (filename) {
			case Only(codepointsToString(_) => ref):
			f('$path/$ref');
			case Normal(codepointsToString(_) => nfc, codepointsToString(_) => nfd):
			if (sys.FileSystem.exists('$path/$nfc') || !skipNonExistent) f('$path/$nfc');
			if (sys.FileSystem.exists('$path/$nfd') || !skipNonExistent) f('$path/$nfd');
		}
	}

	function assertNormalEither(f:String->Bool, path:String, ?msg:String, ?pos:haxe.PosInfos):Void {
		for (filename in names) Assert.isTrue(switch (filename) {
			case Only(codepointsToString(_) => ref): f('$path/$ref');
			case Normal(codepointsToString(_) => nfc, codepointsToString(_) => nfd):
			f('$path/$nfc') || f('$path/$nfd');
		}, '$msg ($filename in $path)', pos);
	}

	function runUtility(args:Array<String>, ?options:{?stdin:String, ?execPath:String, ?execName:String}):{
		exitCode:Int,
		stdout:String,
		stderr:String
	} {
		if (options == null) options = {};
		if (options.execPath == null) options.execPath = BIN_PATH;
		if (options.execName == null) options.execName = BIN_NAME;
		var execFull = '${options.execPath}/${options.execName}';
		var proc =
		#if (macro || interp)
		new sys.io.Process("haxe", ["compile-each.hxml", "--run", execFull].concat(args));
		#elseif cpp
		new sys.io.Process(execFull, args);
		#elseif cs
		(switch (Sys.systemName()) {
			case "Windows":
				new sys.io.Process(execFull, args);
			case _:
				new sys.io.Process("mono", [execFull].concat(args));
		});
		#elseif java
		new sys.io.Process(haxe.io.Path.join([java.lang.System.getProperty("java.home"), "bin", "java"]), ["-jar", execFull].concat(args));
		#elseif python
		new sys.io.Process(python.lib.Sys.executable, [execFull].concat(args));
		#elseif neko
		new sys.io.Process("neko", [execFull].concat(args));
		#elseif hl
		new sys.io.Process("hl", [execFull].concat(args));
		#elseif php
		new sys.io.Process(php.Global.defined('PHP_BINARY') ? php.Const.PHP_BINARY : 'php', [execFull].concat(args));
		#elseif lua
		new sys.io.Process("lua", [execFull].concat(args));
		#else
		null;
		#end
		if (options.stdin != null) {
			proc.stdin.writeString(options.stdin);
			proc.stdin.flush();
		}
		return {
			exitCode: proc.exitCode(),
			stdout: proc.stdout.readAll().toString(),
			stderr: proc.stderr.readAll().toString()
		};
	}

#if (target.unicode)
	function testPaths() {
#if !(java)
		// setCwd + getCwd
		Sys.setCwd("test-res");
		function enterLeave(dir:String, ?alt:String):Void {
			Sys.setCwd(dir);
			assertUEnds(Sys.getCwd(), '/test-res/${dir}', alt != null ? '/test-res/${alt}' : null);
			Sys.setCwd("..");
		}
		for (filename in names) switch (filename) {
			case Only(codepointsToString(_) => ref): enterLeave(ref);
			case Normal(codepointsToString(_) => nfc, codepointsToString(_) => nfd):
			if (sys.FileSystem.exists(nfc)) enterLeave(nfc, nfd);
			if (sys.FileSystem.exists(nfd)) enterLeave(nfd, nfc);
		}
		Sys.setCwd("..");
#end

		// programPath
#if !(java || python) // these targets resolve symlinked files
		pathBoth(path -> {
				assertUEnds(runUtility(["programPath"], {execPath: path, execName: BIN_SYMLINK}).stdout, '$path/${BIN_SYMLINK}\n');
			}, "test-res");
#end

		// absolutePath
		pathBoth(path -> {
				for (relative in [
						{path: '../$path', end: '${path}'},
						{path: 'foo', end: '${path}/foo'},
						{path: "..", end: "test-res"},
						{path: "./././././", end: path},
						{path: "./..", end: "test-res"},
						{path: "./čýžé", end: '${path}/čýžé'},
						{path: "./čýžé/", end: '${path}/čýžé'},
						{path: "./../čýžé", end: 'test-res/čýžé'},
						{path: "./../čýžé/", end: 'test-res/čýžé'},
					]) assertUEnds(
						sys.FileSystem.absolutePath('$path/${relative.path}'),
						relative.end
					);
			}, "test-res");

#if !(java)
		assertNormalEither(path -> {
				if (!sys.FileSystem.exists(path)) return false; // NFC/NFD differences
				Sys.setCwd(path);
				var ret = true;
				for (relative in [
						{path: '../$path', end: '${path}'},
						{path: 'foo', end: '${path}/foo'},
						{path: "..", end: "test-res"},
						{path: "./././././", end: path},
						{path: "./..", end: "test-res"},
						{path: "./čýžé", end: '${path}/čýžé'},
						{path: "./čýžé/", end: '${path}/čýžé'},
						{path: "./../čýžé", end: 'test-res/čýžé'},
						{path: "./../čýžé/", end: 'test-res/čýžé'},
					]) if (!StringTools.endsWith(sys.FileSystem.absolutePath('${relative.path}'), relative.end)) ret = false;
				Sys.setCwd("../..");
				return ret;
			}, "test-res", "setCwd + absolutePath + endsWith failed");
#end

		// exists
		assertNormalEither(sys.FileSystem.exists, 'test-res/a', 'expected exists == true');
		assertNormalEither(sys.FileSystem.exists, 'test-res/b', 'expected exists == false');

		// fullPath
		pathBoth(path -> {
				assertUEnds(
						sys.FileSystem.fullPath('$path/${BIN_SYMLINK}'),
						'/${BIN_PATH}/${BIN_NAME}'
					);
			}, "test-res");

		// isDirectory
		assertNormalEither(sys.FileSystem.isDirectory, 'test-res/a', 'expected isDirectory == true');
		assertNormalEither(path -> !sys.FileSystem.isDirectory(path), 'test-res/b', 'expected isDirectory == false');

		// readDirectory
		sameFiles(sys.FileSystem.readDirectory("test-res"), namesRoot);
		sameFiles(sys.FileSystem.readDirectory("test-res/a"), names);
		sameFiles(sys.FileSystem.readDirectory("test-res/b"), names);

		// stat
		assertNormalEither(path -> sys.FileSystem.stat(path) != null, 'test-res/a', 'expected stat != null');
		assertNormalEither(path -> sys.FileSystem.stat(path) != null, 'test-res/b', 'expected stat != null');
	}

	function testIO() {
		// stdin.readLine
		UnicodeSequences.normalBoth(str -> {
				assertUEquals(runUtility(["stdin.readLine"], {stdin: '$str\n'}).stdout, '$str\n');
			});

		// stdin.readString
		UnicodeSequences.normalBoth(str -> {
				// FIXME: readString of UTF8 should maybe read n characters, not bytes? #8199
				var byteLength = Bytes.ofString(str).length;
				assertUEquals(runUtility(["stdin.readString", '${byteLength}'], {stdin: '$str'}).stdout, '$str\n');
			});

		// stdin.readUntil
		UnicodeSequences.normalBoth(str -> {
				// make sure the 0x70 byte is not part of the test string 
				assertUEquals(runUtility(["stdin.readUntil", "0x70"], {stdin: str + "\x70" + str + "\x70"}).stdout, '$str\n');
			});

		// stdout, stderr
		UnicodeSequences.normalBothIndexed((str, i, nfc) -> {
				// stdout
				assertUEquals(runUtility(["stdout.writeString", '$i', nfc ? "nfc" : "nfd"]).stdout, str);
				// stderr
				assertUEquals(runUtility(["stderr.writeString", '$i', nfc ? "nfc" : "nfd"]).stderr, str);
				// print
				assertUEquals(runUtility(["print", '$i', nfc ? "nfc" : "nfd"]).stdout, str);
				// println
				assertUEquals(runUtility(["println", '$i', nfc ? "nfc" : "nfd"]).stdout, '$str\n');
			});

		// args
		UnicodeSequences.normalBoth(str -> {
				assertUEquals(runUtility(["args", str]).stdout, '$str\n');
			});

		// readLine
		var data = sys.io.File.read("test-res/data.bin");
		UnicodeSequences.normalNFC(str -> {
				var line = data.readLine();
				assertUEquals(line, str);
			});
	}
#end
}
