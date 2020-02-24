﻿package unit;

import haxe.Exception;
import haxe.ValueException;

private enum EnumError {
	EError;
}

private abstract AbstrString(String) from String {}
private abstract AbstrException(CustomHaxeException) from CustomHaxeException {}

private class CustomHaxeException extends Exception {}

#if php
private class CustomNativeException extends php.Exception {}
#elseif js
private class CustomNativeException extends js.lib.Error {}
#elseif flash
private class CustomNativeException extends flash.errors.Error {}
#elseif java
private class CustomNativeException extends java.lang.RuntimeException {}
#elseif cs
private class CustomNativeException extends cs.system.Exception {}
#elseif python
private class CustomNativeException extends python.Exceptions.Exception {}
#elseif (lua || eval || neko || hl || cpp)
private class CustomNativeException { public function new(m:String) {} }
#end

class TestExceptions extends Test {
	/** Had to move to instance var because of https://github.com/HaxeFoundation/haxe/issues/9174 */
	var rethrown:Bool = false;

	public function testWildCardCatch() {
		try {
			throw 123;
		} catch(e:Dynamic) {
			eq(123, e);
		}

		try {
			throw 123;
		} catch(e:Exception) {
			eq('123', e.message);
			t(Std.isOfType(e, ValueException));
		}
	}

	public function testWildCardCatch_rethrow() {
		var thrown = new CustomHaxeException('');
		rethrown = false;
		try {
			try {
				throw thrown;
			} catch(e:Exception) {
				rethrown = true;
				throw e;
			}
		} catch(e:CustomHaxeException) {
			eq(thrown, e);
			t(rethrown);
		}

		var thrown = new CustomNativeException('');
		rethrown = false;
		try {
			try {
				throw thrown;
			} catch(e:Exception) {
				rethrown = true;
				throw e;
			}
		} catch(e:CustomNativeException) {
			eq(thrown, e);
			t(rethrown);
		}
	}

	public function testSpecificCatch_propagatesUnrelatedExceptions() {
		var propagated = false;
		try {
			try {
				throw new ValueException('hello');
			} catch(e:CustomHaxeException) {
				assert();
			}
			assert();
		} catch(e:ValueException) {
			propagated = true;
		}
		t(propagated);
	}

	public function testCatchAbstract() {
		var a:AbstrString = 'hello';
		try {
			throw a;
		} catch(e:AbstrString) {
			eq(a, e);
		}

		var a:AbstrException = new CustomHaxeException('');
		try {
			throw a;
		} catch(e:AbstrException) {
			eq(a, e);
		}
	}

	public function testValueException() {
		try {
			throw 123;
		} catch(e:ValueException) {
			eq(123, e.value);
		}
		try {
			throw 123;
		} catch(e:Int) {
			eq(123, e);
		}

		try {
			throw EError;
		} catch(e:ValueException) {
			eq('EError', e.message);
		}
		try {
			throw EError;
		} catch(e:EnumError) {
			eq(EError, e);
		}

		try {
			throw 'string';
		} catch(e:ValueException) {
			eq('string', e.value);
		}
		try {
			throw 'string';
		} catch(e:String) {
			eq('string', e);
		}
	}

	public function testCustomNativeException() {
		var thrown = new CustomNativeException('');
		rethrown = false;
		try {
			try {
				throw thrown;
			} catch(e:CustomNativeException) {
				eq(thrown, e);
				rethrown = true;
				throw e;
			}
		} catch(e:CustomNativeException) {
			eq(thrown, e);
			t(rethrown);
		}
	}

	public function testCustomNativeException_thrownAsDynamic() {
		var thrown:Any = new CustomNativeException('');
		rethrown = false;
		try {
			try {
				throw thrown;
			} catch(e:CustomNativeException) {
				eq(thrown, e);
				rethrown = true;
				throw e;
			}
		} catch(e:CustomNativeException) {
			eq(thrown, e);
			t(rethrown);
		}
	}

	public function testCustomHaxeException() {
		var thrown = new CustomHaxeException('');
		rethrown = false;
		try {
			try {
				throw thrown;
			} catch(e:CustomHaxeException) {
				eq(thrown, e);
				rethrown = true;
				throw e;
			}
		} catch(e:CustomHaxeException) {
			eq(thrown, e);
			t(rethrown);
		}
	}

	public function testCustomHaxeException_thrownAsDynamic() {
		var thrown:Any = new CustomHaxeException('');
		rethrown = false;
		try {
			try {
				throw thrown;
			} catch(e:CustomHaxeException) {
				eq(thrown, e);
				rethrown = true;
				throw e;
			}
		} catch(e:CustomHaxeException) {
			eq(thrown, e);
			t(rethrown);
		}
	}

	public function testExceptionStack() {
		function level2() {
			throw 'hello';
		}
		function level1() {
			level2();
		}
		try {
			level1();
		} catch(e:Exception) {
			#if lua
			t(e.stack != null);
			#else
			t(e.stack.length > 0);
			#end
		}
	}
}