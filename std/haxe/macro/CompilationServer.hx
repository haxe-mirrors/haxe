package haxe.macro;

import haxe.macro.Compiler;

@:enum
abstract ModuleCheckPolicy(Int) {
	/**
		Disables file modification checks, avoiding some filsystem operations.
	**/
	var NoCheckFileTimeModification = 0;

	/**
		If a file is modified, also checks if its content changed. This check
		is not free, but useful when .hx files are auto-generated.
	**/
	var CheckFileContentModification = 1;

	/**
		Disables dependency checks of the module.
	**/
	var NoCheckDependencies = 2;

	/**
		Disables file shadowing checks. Shadowing can occur when a new file
		is added to a class-path that has higher priority than the class-path
		of the current module file.
	**/
	var NoCheckShadowing = 3;
}

/**
	This class provides some methods which can be invoked from command line using
	`--macro server.field(args)`.
**/
class CompilationServer {
	#if neko

	/**
		Sets the `ModuleCheckPolicy` of all files whose dot-path matches an
		element of `pathFilters`.

		If `recursive` is true, a dot-path is considered matched if it starts
		with the path filter. This automatically applies to path filters of
		packages. Otherwise an exact match is required.

		If an element in `pathFilters` is the empty String `""` it matches
		everything (if `recursive = true`) or only top-level types (if
		`recursive = false`).

		If a call to this function is added to the compilation parameters, the
		compilation server should be restarted to ensure it takes effect.
	**/
	static public function setModuleCheckPolicy(pathFilters:Array<String>, policy:Array<ModuleCheckPolicy>, ?recursive = true) {
		pathFilters = [for (pathFilter in pathFilters) untyped pathFilter.__s];
		@:privateAccess Compiler.load("server_add_module_check_policy", 3)(untyped pathFilters.__neko(), policy.__neko(), recursive);
	}

	/**
		Invalidates all files given in `filePaths`, removing them from the cache.
	**/
	static public function invalidateFiles(filePaths:Array<String>) {
		filePaths = [for (filePath in filePaths) untyped filePath.__s];
		@:privateAccess Compiler.load("server_invalidate_files", 1)(untyped filePaths.__neko());
	}
	#end
}