package asys.native.filesystem;

import haxe.io.Bytes;
import asys.native.system.SystemUser;
import asys.native.system.SystemGroup;
import haxe.NoData;
import haxe.exceptions.NotImplementedException;

/**
	File system operations.
**/
@:coreApi
class FileSystem {
	/**
		Open file for reading and/or writing.

		Depending on `flag` value `callback` will be invoked with the appropriate
		object type to read and/or write the file:
		- `asys.native.filesystem.File` for reading and writing;
		- `asys.native.filesystem.FileRead` for reading only;
		- `asys.native.filesystem.FileWrite` for writing only;
		- `asys.native.filesystem.FileAppend` for writing to the end of file only;

		@see asys.native.filesystem.FileOpenFlag for more details.
	**/
	static public function openFile<T>(path:FilePath, flag:FileOpenFlag<T>, callback:Callback<T>):Void {
		throw new NotImplementedException();
	}

	/**
		Create and open a unique temporary file for writing and reading.

		The file will be automatically deleted when it is closed or the program
		terminates.

		Depending on a target platform the file deletion may not be guaranteed if
		application crashes.

		TODO: Can Haxe guarantee automatic file deletion for all targets?
	**/
	static public function tempFile(callback:Callback<File>):Void {
		throw new NotImplementedException();
	}

	/**
		Read the contents of a file specified by `path`.
	**/
	static public function readBytes(path:FilePath, callback:Callback<Bytes>):Void {
		throw new NotImplementedException();
	}

	/**
		Read the contents of a file specified by `path` as a `String`.

		TODO:
		Should this return an error if the file does not contain a valid unicode string?
	**/
	static public function readString(path:FilePath, callback:Callback<String>):Void {
		throw new NotImplementedException();
	}

	/**
		Write `data` into a file specified by `path`

		`flag` controls the behavior.
		By default the file truncated if it exists and created if it does not exist.

		@see asys.native.filesystem.FileOpenFlag for more details.
	**/
	static public function writeBytes(path:FilePath, data:Bytes, flag:FileOpenFlag<Dynamic> = Write, callback:Callback<NoData>):Void {
		throw new NotImplementedException();
	}

	/**
		Write `text` into a file specified by `path`

		`flag` controls the behavior.
		By default the file is truncated if it exists and is created if it does not exist.

		@see asys.native.filesystem.FileOpenFlag for more details.
	**/
	static public function writeString(path:FilePath, text:String, flag:FileOpenFlag<Dynamic> = Write, callback:Callback<NoData>):Void {
		throw new NotImplementedException();
	}

	/**
		Open directory for listing.
	**/
	static public function openDirectory(path:FilePath, callback:Callback<Directory>):Void {
		throw new NotImplementedException();
	}

	/**
		Create a directory.

		Default `permissions` equals to octal `0777`, which means read+write+execution
		permissions for everyone.

		If `recursive` is `true`: create missing directories tree all the way down to `path`.
		If `recursive` is `false`: fail if any parent directory of `path` does not exist.
	**/
	static public function createDirectory(path:FilePath, permissions:FilePermissions = 511, recursive:Bool = false, callback:Callback<NoData>):Void {
		throw new NotImplementedException();
	}

	/**
		Create a unique temporary directory.

		For a directory name `prefix` gets appended with random characters.
		The created directory path is passed to the `callback`.

		Created directory will _not_ be deleted automatically.

		TODO: is it really "temporary"? Probably "unique" would be a better name.
	**/
	static public function tempDirectory(prefix:FilePath, callback:Callback<Directory>):Void {
		throw new NotImplementedException();
	}

	/**
		Move and/or rename the file or directory from `oldPath` to `newPath`.

		If `newPath` already exists and `overwrite` is `true` (which is the default)
		the destination is overwritten.
	**/
	static public function move(oldPath:FilePath, newPath:FilePath, overwrite:Bool = true, callback:Callback<NoData>):Void {
		throw new NotImplementedException();
	}

	/**
		Remove a file or symbolic link.
	**/
	static public function deleteFile(path:FilePath, callback:Callback<NoData>):Void {
		throw new NotImplementedException();
	}

	/**
		Remove an empty directory.
	**/
	static public function deleteDirectory(path:FilePath, callback:Callback<NoData>):Void {
		throw new NotImplementedException();
	}

	/**
		Get file or directory information at the given path.
	**/
	static public function info(path:FilePath, callback:Callback<FileInfo>):Void {
		throw new NotImplementedException();
	}

	/**
		Check user's access for a path.

		Example:
		```haxe
		import asys.native.filesystem.FileAccessMode;
		//check path existence
		FileSystem.check(path, Exists, (error, result) -> trace(result));
		//check if file is executable
		FileSystem.check(path, Executable, (error, result) -> trace(result));
		//check if file is readable and writable
		FileSystem.check(path, Readable | Writable, (error, result) -> trace(result));
		```
	**/
	static public function check(path:FilePath, mode:FileAccessMode, callback:Callback<Bool>):Void {
		throw new NotImplementedException();
	}

	/**
		Check if the path is a directory.
		If `path` is a symbolic links then it will be resolved and checked.
	**/
	static public function isDirectory(path:FilePath, callback:Callback<Bool>):Void {
		throw new NotImplementedException();
	}

	/**
		Check if the path is a regular file.
		If `path` is a symbolic links then it will be resolved and checked.
	**/
	static public function isFile(path:FilePath, callback:Callback<Bool>):Void {
		throw new NotImplementedException();
	}

	/**
		Set path permissions.

		If `recursive` is `true` and `path` points to a directory: apply `permissions`
		recursively to the directory contents as well.
	**/
	static public function setPermissions(path:FilePath, permissions:FilePermissions, recursive:Bool = false, callback:Callback<NoData>):Void {
		throw new NotImplementedException();
	}

	/**
		Set path owner and group.

		If `recursive` is `true` and `path` points to a directory: apply recursively
		to the directory contents as well.
	**/
	static public function setOwner(path:FilePath, user:SystemUser, ?group:SystemGroup, recursive:Bool = false, callback:Callback<NoData>):Void {
		throw new NotImplementedException();
	}

	/**
		Set path owning group.

		If `recursive` is `true` and `path` points to a directory: apply recursively
		to the directory contents as well.
	**/
	static public function setGroup(path:FilePath, group:SystemGroup, recursive:Bool = false, callback:Callback<NoData>):Void {
		throw new NotImplementedException();
	}

	/**
		Create a link to `target` at `path`.

		If `path` is omitted a link to `target` will be created in the current
		directory with the same name as the last component of `target` path.
		For example `FileSystem.link('/path/to/file.ext', callback)` will create
		a link named `file.ext` in the current directory.

		If `type` is `SymLink` the `target` is expected to be an absolute path or
		a path relative to `path`, however the existance of `target` is not checked
		and the link is created even if `target` does not exist.

		If `type` is `HardLink` the `target` is expected to be an existing path either
		absolute or relative to the current working directory.
	**/
	static public function link(target:FilePath, ?path:FilePath, type:FileLink = SymLink, callback:Callback<NoData>):Void {
		throw new NotImplementedException();
	}

	/**
		Check if the path is a symbolic link.
	**/
	static public function isLink(path:FilePath, callback:Callback<Bool>):Void {
		throw new NotImplementedException();
	}

	/**
		Get the value of a symbolic link.
	**/
	static public function readLink(path:FilePath, callback:Callback<FilePath>):Void {
		throw new NotImplementedException();
	}

	/**
		Copy a file from `source` path to `destination` path.
	**/
	static public function copyFile(source:FilePath, destination:FilePath, overwrite:Bool = true, callback:Callback<NoData>):Void {
		throw new NotImplementedException();
	}

	/**
		Shrink or expand a file specified by `path` to `newSize` bytes.

		If the file does not exist, it is created.

		If the file is larger than `newSize`, the extra data is lost.
		If the file is shorter, zero bytes are used to fill the added length.
	**/
	static public function resize(path:FilePath, newSize:Int, callback:Callback<NoData>):Void {
		throw new NotImplementedException();
	}

	/**
		Change access and modification times of a file.

		TODO: Decide on type for `accessTime` and `modificationTime` - see TODO in `asys.native.filesystem.FileInfo.FileStat`
	**/
	static public function setTimes(path:FilePath, accessTime:Int, modificationTime:Int, callback:Callback<NoData>):Void {
		throw new NotImplementedException();
	}
}