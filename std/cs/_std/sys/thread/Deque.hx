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

package sys.thread;

import cs.system.threading.Mutex as NativeMutex;
import cs.system.threading.Thread as NativeThread;
import cs.Lib;

@:coreApi class Deque<T> {
	final storage:Array<T> = [];
	final lockObj = {};

	public function new():Void {
	}

	public function add(i:T):Void {
		Lib.lock(lockObj, {
			storage.push(i);
		});
	}

	public function push(i:T):Void {
		Lib.lock(lockObj, {
			storage.unshift(i);
		});
	}

	public function pop(block:Bool):Null<T> {
		do {
			Lib.lock(lockObj, {
				if(storage.length > 0) {
					return storage.shift(i);
				}
			});
			if(block) {
				NativeThread.Sleep(1);
			}
		} while(block);
		return null;
	}
}