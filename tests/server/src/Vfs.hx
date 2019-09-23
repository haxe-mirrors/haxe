import haxe.io.Bytes;
import asys.FileSystem as Fs;
import sys.FileSystem;
import haxe.io.Path;

using DateTools;

class Vfs {
	var physicalPath:String;

	public function new(physicalPath:String) {
		this.physicalPath = physicalPath;
		if (FileSystem.exists(physicalPath)) {
			throw 'Cannot create virtual file-system for $physicalPath: directory exists';
		}
		FileSystem.createDirectory(physicalPath);
	}

	public function overwriteContent(path:String, content:String) {
		var path = getPhysicalPath(path).toString();
		if (!FileSystem.exists(path)) {
			throw 'Cannot overwrite content for $path: file does not exist';
		}
		Fs.writeFile(path, Bytes.ofString(content));
	}

	public function putContent(path:String, content:String) {
		var path = getPhysicalPath(path);
		FileSystem.createDirectory(path.dir);
		Fs.writeFile(path.toString(), Bytes.ofString(content));
	}

	public function getContent(path:String) {
		var path = getPhysicalPath(path);
		FileSystem.createDirectory(path.dir);
		return Fs.readFile(path.toString()).toString();
	}

	public function close() {
		removeDir(physicalPath);
	}

	function getPhysicalPath(path:String) {
		return new Path(Path.join([physicalPath, path]));
	}

	static public function removeDir(dir:String):Void {
		if (FileSystem.exists(dir)) {
			for (item in FileSystem.readDirectory(dir)) {
				item = haxe.io.Path.join([dir, item]);
				if (FileSystem.isDirectory(item)) {
					removeDir(item);
				} else {
					FileSystem.deleteFile(item);
				}
			}
			FileSystem.deleteDirectory(dir);
		}
	}
}
